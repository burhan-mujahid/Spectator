import 'package:flutter/material.dart';

import '../widgets/page_heading.dart';
import '../widgets/sos_catalogue_container.dart';

class SOSTab extends StatefulWidget {
  const SOSTab({Key? key}) : super(key: key);

  @override
  State<SOSTab> createState() => _SOSTabState();
}

class _SOSTabState extends State<SOSTab> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(

        children:  const [

          //Page Heading
          PageHeading(title: 'Emergency Contacts', subtitle: 'Emergency Helpline Numbers'),


          //Police Conatiner
          SOSCatalogueContainer(catalogueTitle: 'Police',
              listTileImage: AssetImage('images/police.png'),
              listTileTitle: '15',
              listTileSubtitle: 'Police Emergency Helpline',
              phoneNumber: '15'),

          //Emergency Service Department container
          SOSCatalogueContainer(
              catalogueTitle: 'Emergency Service Department',
              listTileImage: AssetImage('images/rescue1122.png'),
              listTileTitle: '1122',
              listTileSubtitle: 'Punjab Rescue Service',
              phoneNumber: '1122'),


          //Ministry Of Human Rights container
          SOSCatalogueContainer(
              catalogueTitle: 'Ministry of Human Rights (MoHR)',
              listTileImage: AssetImage('images/mohr.png'),
              listTileTitle:'1099',
              listTileSubtitle: 'MoHR Helpline',
              phoneNumber: '1099'),

          //Child Protection & Welfare Unit container
          SOSCatalogueContainer(
              catalogueTitle: 'Child Protection & Welfare Unit',
              listTileImage: AssetImage('images/child_protection.png'),
              listTileTitle: '1121',
              listTileSubtitle: 'CP & WU Helpline',
              phoneNumber: '1121'),



          //E-Complaint container
          SOSCatalogueContainer(catalogueTitle: 'IGP Complaint Centre',
              listTileImage: AssetImage('images/punjab_police.png'),
              listTileTitle: '1787',
              listTileSubtitle: 'IGP Complaint Centre',
              phoneNumber: '1787')

        ],

      ),
    );
  }
}
