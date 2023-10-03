import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:spectator/widgets/no_reports_ui.dart';


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
    this.foundSubCategory,
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


class MissingChildrenPage extends StatelessWidget {
  final CollectionReference<Map<String, dynamic>> databaseRef =
  FirebaseFirestore.instance.collection('Reports');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Missing Adults'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: databaseRef
            .where('reportType', isEqualTo: 'lost')
            .where('personAge', isLessThan: '18')
            .snapshots(),
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
                foundSubCategory: data['foundSubCategory'],
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
              return NoUsers();
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: reports.length,
              itemBuilder: (context, index) {
                final report = reports[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: Container(
                    height: MediaQuery.of(context).size.width * 0.22,
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade400,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Center(
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: MediaQuery.of(context).size.width * 0.08,
                          backgroundImage: NetworkImage(report.personImage),
                        ),
                        title: Text(report.personName),
                        subtitle: Text(report.locationLastSeen),
                        trailing: Text(
                          report.personAge,
                          style: const TextStyle(fontSize: 20),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PersonInformationScreen(report: report),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching reports'),
            );
          } else {
            return NoUsers();
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreenImage(imageUrl: report.personImage),
                    ),
                  );
                },
                child: Container(
                  height: MediaQuery.of(context).size.width * 0.7,
                  width: MediaQuery.of(context).size.width * 0.7,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: PhotoView(
                    imageProvider: NetworkImage(report.personImage),
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.covered * 2.0,
                    backgroundDecoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Person Details',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 16.0),
            DataTableTheme(
              data: DataTableThemeData(
                dividerThickness: 1.0,
                dataRowColor: MaterialStateColor.resolveWith((states) => Colors.grey.shade200),
                headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey.shade200),
                headingRowHeight: 48.0,
              ),
              child: DataTable(
                columnSpacing: 16.0,
                columns: [
                  DataColumn(
                    label: Text(
                      'Field',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Information',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ],
                rows: [
                  DataRow(
                    cells: [
                      DataCell(Text(
                        'Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      )),
                      DataCell(Text(
                        report.personName,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      )),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text(
                        'Gender',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      )),
                      DataCell(Text(
                        report.personGender,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      )),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text(
                        'Age',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      )),
                      DataCell(Text(
                        report.personAge,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      )),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text(
                        'Description',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      )),
                      DataCell(Text(
                        report.personDescription,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      )),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text(
                        'Date Last Seen',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      )),
                      DataCell(Text(
                        report.dateLastSeen,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      )),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text(
                        'Location Last Seen',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      )),
                      DataCell(Text(
                        report.locationLastSeen,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      )),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text(
                        'Reported By',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      )),
                      DataCell(Text(
                        report.reportedBy,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      )),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}



class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: PhotoViewGallery(
          backgroundDecoration: BoxDecoration(
            color: Colors.black,
          ),
          pageOptions: [
            PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(imageUrl),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2.0,
            ),
          ],
          loadingBuilder: (context, event) => Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}