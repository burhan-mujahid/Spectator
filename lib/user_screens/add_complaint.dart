import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spectator/widgets/auth_button.dart';
import 'package:spectator/widgets/credential_input_field.dart';
import 'package:spectator/widgets/report_image_picker_container.dart';
import 'package:spectator/widgets/page_heading.dart';
import '../utils/utils.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';


enum ReportType {
  lost,
  found,
}

class AddComplaintScreen extends StatefulWidget {
  const AddComplaintScreen({Key? key}) : super(key: key);

  @override
  State<AddComplaintScreen> createState() => _AddComplaintScreenState();
}

class _AddComplaintScreenState extends State<AddComplaintScreen> {
  bool uploading = false; // Renamed 'loading' to 'uploading'
  final _formKey = GlobalKey<FormState>();
  final personNameController = TextEditingController();
  final personAgeController = TextEditingController();
  final personGenderController = TextEditingController();
  final personDescriptionController = TextEditingController();
  final dateLastSeenController = TextEditingController();
  final contactController = TextEditingController();
  final locationLastSeenController = TextEditingController();
  File? _personImage;
  final personImagePicker = ImagePicker();

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  CollectionReference<Map<String, dynamic>> databaseRef =
  FirebaseFirestore.instance.collection('Reports');

  User? currentUser = FirebaseAuth.instance.currentUser;


  ReportType reportType = ReportType.lost;
  String? foundSubCategory;
  final List<String> genderOptions = ['Male', 'Female', 'Other'];

  //String? foundSubCategory = 'alive'; // Default sub-category is 'alive'

  Future getPersonImage() async {
    final pickedFile = await personImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    setState(() {});

    if (pickedFile != null) {
      _personImage = File(pickedFile.path);
    } else {
      Utils().toastMessage('No image picked');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Complaint'),
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
              title: 'Add Complaint',
              subtitle: 'Fill the form to add complaint',
            ),
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.02),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: screenWidth * 0.02),
                    // Row(
                    //   children: [
                    //     Radio<String>(
                    //       value: 'lost',
                    //       groupValue: reportType,
                    //       onChanged: (value) {
                    //         setState(() {
                    //           reportType = value!;
                    //         });
                    //       },
                    //     ),
                    //     const Text('Lost Report'),
                    //     Radio<String>(
                    //       value: 'found',
                    //       groupValue: reportType,
                    //       onChanged: (value) {
                    //         setState(() {
                    //           reportType = value!;
                    //         });
                    //       },
                    //     ),
                    //     const Text('Found Report'),
                    //   ],
                    // ),
                    SizedBox(height: screenWidth * 0.02),
                    if (reportType == 'found' && foundSubCategory != null) ...[
                      Row(
                        children: [
                          Radio<String>(
                            value: 'alive',
                            groupValue: foundSubCategory,
                            onChanged: (value) {
                              setState(() {
                                foundSubCategory = value!;
                              });
                            },
                          ),
                          const Text('Alive'),
                          Radio<String>(
                            value: 'body',
                            groupValue: foundSubCategory,
                            onChanged: (value) {
                              setState(() {
                                foundSubCategory = value!;
                              });
                            },
                          ),
                          const Text('Body'),
                        ],
                      ),
                    ],
                    SizedBox(height: screenWidth * 0.02),

                    // Dropdown selector for Report Type
                    DropdownButtonFormField<ReportType>(
                      value: reportType,
                      items: [
                        DropdownMenuItem(
                          value: ReportType.lost,
                          child: Text('Lost Report'),
                        ),
                        DropdownMenuItem(
                          value: ReportType.found,
                          child: Text('Found Report'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          reportType = value!;
                          if (reportType == ReportType.lost) {
                            foundSubCategory = null;
                          }
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Report Type',
                        prefixIcon: Icon(Icons.report),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: screenWidth * 0.02),
                    // Dropdown selector for Found Sub-category (if applicable)
                    if (reportType == ReportType.found) ...[
                      DropdownButtonFormField<String>(
                        value: foundSubCategory,
                        items: [
                          DropdownMenuItem(
                            value: 'alive',
                            child: Text('Alive'),
                          ),
                          DropdownMenuItem(
                            value: 'body',
                            child: Text('Body'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            foundSubCategory = value;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Found Sub-category',
                          prefixIcon: Icon(Icons.category),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: screenWidth * 0.02),
                    ],


                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          final pickedFile = await personImagePicker.pickImage(
                            source: ImageSource.gallery,
                            imageQuality: 80,
                          );
                          if (pickedFile != null) {
                            setState(() {
                              _personImage = File(pickedFile.path);
                            });
                          } else {
                            Utils().toastMessage('No image picked');
                          }
                        },
                        child: ReportImagePickerContainer(
                          getGalleryImage: getPersonImage,
                          image: _personImage,
                          //validateText:'Please choose person image',
                         // _personImage == null ? 'Please choose person image' : null,
                          reportType: reportType.toString(),
                          currentUserUid: currentUser?.uid,
                        ),
                      ),
                    ),
                    SizedBox(height: screenWidth * 0.02),
                    CredentialInputField(
                      keyboardType: TextInputType.text,
                      hintText: 'Person Name',
                      prefixIcon: Icon(Icons.person),
                      controller: personNameController,
                      validateText: 'Enter person name',
                    ),
                    SizedBox(height: screenWidth * 0.02),
                    CredentialInputField(
                      keyboardType: TextInputType.number,
                      hintText: 'Person Age',
                      prefixIcon: Icon(Icons.calendar_today),
                      controller: personAgeController,
                      validateText: 'Enter person age',
                    ),
                    SizedBox(height: screenWidth * 0.02),
                    DropdownButtonFormField<String>(
                      value: personGenderController.text.isNotEmpty
                          ? personGenderController.text
                          : genderOptions[0], // Set the default value to the first gender option
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
                        prefixIcon: Icon(Icons.people),
                        border: OutlineInputBorder(),
                      ),
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
                      keyboardType: TextInputType.number,
                      hintText: 'Contact info',
                      prefixIcon: Icon(Icons.call),
                      controller: contactController,
                      validateText: 'Enter number to report on',
                    ),
                    SizedBox(height: screenWidth * 0.02),
                    CredentialInputField(
                      keyboardType: TextInputType.text,
                      hintText: 'Location Last Seen',
                      prefixIcon: Icon(Icons.location_on),
                      controller: locationLastSeenController,
                      validateText: 'Enter location last seen',
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.02),
              child: AuthButton(
                title: 'Submit',
                onTap: () async {
                  if (_formKey.currentState!.validate() && !uploading) {
                    setState(() {
                      uploading = true;
                    });

                    try {
                      String? personImageUrl;
                      if (_personImage != null) {
                        final fileName =
                            '${DateTime.now().millisecondsSinceEpoch}.png';
                        final destination =
                            'complaints/$fileName';

                        final ref = storage.ref().child(destination);
                        await ref.putFile(_personImage!);

                        personImageUrl = await ref.getDownloadURL();
                      }

                      await databaseRef.add({
                        'reportType': reportType,
                        'foundSubCategory': foundSubCategory != null ? foundSubCategory : 'Nil', // Use foundSubCategory only when it's not null
                        'personName': personNameController.text,
                        'personAge': personAgeController.text,
                        'personGender': personGenderController.text,
                        'personDescription': personDescriptionController.text,
                        'dateLastSeen': dateLastSeenController.text,
                        'contact':contactController.text,
                        'locationLastSeen': locationLastSeenController.text,
                        'personImage': personImageUrl ?? '',
                        'reportedBy': currentUser?.uid ?? '',
                        'createdAt': FieldValue.serverTimestamp(),
                      });

                      Utils().toastMessage('Complaint submitted successfully');

                      setState(() {
                        personNameController.clear();
                        personAgeController.clear();
                        personGenderController.clear();
                        personDescriptionController.clear();
                        dateLastSeenController.clear();
                        contactController.clear();
                        locationLastSeenController.clear();
                        _personImage = null;
                      });
                    } catch (e) {
                      Utils().toastMessage('Error submitting complaint');
                    } finally {
                      setState(() {
                        uploading = false;
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

