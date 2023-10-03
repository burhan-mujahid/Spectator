import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfilePage extends StatelessWidget {
  final CollectionReference<Map<String, dynamic>> databaseRef =
  FirebaseFirestore.instance.collection('User');

  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.blue[900]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<User?>(
          future: FirebaseAuth.instance.authStateChanges().first,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (snapshot.hasData) {
              final currentUser = snapshot.data;
              if (currentUser != null) {
                return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: databaseRef.doc(currentUser.uid).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    final data = snapshot.data?.data();
                    if (data == null) {
                      return const Text('User data not found.');
                    }

                    return Column(
                      children: [
                        ListTile(
                          title: Text(data['name']),
                          subtitle: Text(data['cnic']),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                data['profile_image_url']),
                          ),
                        ),
                        // Add more widgets to display other user information
                      ],
                    );
                  },
                );
              }
            }

            return const Text('User not found');
          },
        ),
      ),
    );
  }
}
