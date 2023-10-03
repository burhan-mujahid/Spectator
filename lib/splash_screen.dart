import 'package:spectator/firebase_services/splash_services.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  SplashServices splashServices = SplashServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splashServices.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/spectator_app_bg.png'),
            fit: BoxFit.cover
          )
        ),

        child: Center(
          child: Container(
            height: 200,
              width: 200,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/splash_screen_logo.png'),
                    fit: BoxFit.cover
                )
            ),
          ),
        ),
      ),
    );
  }
}
