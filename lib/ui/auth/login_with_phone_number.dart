import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spectator/ui/auth/verify_code.dart';
import 'package:spectator/utils/utils.dart';
import 'package:spectator/widgets/auth_button.dart';
import 'package:spectator/widgets/credential_input_field.dart';

import '../../widgets/auth_screen_heading.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({Key? key}) : super(key: key);

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  bool loading = false;
  final phoneNumberController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  void dispose() {
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final logoSize = screenWidth * 0.1;
    final headingFontSize = screenWidth * 0.05;
    final subHeadingFontSize = screenWidth * 0.03;
    final inputFieldHeight = screenHeight * 0.08;
    final buttonHeight = screenHeight * 0.07;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05,vertical: screenHeight * 0.1,),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AuthScreenHeading(heading: 'Login with Phone Number', subHeading: 'Enter phone number to continue'),
              CredentialInputField(
                keyboardType: TextInputType.phone,
                hintText: '+92 300 0000000',
                prefixIcon: Icon(Icons.call),
                controller: phoneNumberController,
                validateText: 'Enter Phone Number',
              ),
              SizedBox(height: screenHeight * 0.05),
              AuthButton(
                title: 'Login',
                loading: loading,
                onTap: () {
                  setState(() {
                    loading = true;
                  });
                  auth.verifyPhoneNumber(
                    phoneNumber: phoneNumberController.text,
                    verificationCompleted: (_) {
                      setState(() {
                        loading = false;
                      });
                    },
                    verificationFailed: (e) {
                      Utils().toastMessage(e.toString());
                      setState(() {
                        loading = false;
                      });
                    },
                    codeSent: (String verificationId, int? token) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VerifyCodeScreen(
                            verificationId: verificationId,
                            phoneNumber: phoneNumberController.text.toString(),
                          ),
                        ),
                      );
                      setState(() {
                        loading = false;
                      });
                    },
                    codeAutoRetrievalTimeout: (e) {
                      Utils().toastMessage(e.toString());
                      setState(() {
                        loading = false;
                      });
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
