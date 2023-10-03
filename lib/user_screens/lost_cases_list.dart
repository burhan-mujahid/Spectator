import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  final String reportType;
  final String? foundSubCategory;
  final String personName;
  final String personAge;
  final String personGender;
  final String personDescription;
  final String dateLastSeen;
  final String locationLastSeen;
  final String personImage;
  final String reportedBy;
  final DateTime createdAt;

  Report({
    required this.reportType,
    required this.foundSubCategory,
    required this.personName,
    required this.personAge,
    required this.personGender,
    required this.personDescription,
    required this.dateLastSeen,
    required this.locationLastSeen,
    required this.personImage,
    required this.reportedBy,
    required this.createdAt,
  });
}

class ReportScreen extends StatelessWidget {
  final CollectionReference<Map<String, dynamic>> databaseRef =
  FirebaseFirestore.instance.collection('Reports');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: databaseRef.where('reportType', isEqualTo: 'lost').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            final reports = snapshot.data!.docs.map((doc) {
              final data = doc.data();
              return Report(
                reportType: data['reportType'] ?? '',
                foundSubCategory: data['foundSubCategory'] ?? 'Null',
                personName: data['personName'] ?? '',
                personAge: data['personAge'] ?? '',
                personGender: data['personGender'] ?? '',
                personDescription: data['personDescription'] ?? '',
                dateLastSeen: data['dateLastSeen'] ?? '',
                locationLastSeen: data['locationLastSeen'] ?? '',
                personImage: data['personImage'] ?? '',
                reportedBy: data['reportedBy'] ?? '',
                createdAt: (data['createdAt'] as Timestamp).toDate(),
              );
            }).toList();

            if (reports.isEmpty) {
              return Center(
                child: Text('No lost reports found'),
              );
            }

            return ListView.builder(
              itemCount: reports.length,
              itemBuilder: (context, index) {
                final report = reports[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(report.personImage),
                  ),
                  title: Text(report.personName),
                  subtitle: Text(report.locationLastSeen),
                  trailing: Text(report.personAge),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PersonInformationScreen(report: report),
                      ),
                    );
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching reports'),
            );
          } else {
            return Center(
              child: Text('No reports found'),
            );
          }
        },
      ),
    );
  }
}

class PersonInformationScreen extends StatelessWidget {
  final Report report;

  const PersonInformationScreen({required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Person Information'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(report.personImage),
              ),
              SizedBox(height: 16.0),
              Text('Name: ${report.personName}'),
              Text('Age: ${report.personAge}'),
              Text('Gender: ${report.personGender}'),
              Text('Description: ${report.personDescription}'),
              Text('Date Last Seen: ${report.dateLastSeen}'),
              Text('Location Last Seen: ${report.locationLastSeen}'),
              Text('Reported By: ${report.reportedBy}'),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
