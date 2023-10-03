import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  TextEditingController searchController = TextEditingController();
  CollectionReference<Map<String, dynamic>> databaseRef =
  FirebaseFirestore.instance.collection('Reports');

  bool isMatch(String personName, String searchText) {
    if (searchText.isEmpty) {
      return true;
    } else if (personName.toLowerCase().contains(searchText.toLowerCase())) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {

    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
      ),
      body: Column(
        children: [

          SizedBox(height: 10,),
          //Search field
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
            child: TextFormField(
              keyboardType: TextInputType.text,
              controller: searchController,
              cursorColor: Colors.blue,
              maxLines: 1, // Use the maxLines property from the widget
              decoration: InputDecoration(
                hintText: 'Search by person name',
                fillColor: const Color(0xfff8F9FA),
                hintStyle: TextStyle(fontFamily: 'Rubik Regular', fontSize: screenWidth * 0.040),

                filled: true,
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.blue,
                  size: screenWidth * 0.06,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.lightBlue,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(screenWidth * 0.07),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.lightBlue,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(screenWidth * 0.07),
                ),
              ),
              // validator: (value) {
              //   if (value!.isEmpty) {
              //     return widget.validateText;
              //   }
              //   return null;
              // },
            ),
          ),
          SizedBox(height: 10,),
          
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: databaseRef.snapshots(),
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

                  final filteredReports = reports
                      .where((report) => isMatch(report.personName, searchController.text))
                      .toList();

                  return ListView.builder(
                    itemCount: filteredReports.length,
                    itemBuilder: (context, index) {
                      final report = filteredReports[index];
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
                  return Center(
                    child: Text('No reports found'),
                  );
                }
              },
            ),
          ),
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
