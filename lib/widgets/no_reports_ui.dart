import 'package:flutter/material.dart';

class NoReports extends StatelessWidget {
  const NoReports({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 60,),
          Image(image: AssetImage('images/no_result_found.png')),
          SizedBox(height: 20,),
          Text('No Reports Found', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),)
        ],
      ),
    );
  }
}

class NoUsers extends StatelessWidget {
  const NoUsers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 60,),
          Image(image: AssetImage('images/no_result_found.png')),
          SizedBox(height: 20,),
          Text('No Users Found', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),)
        ],
      ),
    );
  }
}