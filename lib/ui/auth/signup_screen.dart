import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spectator/ui/auth/login_screen.dart';
import 'package:spectator/user_screens/home_screen.dart';
import 'package:spectator/utils/utils.dart';
import 'package:spectator/widgets/auth_button.dart';
import 'package:spectator/widgets/credential_input_field.dart';
import 'package:spectator/widgets/password_input_field.dart';

import '../../admin_screens/admin_login.dart';
import '../../user_screens/add_user_fireStore.dart';
import '../../widgets/auth_screen_heading.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void signUp() {
    setState(() {
      loading = true;
    });

    _auth
        .createUserWithEmailAndPassword(
      email: emailController.text.toString(),
      password: passwordController.text.toString(),
    )
        .then((value) async {
      setState(() {
        loading = false;
      });

      Utils().toastMessage(value.user!.email.toString());
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AddUserInfoFirestore()),
      );
    }).onError((error, stackTrace) {
      Utils().toastMessage(error.toString());
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final logoSize = screenWidth * 0.1;
    final headingFontSize = screenWidth * 0.06;
    final subHeadingFontSize = screenWidth * 0.03;
    final inputFieldHeight = screenHeight * 0.08;
    final buttonHeight = screenHeight * 0.07;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.1,),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AuthScreenHeading(heading: 'Sign Up', subHeading: 'Create your Spectator Account'),
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
                    SizedBox(height: screenHeight * 0.02),
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
              SizedBox(height: screenHeight * 0.04),
              AuthButton(
                title: 'Sign Up',
                loading: loading,
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    signUp();
                  }
                },

              ),
              SizedBox(height: screenHeight * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Text('Log in'),
                  ),
                ],
              ),
              
              SizedBox(
                height: 200,
              ),
              Center(
                child: GestureDetector(
                  onDoubleTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminLoginScreen()));
                  },
                  child: SizedBox(
                    width: screenWidth*0.85,
                      child: Text('Admin Login', style: TextStyle(color: Colors.black.withOpacity(0.02)),)
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
