// AddUserInfoFirestore code:

import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spectator/widgets/auth_button.dart';
import 'package:spectator/widgets/credential_input_field.dart';
import 'package:spectator/widgets/image_picker_container.dart';
import 'package:spectator/widgets/page_heading.dart';
import '../utils/utils.dart';
import 'home_screen.dart';

class AddUserInfoFirestore extends StatefulWidget {


  const AddUserInfoFirestore({ Key? key}) : super(key: key);

  @override
  State<AddUserInfoFirestore> createState() => _AddUserInfoFirestoreState();

}

class _AddUserInfoFirestoreState extends State<AddUserInfoFirestore> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final cnicController = TextEditingController();
  final phoneNumberController = TextEditingController();
  File? _userProfileImage;
  final userProfileImagePicker = ImagePicker();
  File? _cnicImageFront;
  final cnicImagePickerFront = ImagePicker();
  File? _cnicImageBack;
  final cnicImagePickerBack = ImagePicker();


  bool isImageVerified = false;


  Point<int>? leftEyePos;
  Point<int>? rightEyePos;
  Point<int>? noseBasePos;
  Point<int>? bottomMouthPos;

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  CollectionReference<Map<String, dynamic>> databaseRef =
  FirebaseFirestore.instance.collection('Users');

  User? currentUser = FirebaseAuth.instance.currentUser;

  // Future getProfileImage() async {
  //   final pickedFile = await userProfileImagePicker.pickImage(
  //     source: ImageSource.gallery,
  //     imageQuality: 80,
  //   );
  //   setState(() {});
  //
  //   if (pickedFile != null) {
  //     _userProfileImage = File(pickedFile.path);
  //   } else {
  //     Utils().toastMessage('No image picked');
  //   }
  // }

  Future<void> getProfileImage() async {
    final pickedFile = await userProfileImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    setState(() {
      _userProfileImage = pickedFile != null ? File(pickedFile.path) : null;

      leftEyePos = null;
      rightEyePos = null;
      noseBasePos = null;
      bottomMouthPos = null;

      isImageVerified = false;
    });
    if (_userProfileImage != null) {
      imageFaceDetection(_userProfileImage!);
    }
  }

  Future getCnicImageFront() async {
    final pickedFile = await cnicImagePickerFront.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    setState(() {});

    if (pickedFile != null) {
      _cnicImageFront = File(pickedFile.path);
    } else {
      Utils().toastMessage('No image picked');
    }
  }

  Future getCnicImageBack() async {
    final pickedFile = await cnicImagePickerBack.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    setState(() {});

    if (pickedFile != null) {
      _cnicImageBack = File(pickedFile.path);
    } else {
      Utils().toastMessage('No image picked');
    }
  }

  Future<bool> checkCNICExists(String cnic) async {
    final snapshot = await databaseRef
        .where('cnic', isEqualTo: cnic)
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }


  @override
  void dispose() async {

    if (!loading) {

      if (currentUser != null) {
        await databaseRef.doc(currentUser!.uid).delete();
      }


      if (_userProfileImage != null) {
        final userProfileImageRef = firebase_storage.FirebaseStorage.instance
            .ref('/userimagesfolder/${currentUser?.uid}/profile_image');
        await userProfileImageRef.delete();
      }

      if (_cnicImageFront != null) {
        final userCnicImageFrontRef = firebase_storage.FirebaseStorage.instance
            .ref('/userimagesfolder/${currentUser?.uid}/cnic_image_front');
        await userCnicImageFrontRef.delete();
      }

      if (_cnicImageBack != null) {
        final userCnicImageBackRef = firebase_storage.FirebaseStorage.instance
            .ref('/userimagesfolder/${currentUser?.uid}/cnic_image_back');
        await userCnicImageBackRef.delete();
      }


    }

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Add User Information'),
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
              title: "Personal Details",
              subtitle: 'Finalising Sign-Up',
            ),
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.03),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.02),
                    Center(
                      child: ImagePickerContainer(
                        getGalleryImage: getProfileImage,
                        image: _userProfileImage,
                        validateText: 'Please choose profile picture',
                      ),
                    ),
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





                    SizedBox(height: screenHeight * 0.02),
                    CredentialInputField(
                      keyboardType: TextInputType.text,
                      hintText: 'Name',
                      prefixIcon: Icon(Icons.person),
                      controller: nameController,
                      validateText: 'Enter Name',
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    CredentialInputField(
                      keyboardType: TextInputType.number,
                      hintText: 'CNIC Number',
                      prefixIcon: Icon(Icons.credit_card),
                      controller: cnicController,
                      validateText: 'Enter CNIC number',
                      minLength: 13,
                      maxLength: 13,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    CredentialInputField(
                      keyboardType: TextInputType.number,
                      hintText: 'Phone number',
                      prefixIcon: Icon(Icons.call),
                      controller: phoneNumberController,
                      validateText: 'Enter phone number',
                      minLength: 11,
                      maxLength: 11,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Container(
                      height: screenHeight * 0.33,
                      width: screenWidth * 0.95,
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Select CNIC Images (Front & Back)',
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Rubik Regular',
                                color: Colors.black,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ImagePickerContainer(
                                  getGalleryImage: getCnicImageFront,
                                  image: _cnicImageFront,
                                  validateText:
                                  'Please select CNIC image (Front)',
                                ),
                                ImagePickerContainer(
                                  getGalleryImage: getCnicImageBack,
                                  image: _cnicImageBack,
                                  validateText: 'Please select CNIC image (Back)',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.02),
              child: AuthButton(
                title: 'Submit',
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      loading = true;
                    });


                    if (!isImageVerified) {
                      Utils().toastMessage('Please Select Valid Person Image');
                      return;
                    }


                    final cnic = cnicController.text.toString();
                    final cnicExists = await checkCNICExists(cnic);

                    if (cnicExists) {
                      Utils().toastMessage('CNIC already exists');
                      setState(() {
                        loading = false;
                      });
                      return;
                    }

                    firebase_storage.Reference userProfileImageRef =
                    firebase_storage.FirebaseStorage.instance.ref(
                      '/userimagesfolder/${currentUser?.uid}/profile_image',
                    );

                    firebase_storage.UploadTask uploadTask =
                    userProfileImageRef.putFile(
                      _userProfileImage!,
                    );

                    try {
                      await uploadTask;

                      var profileImageUrl =
                      await userProfileImageRef.getDownloadURL();

                      firebase_storage.Reference userCnicImageFrontRef =
                      firebase_storage.FirebaseStorage.instance.ref(
                        '/userimagesfolder/${currentUser?.uid}/cnic_image_front',
                      );

                      firebase_storage.UploadTask uploadTaskFront =
                      userCnicImageFrontRef.putFile(
                        _cnicImageFront!,
                      );

                      await uploadTaskFront;

                      var cnicImageFrontUrl =
                      await userCnicImageFrontRef.getDownloadURL();

                      firebase_storage.Reference userCnicImageBackRef =
                      firebase_storage.FirebaseStorage.instance.ref(
                        '/userimagesfolder/${currentUser?.uid}/cnic_image_back',
                      );

                      firebase_storage.UploadTask uploadTaskBack =
                      userCnicImageBackRef.putFile(
                        _cnicImageBack!,
                      );

                      await uploadTaskBack;

                      var cnicImageBackUrl =
                      await userCnicImageBackRef.getDownloadURL();

                      await databaseRef.doc(currentUser!.uid).set({
                        'uid': currentUser!.uid,
                        'name': nameController.text.trim(),
                        'cnic': cnicController.text.trim(),
                        'phone_number': phoneNumberController.text.trim(),
                        'profile_image_url': profileImageUrl,
                        'cnic_image_front_url': cnicImageFrontUrl,
                        'cnic_image_back_url': cnicImageBackUrl,
                        'timestamp': FieldValue.serverTimestamp(),
                      });

                      Utils().toastMessage('User information added successfully');
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeScreen()),
                            (Route<dynamic> route) =>
                        false, // Remove all previous routes
                      );
                    } catch (e) {
                      Utils().toastMessage('Error: $e');
                    } finally {
                      setState(() {
                        loading = false;
                      });
                    }
                  }
                },
                loading: loading,
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
