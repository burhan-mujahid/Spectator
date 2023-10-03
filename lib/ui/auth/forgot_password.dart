import 'package:firebase_auth/firebase_auth.dart';
import 'package:spectator/widgets/auth_button.dart';
import 'package:flutter/material.dart';
import 'package:spectator/widgets/credential_input_field.dart';

import '../../utils/utils.dart';
import '../../widgets/auth_screen_heading.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.1,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AuthScreenHeading(heading: 'Forgot Password?', subHeading: 'Enter email to recover password'),
              CredentialInputField(
                keyboardType: TextInputType.emailAddress,
                hintText: 'Email',
                prefixIcon: Icon(Icons.email),
                controller: emailController,
                validateText: 'Enter Email',
              ),
              SizedBox(
                height: screenHeight * 0.08,
              ),
              AuthButton(
                title: 'Submit',
                onTap: () {
                  auth
                      .sendPasswordResetEmail(
                    email: emailController.text.toString(),
                  )
                      .then((value) {
                    Utils().toastMessage('Password recovery email sent successfully');
                  }).onError((error, stackTrace) {
                    Utils().toastMessage(error.toString());
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
