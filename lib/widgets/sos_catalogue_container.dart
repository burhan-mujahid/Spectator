import 'package:flutter/material.dart';
import 'package:spectator/user_screens/sos_services_screen.dart';
import 'package:spectator/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';


class SOSCatalogueContainer extends StatefulWidget {
  final String catalogueTitle;
  final AssetImage listTileImage;
  final String listTileTitle;
  final String listTileSubtitle;
  final String phoneNumber;

  const SOSCatalogueContainer({
    Key? key,
    required this.catalogueTitle,
    required this.listTileImage,
    required this.listTileTitle,
    required this.listTileSubtitle,
    this.phoneNumber='042 ',
  }) : super(key: key);

  @override
  State<SOSCatalogueContainer> createState() => _SOSCatalogueContainerState();
}

class _SOSCatalogueContainerState extends State<SOSCatalogueContainer> {

  void _launchPhoneDialer(String? phoneNumber) async {
    final url = 'tel:$phoneNumber';
    try {
      if (await canLaunchUrlString(url.toString())) {
        await launchUrlString(url.toString());
        Utils().toastMessage('Heading to Phone Dialer');
      } else {
        Utils().toastMessage('Cannot Launch Phone Dialer');
        throw 'Could not launch phone dialer';
      }
    } catch (e) {
      Utils().toastMessage('Error launching phone dialer: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerHeight = screenWidth * 0.30;
    final containerWidth = screenWidth * 0.8;
    final avatarRadius = screenWidth * 0.08;
    final iconSize = screenWidth * 0.050;
    final titleFontSize = screenWidth * 0.050;
    final subtitleFontSize = screenWidth * 0.030;
    final catalogueTitleFontSize = screenWidth * 0.035;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenWidth * 0.02),
      child: Container(
        height: containerHeight,
        width: containerWidth,
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.02),
              child: Text(
                'Catalogue | ${widget.catalogueTitle}',
                style: TextStyle(
                  fontSize: catalogueTitleFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: CircleAvatar(
                radius: avatarRadius,
                backgroundImage: widget.listTileImage,
              ),
              title: Text(
                widget.listTileTitle,
                style: TextStyle(fontSize: titleFontSize),
              ),
              subtitle: Text(
                widget.listTileSubtitle,
                style: TextStyle(fontSize: subtitleFontSize),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.phone,
                  size: iconSize,
                  color: Colors.blue,
                ),
                onPressed: () {
                  _launchPhoneDialer(widget.phoneNumber);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
