import 'package:flutter/material.dart';

class CredentialInputField extends StatefulWidget {
  final TextInputType keyboardType;
  final TextEditingController controller;
  final String hintText;
  final Icon prefixIcon;
  final String validateText;
  final int maxLines;
  final int? minLength;
  final int? maxLength;

  const CredentialInputField({
    Key? key,
    required this.keyboardType,
    required this.hintText,
    required this.prefixIcon,
    required this.controller,
    required this.validateText,
    this.maxLines = 1,
    this.maxLength,
    this.minLength,
  }) : super(key: key);

  @override
  State<CredentialInputField> createState() => _CredentialInputFieldState();
}

class _CredentialInputFieldState extends State<CredentialInputField> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
      child: TextFormField(
        keyboardType: widget.keyboardType,
        controller: widget.controller,
        cursorColor: Colors.blue,
        maxLines: widget.maxLines, // Use the maxLines property from the widget
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
          if (widget.minLength != null && value.length < widget.minLength!) {
            return 'Minimum length must be ${widget.minLength}';
          }
          if (widget.maxLength != null && value.length > widget.maxLength!) {
            return 'Maximum length must be ${widget.maxLength}';
          }
          return null;
        },
      ),
    );
  }
}
