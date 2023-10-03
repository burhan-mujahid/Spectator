import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spectator/widgets/auth_button.dart';
import 'package:spectator/widgets/credential_input_field.dart';
import 'package:spectator/widgets/report_image_picker_container.dart';
import 'package:spectator/widgets/page_heading.dart';
import 'package:uuid/uuid.dart';
import '../utils/utils.dart';
//import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

enum ReportType {
  lost,
  found,
}

class AddComplaintScreenF extends StatefulWidget {
  const AddComplaintScreenF({Key? key}) : super(key: key);

  @override
  State<AddComplaintScreenF> createState() => _AddComplaintScreenFState();
}

class _AddComplaintScreenFState extends State<AddComplaintScreenF> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final personNameController = TextEditingController();
  final personAgeController = TextEditingController();
  final personGenderController = TextEditingController();
  final personDescriptionController = TextEditingController();
  final dateLastSeenController = TextEditingController();
  final contactController = TextEditingController();
  final contactNameController = TextEditingController();
  // final contactRelationController = TextEditingController();
  final cityController = TextEditingController();
  final locationLastSeenController = TextEditingController();
  File? _personImage;
  final personImagePicker = ImagePicker();
  bool isImageVerified = false;


  Point<int>? leftEyePos;
  Point<int>? rightEyePos;
  Point<int>? noseBasePos;
  Point<int>? bottomMouthPos;


  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  CollectionReference<Map<String, dynamic>> databaseRef =
  FirebaseFirestore.instance.collection('Reports');

  User? currentUser = FirebaseAuth.instance.currentUser;

  ReportType reportType = ReportType.lost;
  String? foundSubCategory;
  final List<String> genderOptions = ['Male', 'Female', 'Other'];


  Future<void> getPersonImage() async {
    final pickedFile = await personImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {

      final compressedImage = await FlutterImageCompress.compressWithFile(
        pickedFile.path,
        quality: 50,  // Adjust quality as needed
        minHeight: 1000,
        minWidth: 1000,
        autoCorrectionAngle: true,
      );

      setState(() {
        _personImage = File(pickedFile.path);
        leftEyePos = null;
        rightEyePos = null;
        noseBasePos = null;
        bottomMouthPos = null;
        isImageVerified = false;
      });

      // Call face detection on the original image
      imageFaceDetection(_personImage!);
    }
  }




  @override
  void initState() {
    super.initState();
    // Set the default value for personGenderController to "Male" (or any desired default value)
    personGenderController.value = TextEditingValue(text: genderOptions[0]);
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
          children:  [
            const PageHeading(
              title: 'Add Complaint',
              subtitle: 'Fill the form to add a complaint',
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


                    //Category Selector
                    Text(
                      'Choose Report Category',
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontFamily: 'Rubik Medium',
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 8,),
                    Container(
                      //  height: MediaQuery.of(context).size.width * 0.3,
                      width: MediaQuery.of(context).size.width * 0.85,
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //Category Selector
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                // Dropdown selector for Report Type
                                SizedBox(height: screenWidth * 0.01),
                                DropdownButtonFormField<ReportType>(

                                  borderRadius: BorderRadius.circular(screenWidth * 0.03),

                                  iconDisabledColor: Colors.blue,
                                  iconEnabledColor: Colors.blue,
                                  value: reportType,
                                  items: const [
                                    DropdownMenuItem(
                                      value: ReportType.lost,
                                      child: Text('Lost Report'),
                                    ),
                                    DropdownMenuItem(
                                      value: ReportType.found,
                                      child: Text('Found Report',),
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
                                  decoration: const InputDecoration(
                                    // labelText: 'Report Type',
                                    prefixIcon: Icon(Icons.file_copy),
                                    border: InputBorder.none,
                                  ),
                                ),
                                SizedBox(height: screenWidth * 0.03),
                                // Dropdown selector for Found Sub-category (if applicable)
                                if (reportType == ReportType.found) ...[
                                  DropdownButtonFormField<String>(
                                    borderRadius: BorderRadius.circular(screenWidth * 0.03),
                                    iconDisabledColor: Colors.blue,
                                    iconEnabledColor: Colors.blue,
                                    value: foundSubCategory,
                                    items: const [
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
                                    decoration: const InputDecoration(
                                      labelText: 'Found Sub-category',
                                      prefixIcon: Icon(Icons.list),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                  SizedBox(height: screenWidth * 0.02),
                                ],
                              ],

                            ),
                          ),
                        ],
                      ),

                    ),


                    const SizedBox(height: 30,),

                    //Person Details
                    Text(
                      'Enter Details of the Person',
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontFamily: 'Rubik Medium',
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 8,),
                    Container(
                      // height: MediaQuery.of(context).size.width * 0.3,
                      width: MediaQuery.of(context).size.width * 0.85,
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            //Person Details
                            ReportImagePickerContainer(
                              getGalleryImage: getPersonImage,
                              image: _personImage,
                              //validateText: 'Please choose a person image',
                              reportType: reportType.toString(),
                              currentUserUid: currentUser?.uid,
                            ),
                            SizedBox(height: screenWidth * 0.02),

                            // Green and red statements based on verification status.
                            if (isImageVerified)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Center(
                                  child: Text(
                                    'Person Image Verified',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ),
                              ),
                            if (!isImageVerified)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Center(
                                  child: Text(
                                    'Please select a valid image',
                                    style: TextStyle(color: Colors.red),
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

                    SizedBox(height: 30,),

                    //Contact Details
                    Text(
                      'Enter Contact Details',
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontFamily: 'Rubik Medium',
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 8,),
                    Container(
                      // height: MediaQuery.of(context).size.width * 0.3,
                      width: MediaQuery.of(context).size.width * 0.85,
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            //Contact Details

                            CredentialInputField(
                              keyboardType: TextInputType.text,
                              hintText: 'Person Contact Name',
                              prefixIcon: Icon(Icons.person),
                              controller: contactNameController,
                              validateText: 'Enter name to report to',
                            ),

                            SizedBox(height: screenWidth * 0.02),

                            // if (reportType == ReportType.lost) ...[
                            //   CredentialInputField(
                            //     keyboardType: TextInputType.text,
                            //     hintText: 'Relation with missing person',
                            //     prefixIcon: Icon(Icons.person_outline),
                            //     controller: contactRelationController,
                            //     validateText: 'Enter your relation with missing person',
                            //   ),
                            //],


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

                    SizedBox(height: 30,),

                    //Location Information
                    Text(
                      'Enter Details of Location',
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontFamily: 'Rubik Medium',
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 8,),
                    Container(
                      // height: MediaQuery.of(context).size.width * 0.3,
                      width: MediaQuery.of(context).size.width * 0.85,
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            //Contact Details

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
                title: 'Submit',
                onTap: () async {

                  if (_personImage == null) {
                    Utils().toastMessage('Please Select Person Image');
                    return;
                  }

                  if (!isImageVerified) {
                    Utils().toastMessage('Please Select Valid Person Image');
                    return;
                  }

                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      loading = true;
                    });

                    try {
                      final reportId = Uuid().v4();

                      String? personImageUrl;
                      if (_personImage != null) {
                        final fileName = '$reportId.png';
                        final destination = 'complaints/$fileName';

                        final ref = storage.ref().child(destination);
                        await ref.putFile(_personImage!);

                        personImageUrl = await ref.getDownloadURL();
                      }




                      await databaseRef.doc(reportId).set({
                        'reportId': reportId,
                        'reportType': reportType == ReportType.lost
                            ? 'lost'
                            : 'found',
                        'foundSubCategory': foundSubCategory ?? 'Nil',
                        'personName': personNameController.text,
                        'personAge': personAgeController.text,
                        'personGender': personGenderController.text,
                        'personDescription':
                        personDescriptionController.text,
                        'dateLastSeen': dateLastSeenController.text,
                        'contact': contactController.text,
                        'contactName': contactNameController.text,
                        // 'contactRelation': contactRelationController.text,
                        'locationLastSeen': locationLastSeenController.text,
                        'city': cityController.text,
                        'personImage': personImageUrl ?? '',
                        'reportedBy': currentUser?.uid ?? '',
                        'createdAt': FieldValue.serverTimestamp(),
                      });


                      Utils().toastMessage('Complaint submitted successfully');
                      Navigator.pop(context);

                      setState(() {
                        personNameController.clear();
                        personAgeController.clear();
                        personGenderController.clear();
                        personDescriptionController.clear();
                        dateLastSeenController.clear();
                        contactController.clear();
                        locationLastSeenController.clear();
                        cityController.clear();
                        // contactRelationController.clear();
                        contactNameController.clear();

                        _personImage = null;
                      });
                    } catch (e) {
                      Utils().toastMessage('Error submitting complaint: $e');
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


  void imageFaceDetection(File source) async {
    final faceDetector = GoogleMlKit.vision.faceDetector(FaceDetectorOptions(
      enableClassification: true,
      enableContours: true,
      enableLandmarks: true,
      enableTracking: true,
      minFaceSize: 0.1,
      performanceMode: FaceDetectorMode.fast,
    ));

    final InputImage inputImage = InputImage.fromFile(source);

    final List<Face> faces = await faceDetector.processImage(inputImage);

    for (Face face in faces) {
      final FaceLandmark? leftEye = face.landmarks[FaceLandmarkType.leftEye];
      final FaceLandmark? rightEye = face.landmarks[FaceLandmarkType.rightEye];
      final FaceLandmark? noseBase = face.landmarks[FaceLandmarkType.noseBase];
      final FaceLandmark? bottomMouth = face.landmarks[FaceLandmarkType.bottomMouth];

      if (leftEye != null && rightEye != null && noseBase !=null && bottomMouth != null) {
        setState(() {
          leftEyePos = leftEye.position;
          rightEyePos = rightEye.position;
          noseBasePos = noseBase.position;
          bottomMouthPos = bottomMouth.position;
          isImageVerified = true;
        });
      }
    }

    faceDetector.close();
  }



}
