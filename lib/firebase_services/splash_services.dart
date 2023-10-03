import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spectator/ui/auth/login_screen.dart';

import 'package:flutter/material.dart';

import '../user_screens/home_screen.dart';



class SplashServices {

  void isLogin(BuildContext context){


    final auth = FirebaseAuth.instance;

    final user = auth.currentUser;

    if (user != null){
      Timer(const Duration(seconds: 3),
            ()=>  Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeScreen()),
                  (Route<dynamic> route) =>
              false, // Remove all previous routes
            )
      );
    }
    else {
      Timer(const Duration(seconds: 3),
              ()=>  Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => LoginScreen()),
                    (Route<dynamic> route) =>
                false, // Remove all previous routes
              )
      );
    }




  }

}