import 'package:flutter/material.dart';

import '../widgets/catalogue_container.dart';
import '../widgets/latest_entries.dart';
import '../widgets/page_heading.dart';

class MatchTab extends StatefulWidget {
  const MatchTab({Key? key}) : super(key: key);

  @override
  State<MatchTab> createState() => _MatchTabState();
}

class _MatchTabState extends State<MatchTab> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(

        children: const [
          PageHeading(title: 'Solved Cases', subtitle: 'Currently Available List of Matches Found'),


          CatalogueContainer(catalogueTitle: 'Solved Cases', listTileImage: AssetImage('images/matches_found.png'), listTileTitle: 'Matches Found', listTileSubtitle: 'List of Solved Cases', listTileTrailing: '2'),

          LatestEntriesSection(),


        ],


      ),

    );
  }
}
