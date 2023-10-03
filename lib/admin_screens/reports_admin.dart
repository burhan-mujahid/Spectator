import 'dart:core';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:spectator/user_screens/found_adults_page.dart';
import 'package:spectator/user_screens/found_children_page.dart';
import 'package:spectator/user_screens/missing_adults_page.dart';
import 'package:spectator/user_screens/missing_children_page.dart';
import 'package:spectator/widgets/categories_container.dart';
import 'package:url_launcher/url_launcher_string.dart';
//import '../models/report_model.dart';

import '../user_screens/found_body_page.dart';
import '../utils/utils.dart';
import '../widgets/catalogue_container.dart';
import '../widgets/categories_popup_button.dart';
import '../widgets/no_reports_ui.dart';


class Report {
  final String reportId;
  final String reportType;
  final String? foundSubCategory;
  final String personName;
  final String personAge;
  final String personGender;
  final String personDescription;
  final String contactName;
  final String contactRelation;
  final String contact;
  final String dateLastSeen;
  final String locationLastSeen;
  final String city;
  final String personImage;
  final String reportedBy;
  // final DateTime createdAt;

  String get personGenderLowerCase => personGender.toLowerCase();

  Report({
    required this.reportId,
    required this.reportType,
    required this.foundSubCategory,
    required this.personName,
    required this.personAge,
    required this.personGender,
    required this.personDescription,
    required this.contactName,
    required this.contactRelation,
    required this.contact,
    required this.dateLastSeen,
    required this.locationLastSeen,
    required this.city,
    required this.personImage,
    required this.reportedBy,
    //required this.createdAt,
  });
}

class ReportsAdmin extends StatefulWidget {
  const ReportsAdmin({Key? key}) : super(key: key);

  @override
  _ReportsAdminState createState() => _ReportsAdminState();
}

class _ReportsAdminState extends State<ReportsAdmin> {
  TextEditingController nameSearchController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  CollectionReference<Map<String, dynamic>> databaseRef =
  FirebaseFirestore.instance.collection('Reports');

  String selectedCategory = 'All Categories';
  String selectedGender = 'All Genders';


  //Name Search
  bool isNameMatch(String personName, String searchText) {
    if (searchText.isEmpty) {
      return true;
    } else {
      return personName.toLowerCase().contains(searchText.toLowerCase());
    }
  }

  //Location Search
  bool isLocationMatch(String locationLastSeen, String searchText) {
    if (searchText.isEmpty) {
      return true;
    } else {
      return locationLastSeen.toLowerCase().contains(searchText.toLowerCase());
    }
  }


  List<String> genders = ['All Genders', 'Male', 'Female', 'Other'];

  Stream<QuerySnapshot<Map<String, dynamic>>> getReportsStream() {
    Query<Map<String, dynamic>> query = databaseRef;


    if (selectedGender != 'All Genders') {
      query = query.where('personGender', isEqualTo: selectedGender);
    }

    if (ageController.text.isNotEmpty) {
      query = query.where('personAge', isEqualTo: ageController.text);
    }

    if (cityController.text.isNotEmpty) {
      query = query.where('locationLastSeen', isEqualTo: cityController.text);
    }

    return query.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Expanded(
      child: Column(
        children: [
          SizedBox(height: 10),
          // Filter dropdowns

          // Name and Category filter
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Person Name Filter
                Expanded(
                  flex: 9,
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: nameSearchController,
                    cursorColor: Colors.blue,
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: 'Person Name',
                      fillColor: const Color(0xfff8F9FA),
                      hintStyle: TextStyle(
                        fontFamily: 'Rubik Regular',
                        fontSize: 15,
                      ),
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.lightBlue,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.lightBlue,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),

                Expanded(
                  flex: 1,
                  child: InkWell(
                    child: IconButton(
                      icon: Icon(Icons.grid_view_rounded, size: MediaQuery.of(context).size.width*0.07,),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Center(child: Text('Browse by Categories', style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.04),),),
                                  Divider(height:  MediaQuery.of(context).size.width*0.02,thickness: 2,color: Colors.blueAccent,),

                                  //lost Adults
                                  InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>MissingAdultsPage()));
                                    },
                                    child: CategoriesContainer(listTileImage: AssetImage('images/missing_adult.png'),
                                        listTileTitle: 'Missing Adults',
                                        listTileSubtitle: 'List of adults lost'),
                                  ),

                                  //Lost Children
                                  InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>MissingChildrenPage()));
                                    },
                                    child: CategoriesContainer(listTileImage: AssetImage('images/missing_children.png'),
                                        listTileTitle: 'Missing Children',
                                        listTileSubtitle: 'List of children lost'),
                                  ),


                                  //Found Adults
                                  InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>FoundAdultsPage()));
                                    },
                                    child: CategoriesContainer(listTileImage: AssetImage('images/found_adults.png'),
                                        listTileTitle: 'Found Adults',
                                        listTileSubtitle: 'List of adults found '),
                                  ),

                                  //Found Children
                                  InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>FoundChildrenPage()));
                                    },
                                    child: CategoriesContainer(listTileImage: AssetImage('images/found_children.png'),
                                        listTileTitle: 'Found Children',
                                        listTileSubtitle: 'List of children found '),
                                  ),

                                  //Found Bodies
                                  InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>FoundBodiesPage()));
                                    },
                                    child: CategoriesContainer(listTileImage: AssetImage('images/found_bodies.png'),
                                        listTileTitle: 'Found Bodies',
                                        listTileSubtitle: 'List of bodies found '),
                                  ),


                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )

                //Category Icon

              ],
            ),

          ),

          SizedBox(height: 10),

          // Age/Gender/Location Filters
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Location Selector
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: cityController,
                    cursorColor: Colors.blue,
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: 'City',
                      fillColor: const Color(0xfff8F9FA),
                      hintStyle: TextStyle(
                        fontFamily: 'Rubik Regular',
                        fontSize: 15,
                      ),
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.lightBlue,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.lightBlue,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                //Age Selector
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: ageController,
                    cursorColor: Colors.blue,
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: 'Age',
                      fillColor: const Color(0xfff8F9FA),
                      hintStyle: TextStyle(
                        fontFamily: 'Rubik Regular',
                        fontSize: 15,
                      ),
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.lightBlue,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.lightBlue,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                //Gender Selector
                Expanded(
                  flex: 3,
                  child: Container(
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: Colors.blue, // Changed to blue color
                        style: BorderStyle.solid,
                      ),
                    ),
                    // margin: EdgeInsets.only(
                    //   left: 20, // Adjusted margin to align with TextFormField
                    // ),
                    padding: EdgeInsets.only(left: 10),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        isExpanded: true,
                        hint: Text(
                          'Select Gender',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        value: selectedGender,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedGender = newValue!;
                          });
                        },
                        items: genders.map<DropdownMenuItem<String>>(
                              (value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ),
                ),


              ],
            ),

          ),
          SizedBox(height: 10),

          //Reports List
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: getReportsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData) {
                  final reports = snapshot.data!.docs.map((doc) {
                    final data = doc.data();
                    return Report(
                      reportId: data['reportId'] ?? '',
                      reportType: data['reportType'] ?? '',
                      foundSubCategory: data['foundSubCategory'] ?? 'Null',
                      personName: data['personName'] ?? '',
                      personAge: data['personAge'] ?? '',
                      personGender: data['personGender'] ?? '',
                      personDescription: data['personDescription'] ?? '',
                      contactName: data['contactName'] ?? '',
                      contactRelation: data['contactRelation'] ?? '',
                      contact: data['contact'] ?? '',
                      dateLastSeen: data['dateLastSeen'] ?? '',
                      locationLastSeen: data['locationLastSeen'] ?? '',
                      city: data['city'] ?? '',
                      personImage: data['personImage'] ?? '',
                      reportedBy: data['reportedBy'] ?? '',
                      //createdAt: (data['createdAt'] as Timestamp).toDate(),
                    );
                  }).toList();

                  final filteredReports = reports.where((report) {

                    final locationFilter = isLocationMatch(report.locationLastSeen, cityController.text);
                    final nameFilter = isNameMatch(report.personName, nameSearchController.text);
                    final ageFilter = ageController.text.isEmpty || report.personAge == ageController.text;
                    final genderFilter = selectedGender == 'All Genders' ||
                        (report.personGender?.toLowerCase() ?? '') == selectedGender.toLowerCase();

                    return nameFilter && locationFilter && ageFilter && genderFilter;
                  }).toList();


                  if (filteredReports.isEmpty) {
                    return const NoUsers();
                  }

                  return ListView.builder(
                    itemCount: filteredReports.length,
                    itemBuilder: (context, index) {
                      final report = filteredReports[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                        child: Container(
                          //height: MediaQuery.of(context).size.width * 0.22,
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
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                    padding:EdgeInsets.only(left: 20, top: 10),
                                    child: Text('Report Type: '+report.reportType.toUpperCase(), style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: report.reportType == 'lost' ? Colors.red : Colors.green,),)),
                                ListTile(
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
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Text('Error fetching reports'),
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




class PersonInformationScreen extends StatefulWidget {
  final Report report;

  const PersonInformationScreen({required this.report});

  @override
  State<PersonInformationScreen> createState() => _PersonInformationScreenState();
}

class _PersonInformationScreenState extends State<PersonInformationScreen> {
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
                      builder: (context) => FullScreenImage(imageUrl: widget.report.personImage),
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
                        DataCell(
                          InkWell(
                            onTap: (){
                              _launchPhoneDialer(widget.report.contact);
                            },
                            child: Row(
                              children: [
                                Text(
                                  widget.report.contact,
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
                          ),

                        ),
                      ],
                    ),


                  ],
                ),
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
