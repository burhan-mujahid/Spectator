import 'package:flutter/material.dart';

class CategoriesPopupButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.grid_view_rounded, size: MediaQuery.of(context).size.width*0.07,),
      onPressed: () {
        _showCategoriesPopup(context);
      },
    );
  }

  void _showCategoriesPopup(BuildContext context) {
    final categories = [
      'Missing Children',
      'Missing Adults',
      'Found Children',
      'Found Adults',
      'Found Bodies',
    ];

    final popup = PopupMenuButton(
      itemBuilder: (context) {
        return categories.map((category) {
          return PopupMenuItem(
            value: category,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width*0.9,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context, category); // Close the popup and return the selected category
                        },
                        child: ListTile(
                          title: Text(category),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList();
      },
    );

    showDialog(
      context: context,
      builder: (context) {
        return popup;
      },
    );
  }
}