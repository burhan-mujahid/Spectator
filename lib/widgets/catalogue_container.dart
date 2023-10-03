import 'package:flutter/material.dart';

class CatalogueContainer extends StatefulWidget {

  final String catalogueTitle;
  final AssetImage listTileImage;
  final String listTileTitle;
  final String listTileSubtitle;
  final String listTileTrailing;


  const CatalogueContainer({Key? key,
    required this.catalogueTitle,
    required this.listTileImage,
    required this.listTileTitle,
    required this.listTileSubtitle,
    required this.listTileTrailing
  }) : super(key: key);

  @override
  State<CatalogueContainer> createState() => _CatalogueContainerState();
}

class _CatalogueContainerState extends State<CatalogueContainer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Container(
        //height: MediaQuery.of(context).size.width * 0.29,
        width: MediaQuery.of(context).size.width * 0.8,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Catalogue | ${widget.catalogueTitle}',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
            ),
            ListTile(
              leading: CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.08,
                backgroundImage: widget.listTileImage,
              ),
              title: Text(widget.listTileTitle),
              subtitle: Text(widget.listTileSubtitle),
              trailing: Text(widget.listTileTrailing , style: const TextStyle(fontSize: 20),),),

          ],
        ),

      ),
    );
  }
}
