import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spectator/user_screens/add_complaint.dart';
import 'package:spectator/user_screens/add_complaint_F.dart';
import 'package:spectator/user_screens/add_complaint_Screen.dart';
import 'package:spectator/user_screens/found_reports_tab.dart';
import 'package:spectator/user_screens/lost_cases_tab.dart';
import 'package:spectator/user_screens/match_tab.dart';
import 'package:spectator/user_screens/reports_screen.dart';
import 'package:spectator/user_screens/search_screen.dart';
import 'package:spectator/user_screens/solved_cases.dart';
import 'package:spectator/user_screens/solved_cases_F.dart';
import 'package:spectator/user_screens/solved_cases_R.dart';
import 'package:spectator/user_screens/sos_tab.dart';
import 'package:spectator/user_screens/user_profile.dart';
import 'package:spectator/widgets/catalogue_container.dart';
import 'package:spectator/widgets/latest_entries.dart';
import 'package:spectator/widgets/page_heading.dart';

import '../ui/auth/login_screen.dart';
import '../utils/utils.dart';
import '../widgets/add_complaint_button.dart';
import '../widgets/sos_catalogue_container.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'homescreen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final auth = FirebaseAuth.instance;

  final User? currentUser = FirebaseAuth.instance.currentUser;
  final CollectionReference<Map<String, dynamic>> databaseRef =
  FirebaseFirestore.instance.collection('Users');

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          drawer: Drawer(
            child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: databaseRef.doc(currentUser!.uid).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                final data = snapshot.data?.data();

                return ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    UserAccountsDrawerHeader(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.blue, Colors.blue.shade900],
                        ),
                      ),
                      currentAccountPicture: InkWell(
                        onTap: () {
                          //Navigator.pushNamed(context, Profile.id);
                        },
                        child: CircleAvatar(
                          backgroundImage: data != null ? NetworkImage(data['profile_image_url']) : AssetImage('images/user.jpg') as ImageProvider<Object>?,
                        ),
                      ),
                      accountName: data != null ? Text(data['name']) : const Text('User data not found.'),
                      accountEmail: data != null ? Text(data['cnic']) : const SizedBox.shrink(),
                    ),

                    //Home Page
                    ListTile(
                      leading: Icon(Icons.home),
                      title: Text('Home'),
                      onTap: () {
                        //Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                        // Navigator.pushNamed(context, Homescreen.id);
                      },
                    ),

                    //Profile
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Profile'),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>UserProfileScreen()));
                        //Navigator.pushNamed(context, Profile.id);
                      },
                    ),

                    //log out
                    ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Log Out'),
                      onTap: () async {
                        try {
                          // Sign out from Firebase Auth
                          await auth.signOut();

                          // Navigate to LoginScreen after successful logout
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                                (Route<dynamic> route) => false, // Remove all previous routes
                          );
                        } catch (error) {
                          // Handle logout error
                          Utils().toastMessage('Error: Unable to log out. Please try again.');
                        }
                      },
                    ),
                  ],
                );
              },
            ),
          ),


          appBar: AppBar(
              title: const Text('Spectator'),
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
              bottom: const TabBar(
                tabs: [
                  // Tab(
                  //   child: Text('Match'),
                  // ),
                  Tab(
                    child: Text('Reports'),
                  ),
                  Tab(
                    child: Text('Solved Cases'),
                  ),
                  Tab(
                    child: Text('SOS'),
                  ),
                  // Tab(
                  //   child: Text('Calls'),
                  // ),
                ],
              ),
              actions: [

                //view reports
                IconButton(
                  icon: const Icon(Icons.file_copy_sharp, size: 28),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>AddComplaintScreenF()));
                    // Navigator.pushNamed(context, Profile.id);
                  },
                ),
                //
                // //add complaint button
                // IconButton(
                //   icon: const Icon(Icons.add, size: 28),
                //   onPressed: () {
                //     Navigator.push(context, MaterialPageRoute(builder: (context)=>SolvedCasesPage()));
                //    // Navigator.pushNamed(context, Profile.id);
                //   },
                // ),
                //
                //
                // //search button
                // IconButton(
                //   icon: const Icon(Icons.file_open, size: 28),
                //   onPressed: () {
                //    Navigator.push(context, MaterialPageRoute(builder: (context)=>AddComplaintScreenF()));
                //     // Navigator.pushNamed(context, Profile.id);
                //   },
                // ),
                //
                // //V2 Add Complaint
                // IconButton(
                //   icon: const Icon(Icons.done_all, size: 28, color: Colors.green,),
                //   onPressed: () {
                //     Navigator.push(context, MaterialPageRoute(builder: (context)=>SolvedCases()));
                //     // Navigator.pushNamed(context, Profile.id);
                //   },
                // ),



              ]),

          body: TabBarView(
            children: [


              //Reports Page
              ReportsPage(),



              //Match Tab
              SolvedCasesPageR(),


              //SOS Contacts Tab
              SOSTab(),

            ],
          ),
          // floatingActionButton: AddButton(
          //     actionButtonIcon: Icon(Icons.file_copy_sharp),
          //     pageRoute: MaterialPageRoute(
          //         builder: (context) =>AddComplaintScreenF())),

        )
    );
  }
}
