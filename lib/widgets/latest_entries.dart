import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LatestEntriesSection extends StatefulWidget {
  const LatestEntriesSection({Key? key}) : super(key: key);

  @override
  State<LatestEntriesSection> createState() => _LatestEntriesSectionState();
}

class _LatestEntriesSectionState extends State<LatestEntriesSection> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.015,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.065),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Latest Entries',
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.018,
        ),
        // Date Heading
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.065),
          child: Container(
            height: screenWidth * 0.05,
            width: screenWidth * 0.9,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(screenWidth * 0.04),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: screenWidth * 0.01,
                ),
              ],
            ),
            child: Center(
              child: Text(
    DateFormat('d MMMM yyyy').format(DateTime.now()),
                style: TextStyle(fontSize: screenWidth * 0.04),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
