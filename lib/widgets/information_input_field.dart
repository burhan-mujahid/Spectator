import 'package:flutter/material.dart';

class InformationInputField extends StatefulWidget {
  final TextInputType keyboardType;
  final TextEditingController controller;
  final String hintText;
  final Icon prefixIcon;
  final String validateText;

  const InformationInputField({
    Key? key,
    required this.keyboardType,
    required this.hintText,
    required this.prefixIcon,
    required this.controller,
    required this.validateText,
  }) : super(key: key);

  @override
  State<InformationInputField> createState() => _InformationInputFieldState();
}

class _InformationInputFieldState extends State<InformationInputField> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
      child: TextFormField(
        keyboardType: widget.keyboardType,
        controller: widget.controller,
        cursorColor: Colors.blue,
        decoration: InputDecoration(
          hintText: widget.hintText,
          fillColor: const Color(0xfff8F9FA),
          hintStyle: TextStyle(fontFamily: 'Rubik Regular', fontSize: screenWidth * 0.036),
          filled: true,
          prefixIcon: widget.prefixIcon != null
              ? Icon(
            widget.prefixIcon.icon,
            color: Colors.blue,
            size: screenWidth * 0.06,
          )
              : null,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.lightBlue,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(screenWidth * 0.03),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.lightBlue,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(screenWidth * 0.03),
          ),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return widget.validateText;
          }
          return null;
        },
      ),
    );
  }
}
