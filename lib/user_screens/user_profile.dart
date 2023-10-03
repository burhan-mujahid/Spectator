import 'dart:convert';
//import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'package:spectator/user_screens/add_user_fireStore.dart';
//import 'package:spectator/user_screens/add_user_info.dart';
import 'package:spectator/user_screens/edit_complaint_screen.dart';
import 'package:spectator/user_screens/solved_cases.dart';
import 'package:spectator/user_screens/solved_cases_F.dart';
import 'package:spectator/widgets/add_complaint_button.dart';
import 'package:spectator/widgets/page_heading.dart';
//import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../models/report_model.dart';
import 'package:http/http.dart';
import 'package:uuid/uuid.dart';
//import 'package:flutter_image_compress/flutter_image_compress.dart';
//import 'package:image/image.dart' as img;

import '../providers/report_provider.dart';
import '../ui/auth/login_screen.dart';
import '../utils/utils.dart';
import '../widgets/no_reports_ui.dart';
//import '../widgets/view_image_container.dart';
import 'home_screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final auth = FirebaseAuth.instance;

  final User? currentUser = FirebaseAuth.instance.currentUser;
  final CollectionReference<Map<String, dynamic>> databaseRef =
      FirebaseFirestore.instance.collection('Users');

  final CollectionReference<Map<String, dynamic>> reportDatabaseRef =
      FirebaseFirestore.instance.collection('Reports');

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
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
                          backgroundImage: data != null
                              ? NetworkImage(data['profile_image_url'])
                              : const AssetImage('images/user.jpg')
                                  as ImageProvider<Object>?,
                        ),
                      ),
                      accountName: data != null
                          ? Text(data['name'])
                          : const Text('User data not found.'),
                      accountEmail: data != null
                          ? Text(data['cnic'])
                          : const SizedBox.shrink(),
                    ),

                    //Home Page
                    ListTile(
                      leading: const Icon(Icons.home),
                      title: const Text('Home'),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()));

                      },
                    ),

                    //Profile
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('Profile'),
                      onTap: () {
                        //Navigator.push(context, MaterialPageRoute(builder: (context)=>UserProfileScreen()));
                        //Navigator.pushNamed(context, Profile.id);
                      },
                    ),

                    //log out
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('Log Out'),
                      onTap: () async {
                        try {
                          // Sign out from Firebase Auth
                          await auth.signOut();

                          // Navigate to LoginScreen after successful logout
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                            (Route<dynamic> route) =>
                                false, // Remove all previous routes
                          );
                        } catch (error) {
                          // Handle logout error
                          Utils().toastMessage(
                              'Error: Unable to log out. Please try again.');
                        }
                      },
                    ),
                  ],
                );
              },
            ),
          ),
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
            bottom: const TabBar(
              tabs: [
                Tab(
                  child: Text('Personal Info'),
                ),
                Tab(
                  child: Text('Complaints'),
                ),
              ],
            ),


          ),





          // actions: [
          //   IconButton(
          //     icon: const Icon(Icons.person, size: 28),
          //     onPressed: () {
          //       Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               builder: (context) => UserProfileScreen()));
          //       //Navigator.pushNamed(context, Profile.id);
          //     },
          //   ),
          //
          //
          //   // PopupMenuButton(
          //   //     icon: const Icon(Icons.more_vert),
          //   //     itemBuilder: (
          //   //       context,
          //   //     ) =>
          //   //         const [
          //   //           PopupMenuItem(
          //   //               value: 1, child: Text('Starred Messages')),
          //   //           PopupMenuItem(value: 1, child: Text('Settings'))
          //   //         ]),
          //   const SizedBox(
          //     width: 10,
          //   ),
         // ]),




          body: TabBarView(
            children: [
              //Personal Information Tab
              SingleChildScrollView(
                child: Column(
                  children: [
                    PageHeading(
                        title: "Personal Information",
                        subtitle: "View your personal information"),
                    SizedBox(
                      height: 10,
                    ),
                    SingleChildScrollView(
                      child: FutureBuilder<User?>(
                        future: FirebaseAuth.instance.authStateChanges().first,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }

                          if (snapshot.hasData) {
                            final currentUser = snapshot.data;
                            if (currentUser != null) {
                              return StreamBuilder<
                                  DocumentSnapshot<Map<String, dynamic>>>(
                                stream: databaseRef
                                    .doc(currentUser.uid)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  }

                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }

                                  final data = snapshot.data?.data();
                                  if (data == null) {
                                    return const Text('User data not found.');
                                  }

                                  return Column(
                                    children: [
                                      SizedBox(height: 10),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.40,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.4,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey.shade400,
                                                    blurRadius: 10,
                                                  ),
                                                ],
                                                image: DecorationImage(
                                                  image: NetworkImage(data[
                                                      'profile_image_url']),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 4, vertical: 4),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    data['name'],
                                                    style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.05,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(height: 8),
                                                  Text(
                                                    data['cnic'],
                                                    style: TextStyle(
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.04),
                                                  ),
                                                  SizedBox(height: 8),
                                                  Text(
                                                    data['phone_number'],
                                                    style: TextStyle(
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.04),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Text(
                                          'CNIC Images',
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.04,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.40,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.4,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey.shade400,
                                                    blurRadius: 10,
                                                  ),
                                                ],
                                                image: DecorationImage(
                                                  image: NetworkImage(data[
                                                      'cnic_image_front_url']),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.40,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.4,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey.shade400,
                                                    blurRadius: 10,
                                                  ),
                                                ],
                                                image: DecorationImage(
                                                  image: NetworkImage(data[
                                                      'cnic_image_back_url']),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ],
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
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),

              //User Complaints Tab
              SingleChildScrollView(
                child: Column(
                  children: [
                    PageHeading(
                        title: "Your Complaints",
                        subtitle: "View your complaints"),
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: reportDatabaseRef
                          .where('reportedBy',
                              isEqualTo: currentUser
                                  ?.uid) // Filter reports by the current user
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasData) {
                          final reports = snapshot.data!.docs.map((doc) {
                            final data = doc.data();
                            return Report(
                              reportId: data['reportId'] ?? '',
                              reportType: data['reportType'] ?? '',
                              foundSubCategory:
                                  data['foundSubCategory'] ?? 'Null',
                              personName: data['personName'] ?? '',
                              personAge: data['personAge'] ?? '',
                              personGender: data['personGender'] ?? '',
                              personDescription:
                                  data['personDescription'] ?? '',
                              contactName: data['contactName'] ?? '',
                              contactRelation: data['contactRelation'] ?? '',
                              contact: data['contact'] ?? '',
                              dateLastSeen: data['dateLastSeen'] ?? '',
                              locationLastSeen: data['locationLastSeen'] ?? '',
                              city: data['city'] ?? '',
                              personImage: data['personImage'] ?? '',
                              reportedBy: data['reportedBy'] ?? '',
                              // createdAt:
                              //     (data['createdAt'] as Timestamp).toDate(),
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 10),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.width * 0.22,
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade400,
                                        blurRadius: 10,
                                      )
                                    ],
                                  ),
                                  child: Center(
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        radius:
                                            MediaQuery.of(context).size.width *
                                                0.08,
                                        backgroundImage:
                                            NetworkImage(report.personImage),
                                      ),
                                      title: Text(report.personName),
                                      subtitle: Text(report.locationLastSeen +
                                          ", " +
                                          report.city),
                                      trailing: Text(
                                        report.personAge,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PersonInformationScreen(
                                                    report: report),
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
                  ],
                ),
              )
            ],
          ),
          // floatingActionButton: AddButton(
          //     actionButtonIcon: Icon(Icons.file_copy_sharp),
          //     pageRoute: MaterialPageRoute(
          //         builder: (context) =>
          //             AddUserInfoFirestore(user: currentUser!))),
        ));
  }
}

class UpdatedReport {
  final String reportId;
  final String reportType;
  final String personName;
  final String personAge;
  final String personGender;
  final String personDescription;
  final String dateLastSeen;
  final String contactName;
  final String contactRelation;
  final String contact;
  final String city;
  final String locationLastSeen;
  final String personImage;
  final String reportedBy;

  UpdatedReport({
    required this.reportId,
    required this.reportType,
    required this.personName,
    required this.personAge,
    required this.personGender,
    required this.personDescription,
    required this.dateLastSeen,
    required this.contactName,
    required this.contactRelation,
    required this.contact,
    required this.city,
    required this.locationLastSeen,
    required this.personImage,
    required this.reportedBy,
  });
  Report toReport() {
    return Report(
      reportId: reportId,
      reportType: reportType,
      foundSubCategory: '',
      personName: personName,
      personAge: personAge,
      personGender: personGender,
      personDescription: personDescription,
      dateLastSeen: dateLastSeen,
      contactName: contactName,
      contactRelation: contactRelation,
      contact: contact,
      city: city,
      locationLastSeen: locationLastSeen,
      personImage: personImage,
      reportedBy: reportedBy,
      // createdAt: DateTime.now(),
    );
  }
}

class PersonInformationScreen extends StatefulWidget {
  final Report report;

  const PersonInformationScreen({required this.report});

  @override
  _PersonInformationScreenState createState() =>
      _PersonInformationScreenState();
}

class _PersonInformationScreenState extends State<PersonInformationScreen> {
  bool _loading = false;
  bool _matchFound = false;
  String? _secondImageUrl;
  List<String> _personImageUrls = [];

  Map<String, dynamic>? _secondReportData;


  @override
  void initState() {
    super.initState();
    _loadPersonImageUrls();
  }

  Future<void> _loadPersonImageUrls() async {
    String reportType = widget.report.reportType;
    final snapshot = await FirebaseFirestore.instance
        .collection('Reports')
        .where('reportType', isEqualTo: reportType == 'lost' ? 'found' : 'lost')
        .get();

    final urls =
    snapshot.docs.map((doc) => doc['personImage'] as String).toList();

    setState(() {
      _personImageUrls = urls;
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> fetchReportDataByImage(String imageUrl) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Reports')
        .where('personImage', isEqualTo: imageUrl)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first;
    }

    return null;
  }



  Future<void> _handleSearch() async {
    const apiKey = 'UwhY1BtTESn90qRgrIEqIT59XAu_ojiA';
    const apiSecret = 'jvK6nqz5bIh_oLd-ivhkvXBPTeAbm8wk';
    final imageUrl1 = widget.report.personImage;

    for (final imageUrl2 in _personImageUrls) {
      try {
        setState(() {
          _loading = true;
          _matchFound = false;
          _secondImageUrl = null;
        });

        final response = await post(
          Uri.parse('https://api-us.faceplusplus.com/facepp/v3/compare'),
          body: {
            'api_key': apiKey,
            'api_secret': apiSecret,
            'image_url1': imageUrl1,
            'image_url2': imageUrl2,
          },
        );

        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          final confidence = jsonResponse['confidence'] ?? 0.0;

          print(jsonResponse);

          if (confidence >=80) {
            setState(() {
              _matchFound = true;
              _secondImageUrl = imageUrl2;
            });

            final firstReportSnapshot = await fetchReportDataByImage(imageUrl1);
            final secondReportSnapshot = await fetchReportDataByImage(_secondImageUrl!);

            if (firstReportSnapshot != null && secondReportSnapshot != null) {
              final firstReportData = firstReportSnapshot.data()!;
              final secondReportData = secondReportSnapshot.data()!;

              final solvedCasesCollection = FirebaseFirestore.instance.collection('SolvedCases');
              final uuid = Uuid();
              final solvedCaseId = uuid.v4(); // Generate a UUID

              // Save both reports to "Solved Cases" collection
              await solvedCasesCollection.doc(solvedCaseId).set({
                'firstReport': firstReportData,
                'secondReport': secondReportData,
                'timestamp': FieldValue.serverTimestamp(),
              });
            }

            break; // Stop checking further URLs since a match is found
          }
        }
      } catch (e) {
        print('API Error: $e');
      } finally {
        setState(() {
          _loading = false;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final reportProvider = Provider.of<ReportProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Person Information'),


        actions: [
          PopupMenuButton(
              icon: const Icon(Icons.more_vert),
              itemBuilder: (
                  context,
                  ) =>
              [
                PopupMenuItem(
                  value: 1,
                  child:  ListTile(
                    leading:  Icon(Icons.edit, color: Colors.blue,),
                    title: Text('Edit Report'),
                    onTap: () async {
                      final updatedReport = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditComplaintScreen(
                            reportId: widget.report.reportId,
                          ),
                        ),
                      );

                      if (updatedReport != null &&
                          updatedReport is UpdatedReport) {
                        // Update the UI with the new data from the updated report
                        reportProvider.updateReport(updatedReport.toReport());
                      }
                    },
                  ),
                ),

                PopupMenuItem(
                    value: 1,
                    child: ListTile(
                      leading:  Icon(Icons.delete, color: Colors.red,),
                      title: Text('Delete Report'),
                      onTap: _handleDelete,
                    )
                )
              ]),
        ],

      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   crossAxisAlignment: CrossAxisAlignment.end,
            //   children: [
            //     ElevatedButton(
            //       onPressed: _loading
            //           ? null
            //           : () async {
            //         await _handleSearch();
            //
            //         // Show "We are sorry" if no match is found
            //         if (!_matchFound || _personImageUrls.isEmpty) {
            //           showDialog(
            //             context: context,
            //             builder: (context) => const AlertDialog(
            //               content: Text(
            //                 'We are sorry, No reports found',
            //                 style: TextStyle(
            //                   color: Colors.red,
            //                   fontWeight: FontWeight.bold,
            //                   fontSize: 20,
            //                 ),
            //               ),
            //             ),
            //           );
            //         }
            //       },
            //       style: ElevatedButton.styleFrom(primary: Colors.green),
            //       child:
            //       _loading ? Text('Processing...') : Text('Start Search'),
            //     ),
            //   ],
            // ),

            //image container
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FullScreenImage(imageUrl: widget.report.personImage),
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
                    imageProvider: NetworkImage(widget.report.personImage),
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

            //Person Details Heading
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

            //Information table
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
                          widget.report.personName,
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
                          widget.report.personGender,
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
                          widget.report.personAge,
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
                          widget.report.personDescription,
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
                          widget.report.dateLastSeen,
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
                          widget.report.locationLastSeen,
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
                          widget.report.city,
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
                          widget.report.contactName,
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
                        DataCell(Text(
                          widget.report.contact,
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        )),
                      ],
                    ),
                    // DataRow(
                    //   cells: [
                    //     DataCell(Text(
                    //       'Report Id',
                    //       style: TextStyle(
                    //         fontWeight: FontWeight.bold,
                    //         fontSize: 16.0,
                    //       ),
                    //     )),
                    //     DataCell(Text(
                    //       widget.report.reportId,
                    //       style: TextStyle(
                    //         fontSize: 16.0,
                    //       ),
                    //     )),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),

            // Edit and Delete buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // ElevatedButton(
                  //   onPressed: () async {
                  //     final updatedReport = await Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => EditComplaintScreen(
                  //           reportId: widget.report.reportId,
                  //         ),
                  //       ),
                  //     );
                  //
                  //     if (updatedReport != null &&
                  //         updatedReport is UpdatedReport) {
                  //       // Update the UI with the new data from the updated report
                  //       reportProvider.updateReport(updatedReport.toReport());
                  //     }
                  //   },
                  //   child: Text('Edit'),
                  // ),
                  SizedBox(width: 5),
                  ElevatedButton(
                    onPressed: _loading
                        ? null
                        : () async {
                            await _handleSearch();

                            // Show "We are sorry" if no match is found
                            if (!_matchFound || _personImageUrls.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (context) => const AlertDialog(
                                  content: Text(
                                    'We are sorry, No reports found',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(primary: Colors.green),
                    child:
                        _loading ? Text('Processing...') : Text('Start Search'),
                  ),
                  SizedBox(width: 5),
                  // ElevatedButton(
                  //   onPressed: _handleDelete,
                  //   style: ElevatedButton.styleFrom(primary: Colors.red),
                  //   child: Text('Delete'),
                  // ),
                ],
              ),
            ),
            if (_matchFound && _secondImageUrl != null)
              Column(
                children: [
                  SizedBox(height: 16.0),
                  const Center(
                    child: Text(
                      'Match Found',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    height: MediaQuery.of(context).size.width * 0.5,
                    width: MediaQuery.of(context).size.width * 0.5,
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
                      imageProvider: NetworkImage(_secondImageUrl!),
                      minScale: PhotoViewComputedScale.contained,
                      maxScale: PhotoViewComputedScale.covered * 2.0,
                      backgroundDecoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SolvedCasesPage2()));
                    },
                    child: Text('View Matched Reports'),
                  ),
                ],
              ),

          ],
        ),
      ),
    );
  }

  void _handleDelete() {
    // Show a confirmation dialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Report'),
          content: const Text('Are you sure you want to delete this report?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: _confirmDeleteReport,
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteReport() async {
    final reportDatabaseRef = FirebaseFirestore.instance.collection('Reports');
    try {
      await reportDatabaseRef.doc(widget.report.reportId).delete();
      Utils().toastMessage('Report Deleted Successfully');
      Navigator.pop(context);
    } catch (e) {
      // Log any errors that occur during deletion
      print('Error deleting report: $e');
      Utils().toastMessage('Error deleting report: $e');
    }
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PhotoViewGallery(
        backgroundDecoration: const BoxDecoration(
          color: Colors.black,
        ),
        pageOptions: [
          PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(imageUrl),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2.0,
          ),
        ],
        loadingBuilder: (context, event) => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
