import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:spectator/user_screens/show_user_info.dart';
import 'package:spectator/widgets/auth_button.dart';
import 'package:spectator/widgets/credential_input_field.dart';
import 'package:spectator/widgets/edit_report_image_picker.dart';
import 'package:spectator/widgets/report_image_picker_container.dart';
import 'package:spectator/widgets/page_heading.dart';
import 'package:uuid/uuid.dart';
import '../models/report_model.dart';
import '../providers/report_provider.dart';
import '../utils/utils.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

enum ReportType {
  lost,
  found,
}



class UpdatedReport {
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
  final String? personImage;
  final String reportedBy;

  UpdatedReport({
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
    this.personImage,
    required this.reportedBy,
  });
  Report toReport() {
    return Report(
      reportId: '',
      reportType: '',
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
      personImage: personImage ?? '',
      reportedBy: reportedBy,
      //createdAt: DateTime.now(),
    );
  }
}

class EditComplaintScreen extends StatefulWidget {
  final String reportId;

  const EditComplaintScreen({required this.reportId});

  @override
  State<EditComplaintScreen> createState() => _EditComplaintScreenState();
}

class _EditComplaintScreenState extends State<EditComplaintScreen> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final personNameController = TextEditingController();
  final personAgeController = TextEditingController();
  final personGenderController = TextEditingController();
  final personDescriptionController = TextEditingController();
  final dateLastSeenController = TextEditingController();
  final contactController = TextEditingController();
  final contactNameController = TextEditingController();
  final contactRelationController = TextEditingController();
  final cityController = TextEditingController();
  final locationLastSeenController = TextEditingController();
  File? _personImage;
  final personImagePicker = ImagePicker();

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  CollectionReference<Map<String, dynamic>> reportDatabaseRef =
      FirebaseFirestore.instance.collection('Reports');

  User? currentUser = FirebaseAuth.instance.currentUser;

  Report? _report;
  String? _personImageUrl;

  @override
  void initState() {
    super.initState();
    // Fetch the data from Firestore and prefill the fields
    fetchReportData();
  }

  Future<void> fetchReportData() async {
    try {
      final reportSnapshot = await reportDatabaseRef
          .where('reportId', isEqualTo: widget.reportId)
          .get();

      if (reportSnapshot.docs.isNotEmpty) {
        final reportData = reportSnapshot.docs.first.data();
        setState(() {
          personNameController.text = reportData['personName'] ?? '';
          personAgeController.text = reportData['personAge'] ?? '';
          personGenderController.text = reportData['personGender'] ?? '';
          personDescriptionController.text =
              reportData['personDescription'] ?? '';
          dateLastSeenController.text = reportData['dateLastSeen'] ?? '';
          contactNameController.text = reportData['contactName'] ?? '';
          contactRelationController.text = reportData['contactRelation'] ?? '';
          contactController.text = reportData['contact'] ?? '';
          cityController.text = reportData['city'] ?? '';
          locationLastSeenController.text =
              reportData['locationLastSeen'] ?? '';
          _personImageUrl = reportData['personImage'];
        });
      } else {
        Utils().toastMessage('Report data not found');
      }
    } catch (e) {
      Utils().toastMessage('Error fetching report data: $e');
    }
  }


  final List<String> genderOptions = ['Male', 'Female', 'Other'];

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _personImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final reportProvider = Provider.of<ReportProvider>(context);
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Complaint'),
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
        child: Column(
          children: [
            PageHeading(
              title: 'Edit Complaint',
              subtitle: 'Update the form fields',
            ),
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.02),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: screenWidth * 0.02),
                    SizedBox(
                      height: 30,
                    ),

                    //Person Details
                    Text(
                      'Enter Details of the Person',
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontFamily: 'Rubik Medium',
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade400,
                              blurRadius: 10,
                            )
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.width * 0.5,
                              width: MediaQuery.of(context).size.width * 0.5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: NetworkImage(_personImageUrl!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),


                            SizedBox(height: screenWidth * 0.02),
                            CredentialInputField(
                              keyboardType: TextInputType.text,
                              hintText: 'Name',
                              prefixIcon: Icon(Icons.person),
                              controller: personNameController,
                              validateText: 'Enter person name',
                            ),
                            SizedBox(height: screenWidth * 0.02),
                            Row(
                              children: [
                                Expanded(
                                  flex:2,
                                  child: CredentialInputField(
                                    keyboardType: TextInputType.number,
                                    hintText: 'Age',
                                    prefixIcon: Icon(Icons.calendar_today),
                                    controller: personAgeController,
                                    validateText: 'Enter person age',
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.02),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: DropdownButtonFormField<String>(
                                      value: personGenderController.text,
                                      items: genderOptions.map((gender) {
                                        return DropdownMenuItem(
                                          value: gender,
                                          child: Text(gender),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          personGenderController.text = value ?? '';
                                        });
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Person Gender',
                                        prefixIcon: Icon(Icons.people_alt_outlined),
                                        border: InputBorder.none,
                                      ),
                                    ),


                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenWidth * 0.02),
                            CredentialInputField(
                              keyboardType: TextInputType.multiline,
                              maxLines: 3,
                              hintText: 'Person Description',
                              prefixIcon: Icon(Icons.description),
                              controller: personDescriptionController,
                              validateText: 'Enter person description',
                            ),
                            SizedBox(height: screenWidth * 0.02),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 30,
                    ),

                    //Contact Details
                    Text(
                      'Enter Contact Details',
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontFamily: 'Rubik Medium',
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade400,
                              blurRadius: 10,
                            )
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CredentialInputField(
                              keyboardType: TextInputType.text,
                              hintText: 'Person Contact Name',
                              prefixIcon: Icon(Icons.person),
                              controller: contactNameController,
                              validateText: 'Enter name to report to',
                            ),
                            SizedBox(height: screenWidth * 0.02),
                            CredentialInputField(
                              keyboardType: TextInputType.number,
                              hintText: 'Contact Number',
                              prefixIcon: Icon(Icons.call),
                              controller: contactController,
                              validateText: 'Enter number to report on',
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 30,
                    ),

                    //Location Information
                    Text(
                      'Enter Details of Location',
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontFamily: 'Rubik Medium',
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade400,
                              blurRadius: 10,
                            )
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                DatePicker.showDatePicker(
                                  context,
                                  showTitleActions: true,
                                  minTime: DateTime(1900),
                                  maxTime: DateTime.now(),
                                  onConfirm: (date) {
                                    dateLastSeenController.text =
                                        date.toString().substring(0, 10);
                                  },
                                  currentTime: DateTime.now(),
                                  locale: LocaleType.en,
                                );
                              },
                              child: AbsorbPointer(
                                child: CredentialInputField(
                                  keyboardType: TextInputType.datetime,
                                  hintText: 'Date Last Seen',
                                  prefixIcon: Icon(Icons.calendar_today),
                                  controller: dateLastSeenController,
                                  validateText: 'Enter date last seen',
                                ),
                              ),
                            ),
                            SizedBox(height: screenWidth * 0.02),
                            CredentialInputField(
                              keyboardType: TextInputType.text,
                              hintText: 'Location Details',
                              prefixIcon: Icon(Icons.location_on),
                              controller: locationLastSeenController,
                              validateText: 'Enter location last seen',
                            ),
                            SizedBox(height: screenWidth * 0.02),
                            CredentialInputField(
                              keyboardType: TextInputType.text,
                              hintText: 'City',
                              prefixIcon: Icon(Icons.map),
                              controller: cityController,
                              validateText: 'Enter city name',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.02),
              child: AuthButton(
                title: 'Update',
                onTap: () async {
                  // if (_personImage == null) {
                  //   Utils().toastMessage('Please Select Person Image');
                  //   return;
                  // }

                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      loading = true;
                    });

                    try {
                      final reportId = widget.reportId;
                      String? personImageUrl;

                      if (_personImage != null) {
                        final fileName = '$reportId.png';
                        final destination = 'complaints/$fileName';

                        final ref = storage.ref().child(destination);
                        await ref.putFile(_personImage!);

                        personImageUrl = await ref.getDownloadURL();
                      }


                      await reportDatabaseRef.doc(widget.reportId).update({
                        'personName': personNameController.text,
                        'personAge': personAgeController.text,
                        'personGender': personGenderController.text,
                        'personDescription': personDescriptionController.text,
                        'dateLastSeen': dateLastSeenController.text,
                        'contactName': contactNameController.text,
                        'contactRelation': contactRelationController.text,
                        'contact': contactController.text,
                        'city': cityController.text,
                        'locationLastSeen': locationLastSeenController.text,
                        'personImage': _personImageUrl,
                        'reportedBy': currentUser?.uid ?? '',
                      });

                      Utils().toastMessage('Complaint Updated successfully');

                      Navigator.pop(context, UpdatedReport(
                        personName: personNameController.text,
                        personAge: personAgeController.text,
                        personGender: personGenderController.text,
                        personDescription: personDescriptionController.text,
                        dateLastSeen: dateLastSeenController.text,
                        contactName: contactNameController.text,
                        contactRelation: contactRelationController.text,
                        contact: contactController.text,
                        city: cityController.text,
                        locationLastSeen: locationLastSeenController.text,
                        reportedBy: currentUser?.uid ?? '',
                      ));


                    } catch (e) {
                      Utils().toastMessage('Error Updating Report: $e');
                    } finally {
                      setState(() {
                        loading = false;
                      });
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
