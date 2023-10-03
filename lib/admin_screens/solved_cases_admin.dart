import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../utils/utils.dart';

class SolvedCasesAdmin extends StatefulWidget {
  @override
  _SolvedCasesAdminState createState() => _SolvedCasesAdminState();
}

class _SolvedCasesAdminState extends State<SolvedCasesAdmin> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> solvedCasesStream;

  @override
  void initState() {
    super.initState();
    solvedCasesStream = FirebaseFirestore.instance.collection('SolvedCases')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: solvedCasesStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No solved cases available.'));
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final solvedCase = snapshot.data!.docs[index];
            final firstReport = solvedCase['firstReport'] as Map<String, dynamic>;
            final secondReport = solvedCase['secondReport'] as Map<String, dynamic>;
            final timestamp = (solvedCase['timestamp'] as Timestamp).toDate();

            return Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.width * 0.05),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
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
                  child: Column(
                    children: [
                      ListTile(
                        title: Text('Solved: ${firstReport['personName']}', style: TextStyle(color: Colors.green),),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PersonInformationScreen(report: firstReport),
                            ),
                          );
                        },
                        child: Container(
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
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: MediaQuery.of(context).size.width * 0.08,
                                backgroundImage: NetworkImage(firstReport['personImage']),
                              ),
                              title: Text(firstReport['personName']),
                              subtitle:  Text('${firstReport['locationLastSeen']}, ${firstReport['city']}'),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.width * 0.05),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PersonInformationScreen(report: secondReport),
                            ),
                          );
                        },
                        child: Container(
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
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: MediaQuery.of(context).size.width * 0.08,
                                backgroundImage: NetworkImage(secondReport['personImage']),
                              ),
                              title: Text(secondReport['personName']),
                              subtitle: Text('${secondReport['locationLastSeen']}, ${secondReport['city']}'),
                            ),
                          ),
                        ),
                      ),
                      Divider(),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class PersonInformationScreen extends StatelessWidget {
  final Map<String, dynamic> report;

  const PersonInformationScreen({required this.report});

  void _launchPhoneDialer(String? phoneNumber) async {
    final url = 'tel:$phoneNumber';
    try {
      if (await canLaunchUrlString(url.toString())) {
        await launchUrlString(url.toString());
        Utils().toastMessage('Heading to Phone Dialer');
      } else {
        Utils().toastMessage('Cannot Launch Phone Dialer');
        throw 'Could not launch phone dialer';
      }
    } catch (e) {
      Utils().toastMessage('Error launching phone dialer: $e');
    }
  }

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
                          builder: (context) => FullScreenImage(imageUrl: report['personImage']),
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
                        imageProvider: NetworkImage(report['personImage']),
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
                Center(
                  child: Text(
                    'Person Details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.9,
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
                              report!['personName'] ?? '',
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
                              report['personGender'] ?? '',
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
                              report['personAge'] ?? '',
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
                              report!['personDescription'] ?? '',
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            )),
                          ],
                        ),
                        DataRow(
                          cells: [
                            DataCell(Text(
                              'Date',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            )),
                            DataCell(Text(
                              report['dateLastSeen'] ?? '',
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            )),
                          ],
                        ),
                        DataRow(
                          cells: [
                            DataCell(Text(
                              'Location',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            )),
                            DataCell(Text(
                              report['locationLastSeen'] ?? '',
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            )),
                          ],
                        ),
                        DataRow(
                          cells: [
                            DataCell(Text(
                              'City',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            )),
                            DataCell(Text(
                              report!['city'] ?? '',
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            )),
                          ],
                        ),
                        DataRow(
                          cells: [
                            DataCell(Text(
                              'Contact Name',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            )),
                            DataCell(Text(
                              report!['contactName'] ?? '',
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            )),
                          ],
                        ),
                        DataRow(
                          cells: [
                            DataCell(Text(
                              'Contact Number',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            )),
                            DataCell(
                                InkWell(
                                  onTap: (){
                                    _launchPhoneDialer(report['contact']);
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        report['contact'] ?? '',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),

                                      Icon(Icons.call, color: Colors.blue,)
                                    ],
                                  ),
                                )
                            ),
                          ],
                        ),
                        //     // DataRow(
                        //     //   cells: [
                        //     //     DataCell(Text(
                        //     //       'Report Id',
                        //     //       style: TextStyle(
                        //     //         fontWeight: FontWeight.bold,
                        //     //         fontSize: 16.0,
                        //     //       ),
                        //     //     )),
                        //     //     DataCell(Text(
                        //     //       widget.report.reportId,
                        //     //       style: TextStyle(
                        //     //         fontSize: 16.0,
                        //     //       ),
                        //     //     )),
                        //     //   ],
                        //     // ),
                        //   ],
                        // )

                      ],
                    ),
                  ),
                ),
              ]
          ),
        ));
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
