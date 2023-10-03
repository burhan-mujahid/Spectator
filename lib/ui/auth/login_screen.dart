import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:spectator/admin_screens/admin_login.dart';
import 'package:spectator/ui/auth/forgot_password.dart';
import 'package:spectator/ui/auth/login_with_phone_number.dart';
import 'package:spectator/ui/auth/signup_screen.dart';
import 'package:spectator/user_screens/home_screen.dart';
import 'package:spectator/utils/utils.dart';
import 'package:spectator/widgets/auth_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spectator/widgets/credential_input_field.dart';
import 'package:spectator/widgets/password_input_field.dart';

import '../../widgets/auth_screen_heading.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void login() {
    setState(() {
      loading = true;
    });
    _auth
        .signInWithEmailAndPassword(
      email: emailController.text.toString(),
      password: passwordController.text.toString(),
    )
        .then((value) {
      setState(() {
        loading = false;
      });

      Utils().toastMessage(value.user!.email.toString());
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      Utils().toastMessage(error.toString());
      setState(() {
        loading = false;
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
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
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   crossAxisAlignment: CrossAxisAlignment.end,
                //   children: [
                //     SizedBox(
                //       height: 20,
                //       child: InkWell(
                //         onDoubleTap: (){
                //           Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminLoginScreen()));
                //         },
                //           child: Text('Admin Login', style: TextStyle(fontSize: 10),)),
                //     ),
                //   ],
                // ),
                AuthScreenHeading(heading: 'Log In', subHeading: 'Login your Spectator Account'),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CredentialInputField(
                        keyboardType: TextInputType.emailAddress,
                        hintText: 'Email',
                        prefixIcon: Icon(Icons.email),
                        controller: emailController,
                        validateText: 'Enter Email',
                      ),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      PasswordInputField(
                        keyboardType: TextInputType.visiblePassword,
                        hintText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                        controller: passwordController,
                        validateText: 'Enter Password',
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                ),
                AuthButton(
                  title: 'Login',
                  loading: loading,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      login();
                          (Route<dynamic> route) => false;
                  }
                  },
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpScreen()),
                        );
                      },
                      child: Text('Sign Up'),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                      );
                    },
                    child: Text('Forgot Password?'),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.03,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginWithPhoneNumber()),
                    );
                  },
                  child: Container(
                    height: screenHeight * 0.060,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(screenHeight * 0.05),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.phone,
                          size: screenHeight * 0.030,
                          color: Colors.blue,
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        Text(
                          'Login with phone number',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
