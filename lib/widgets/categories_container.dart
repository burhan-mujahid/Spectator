import 'package:flutter/material.dart';

class CategoriesContainer extends StatefulWidget {


  final AssetImage listTileImage;
  final String listTileTitle;
  final String listTileSubtitle;




  const CategoriesContainer({Key? key,

    required this.listTileImage,
    required this.listTileTitle,
    required this.listTileSubtitle,

  }) : super(key: key);

  @override
  State<CategoriesContainer> createState() => _CategoriesContainerState();
}

class _CategoriesContainerState extends State<CategoriesContainer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Container(
        //height: 90,
        width: MediaQuery.of(context).size.width * 1.9,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade400,
                blurRadius: 10,
              )
            ]
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(2.0),
              ),
              ListTile(
                leading: CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 0.09,
                  backgroundImage: widget.listTileImage,
                ),
                title: Text(widget.listTileTitle),
                subtitle: Text(widget.listTileSubtitle),
              )

            ],
          ),
        ),

      ),
    );
  }
}
