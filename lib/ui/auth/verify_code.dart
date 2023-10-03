import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:spectator/user_screens/home_screen.dart';
import 'package:spectator/utils/utils.dart';
import 'package:spectator/widgets/auth_button.dart';
import 'package:spectator/widgets/auth_screen_heading.dart';
import 'package:spectator/widgets/credential_input_field.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;

  const VerifyCodeScreen({
    Key? key,
    required this.verificationId,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  bool loading = false;
  final verificationCodeController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final headingFontSize = screenWidth * 0.05;
    final subHeadingFontSize = screenWidth * 0.035;
    final codeFieldHeight = screenWidth * 0.2;
    final buttonHeight = screenWidth * 0.14;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login with Phone Number',
          style: TextStyle(color: Colors.blueAccent),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.blue,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.1,),
          child: Column(
            children: [
              AuthScreenHeading(heading: 'Verify Code', subHeading: ' '),
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: subHeadingFontSize,
                      fontFamily: 'Rubik Regular',
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: 'Enter 6 Digit Code sent to ',
                      ),
                      TextSpan(
                        text: widget.phoneNumber,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: screenWidth * 0.04),
              Center(
                child: Padding(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
                  child: PinCodeTextField(
                    appContext: context,
                    controller: verificationCodeController,
                    length: 6,
                    onChanged: ((value) {}),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * 0.02,
                      ),
                      fieldHeight: MediaQuery.of(context).size.height * 0.06,
                      fieldWidth: MediaQuery.of(context).size.height * 0.06 * 0.8,
                      inactiveColor: Colors.blueAccent,
                      activeColor: Colors.blueAccent,
                      selectedColor: Colors.blue,
                      disabledColor: Colors.blueGrey.shade200,
                      inactiveFillColor: Colors.blueAccent,
                      activeFillColor: Colors.blueAccent.shade200,
                      selectedFillColor: Colors.blueAccent.shade200,
                      borderWidth: 1,
                      errorBorderColor: Colors.red,
                    ),
                    cursorColor: Colors.blueAccent,
                  ),
                ),
              ),

              SizedBox(height: screenWidth * 0.08),
              AuthButton(
                title: 'Verify',
                loading: loading,
                onTap: () async {
                  setState(() {
                    loading = true;
                  });

                  final credential = PhoneAuthProvider.credential(
                    verificationId: widget.verificationId,
                    smsCode: verificationCodeController.text.toString(),
                  );

                  try {
                    await auth.signInWithCredential(credential);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                          (Route<dynamic> route) => false, // Remove all previous routes
                    );
                  } catch (e) {
                    Utils().toastMessage(e.toString());
                    setState(() {
                      loading = false;
                    });
                  }
                },
                //buttonHeight: buttonHeight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
