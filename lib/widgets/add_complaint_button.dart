import 'package:flutter/material.dart';

class AddButton extends StatefulWidget {

  final Icon actionButtonIcon;
  final Route pageRoute;

  const AddButton({Key? key, required this.actionButtonIcon, required this.pageRoute}) : super(key: key);

  @override
  State<AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: (){
          Navigator.push(context, widget.pageRoute);
        },
      backgroundColor: Colors.blueAccent,
      child: widget.actionButtonIcon,
    );
  }
}
