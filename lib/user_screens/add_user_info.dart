import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spectator/widgets/auth_button.dart';
import 'package:spectator/widgets/credential_input_field.dart';
import 'package:spectator/widgets/image_picker_container.dart';
import 'package:spectator/widgets/page_heading.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../utils/utils.dart';

class AddUserInfo extends StatefulWidget {
  const AddUserInfo({Key? key}) : super(key: key);

  @override
  State<AddUserInfo> createState() => _AddUserInfoState();
}

class _AddUserInfoState extends State<AddUserInfo> {

  bool loading = false;
  final nameController = TextEditingController();
  final cnicController = TextEditingController();
  final phoneNumberController = TextEditingController();
  File? _userProfileImage;
  final userProfileImagePicker = ImagePicker();
  File? _cnicImageFront;
  final cnicImagePickerFront = ImagePicker();
  File? _cnicImageBack;
  final cnicImagePickerBack = ImagePicker();


  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref('User');



  User? currentUser = FirebaseAuth.instance.currentUser;

  Future getProfileImage() async {
    final pickedFile = await userProfileImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    setState(() {});

    if (pickedFile != null) {
      _userProfileImage = File(pickedFile.path);
    } else {
      Utils().toastMessage('No image picked');
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


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    databaseRef.onValue.listen((event) {

    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              subtitle: 'User ID: ${currentUser?.uid}',
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Center(
                    child: ImagePickerContainer(
                      getGalleryImage: getProfileImage,
                      image: _userProfileImage,
                      validateText: 'Please choose profile picture',
                    ),
                  ),
                  CredentialInputField(
                    keyboardType: TextInputType.text,
                    hintText: 'Name',
                    prefixIcon: Icon(Icons.person),
                    controller: nameController,
                    validateText: 'Enter Name',
                  ),
                  CredentialInputField(
                    keyboardType: TextInputType.number,
                    hintText: 'CNIC Number',
                    prefixIcon: Icon(Icons.credit_card),
                    controller: cnicController,
                    validateText: 'Enter CNIC number',
                  ),
                  CredentialInputField(
                    keyboardType: TextInputType.number,
                    hintText: 'Phone number',
                    prefixIcon: Icon(Icons.call),
                    controller: phoneNumberController,
                    validateText: 'Enter phone number',
                  ),
                  Container(
                    height: 250,
                    width: 370,
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
                                validateText: 'Please select CNIC image (Front)',
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
                  AuthButton(
                    title: 'Submit',
                    onTap: () async {
                      setState(() {
                        loading = true;
                      });

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
                          '/userimagesfolder/${currentUser?.uid}/CNIC_image_Front',
                        );

                        uploadTask = userCnicImageFrontRef.putFile(
                          _cnicImageFront!,
                        );

                        await uploadTask;

                        var userCnicImageFront =
                        await userCnicImageFrontRef.getDownloadURL();

                        firebase_storage.Reference userCnicImageBackRef =
                        firebase_storage.FirebaseStorage.instance.ref(
                          '/userimagesfolder/${currentUser?.uid}/CNIC_image_Back',
                        );

                        uploadTask = userCnicImageBackRef.putFile(
                          _cnicImageBack!,
                        );

                        await uploadTask;

                        var userCnicImageBack =
                        await userCnicImageBackRef.getDownloadURL();

                        databaseRef.child('user ${currentUser!.uid}').set({
                          'id': currentUser!.uid,
                          'name': nameController.text.toString(),
                          'cnic': cnicController.text.toString(),
                          'Phone Number': phoneNumberController.text.toString(),
                          'Profile Image': profileImageUrl.toString(),
                          'CNIC Image Front': userCnicImageFront.toString(),
                          'CNIC Image Back': userCnicImageBack.toString(),
                        });

                        Utils().toastMessage(
                          'User information added successfully',
                        );

                        setState(() {
                          loading = false;
                        });
                      } catch (error) {
                        Utils().toastMessage(error.toString());
                        setState(() {
                          loading = false;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
