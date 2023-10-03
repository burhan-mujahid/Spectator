import 'package:flutter/material.dart';

class SOSServicesScreen extends StatefulWidget {

  final String pageTitle;
  final String number;
  final AssetImage departmentLogo;


  const SOSServicesScreen({Key? key,
    required this.pageTitle,
    required this.departmentLogo,
    required this.number}) : super(key: key);

  @override
  State<SOSServicesScreen> createState() => _SOSServicesScreenState();
}

class _SOSServicesScreenState extends State<SOSServicesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}
