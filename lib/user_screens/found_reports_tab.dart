import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/catalogue_container.dart';
import '../widgets/latest_entries.dart';
import '../widgets/page_heading.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

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

class FoundReportsTab extends StatefulWidget {
  const FoundReportsTab({Key? key}) : super(key: key);

  @override
  State<FoundReportsTab> createState() => _FoundReportsTabState();
}

class _FoundReportsTabState extends State<FoundReportsTab> {

  final CollectionReference<Map<String, dynamic>> databaseRef =
  FirebaseFirestore.instance.collection('Reports');
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(

        children:   [

          //Page Heading
          const PageHeading(title: 'Found People', subtitle: 'Currently Available List of People Found'),

          //Found Adults container
          InkWell(child: const CatalogueContainer(catalogueTitle: 'Found Adults', listTileImage: AssetImage('images/found_adults.png'), listTileTitle: 'Adults Found', listTileSubtitle: 'List of adults found', listTileTrailing: '2')),

          //Found Children container
          const CatalogueContainer(catalogueTitle: 'Found Children', listTileImage: AssetImage('images/found_children.png'), listTileTitle: 'Children Found', listTileSubtitle: 'List of children found', listTileTrailing: '2'),

          //Found Bodies container
          const CatalogueContainer(catalogueTitle: 'Found Bodies', listTileImage: AssetImage('images/found_bodies.png'), listTileTitle: 'Bodies Found', listTileSubtitle: 'List of bodies found', listTileTrailing: '2'),

          const LatestEntriesSection(),

          SizedBox(height: 20,),

          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: databaseRef.where('reportType', isEqualTo: 'found').snapshots(),
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
                    child: Text('No reports found'),
                  );
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
                              )
                            ]
                        ),
                        child: Center(
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: MediaQuery.of(context).size.width * 0.08,
                              backgroundImage: NetworkImage(report.personImage),
                            ),
                            title: Text(report.personName),
                            subtitle: Text(report.locationLastSeen),
                            trailing: Text(report.personAge, style: const TextStyle(fontSize: 20),),
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
                return Center(
                  child: Text('No reports found'),
                );
              }
            },
          ),

          SizedBox(height: 20,)

        ],


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