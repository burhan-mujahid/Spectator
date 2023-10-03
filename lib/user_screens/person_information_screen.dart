// import 'package:flutter/material.dart';
// import 'package:photo_view/photo_view.dart';
// import 'package:photo_view/photo_view_gallery.dart';
// import 'user_profile.dart';
//
//
//
// class PersonInformationScreen extends StatelessWidget {
//   final Report report;
//
//   const PersonInformationScreenV({required this.report});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Person Information'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => FullScreenImage(imageUrl: report.personImage),
//                     ),
//                   );
//                 },
//                 child: Container(
//                   height: MediaQuery.of(context).size.width * 0.7,
//                   width: MediaQuery.of(context).size.width * 0.7,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.shade400,
//                         blurRadius: 10,
//                       ),
//                     ],
//                   ),
//                   child: PhotoView(
//                     imageProvider: NetworkImage(report.personImage),
//                     minScale: PhotoViewComputedScale.contained,
//                     maxScale: PhotoViewComputedScale.covered * 2.0,
//                     backgroundDecoration: BoxDecoration(
//                       color: Colors.transparent,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 16.0),
//             Text(
//               'Person Details',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 20.0,
//               ),
//             ),
//             SizedBox(height: 16.0),
//             DataTableTheme(
//               data: DataTableThemeData(
//                 dividerThickness: 1.0,
//                 dataRowColor: MaterialStateColor.resolveWith((states) => Colors.grey.shade200),
//                 headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey.shade200),
//                 headingRowHeight: 48.0,
//               ),
//               child: DataTable(
//                 columnSpacing: 16.0,
//                 columns: [
//                   DataColumn(
//                     label: Text(
//                       'Field',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18.0,
//                       ),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Text(
//                       'Information',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18.0,
//                       ),
//                     ),
//                   ),
//                 ],
//                 rows: [
//                   DataRow(
//                     cells: [
//                       DataCell(Text(
//                         'Name',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16.0,
//                         ),
//                       )),
//                       DataCell(Text(
//                         report.personName,
//                         style: TextStyle(
//                           fontSize: 16.0,
//                         ),
//                       )),
//                     ],
//                   ),
//                   DataRow(
//                     cells: [
//                       DataCell(Text(
//                         'Gender',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16.0,
//                         ),
//                       )),
//                       DataCell(Text(
//                         report.personGender,
//                         style: TextStyle(
//                           fontSize: 16.0,
//                         ),
//                       )),
//                     ],
//                   ),
//                   DataRow(
//                     cells: [
//                       DataCell(Text(
//                         'Age',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16.0,
//                         ),
//                       )),
//                       DataCell(Text(
//                         report.personAge,
//                         style: TextStyle(
//                           fontSize: 16.0,
//                         ),
//                       )),
//                     ],
//                   ),
//                   DataRow(
//                     cells: [
//                       DataCell(Text(
//                         'Description',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16.0,
//                         ),
//                       )),
//                       DataCell(Text(
//                         report.personDescription,
//                         style: TextStyle(
//                           fontSize: 16.0,
//                         ),
//                       )),
//                     ],
//                   ),
//                   DataRow(
//                     cells: [
//                       DataCell(Text(
//                         'Date',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16.0,
//                         ),
//                       )),
//                       DataCell(Text(
//                         report.dateLastSeen,
//                         style: TextStyle(
//                           fontSize: 16.0,
//                         ),
//                       )),
//                     ],
//                   ),
//                   DataRow(
//                     cells: [
//                       DataCell(Text(
//                         'Location',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16.0,
//                         ),
//                       )),
//                       DataCell(Text(
//                         report.locationLastSeen,
//                         style: TextStyle(
//                           fontSize: 16.0,
//                         ),
//                       )),
//                     ],
//                   ),
//
//                   DataRow(
//                     cells: [
//                       DataCell(Text(
//                         'City',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16.0,
//                         ),
//                       )),
//                       DataCell(Text(
//                         report.city,
//                         style: TextStyle(
//                           fontSize: 16.0,
//                         ),
//                       )),
//                     ],
//                   ),
//
//                   DataRow(
//                     cells: [
//                       DataCell(Text(
//                         'Contact Name',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16.0,
//                         ),
//                       )),
//                       DataCell(Text(
//                         report.contactName + '  (' + report.contactRelation + ')',
//                         style: TextStyle(
//                           fontSize: 16.0,
//                         ),
//                       )),
//                     ],
//                   ),
//
//
//
//                   DataRow(
//                     cells: [
//                       DataCell(Text(
//                         'Contact Number',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16.0,
//                         ),
//                       )),
//                       DataCell(Text(
//                         report.contact,
//                         style: TextStyle(
//                           fontSize: 16.0,
//                         ),
//                       )),
//                     ],
//                   ),
//
//
//
//
//                   DataRow(
//                     cells: [
//                       DataCell(Text(
//                         'Reported By',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16.0,
//                         ),
//                       )),
//                       DataCell(Text(
//                         report.reportedBy,
//                         style: TextStyle(
//                           fontSize: 16.0,
//                         ),
//                       )),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 16.0),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
// class PersonInformationScreenV extends StatefulWidget {
//   final Report report;
//
//   const PersonInformationScreen({required this.report});
//
//   @override
//   State<PersonInformationScreenV> createState() => _PersonInformationScreenVState();
// }
//
// class _PersonInformationScreenVState extends State<PersonInformationScreenV> {
//   bool isEditing = false;
//
//   // Form fields controllers
//   final personNameController = TextEditingController();
//   final personAgeController = TextEditingController();
//   final personGenderController = TextEditingController();
//   final personDescriptionController = TextEditingController();
//   final dateLastSeenController = TextEditingController();
//   final contactController = TextEditingController();
//   final contactNameController = TextEditingController();
//   final contactRelationController = TextEditingController();
//   final cityController = TextEditingController();
//   final locationLastSeenController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     // Initialize form fields with existing report data
//     personNameController.text = widget.report.personName;
//     personAgeController.text = widget.report.personAge;
//     personGenderController.text = widget.report.personGender;
//     personDescriptionController.text = widget.report.personDescription;
//     dateLastSeenController.text=widget.report.dateLastSeen;
//     contactNameController.text=widget.report.contactName;
//     contactRelationController.text = widget.report.contactRelation;
//     contactController.text = widget.report.contact;
//     cityController.text = widget.report.city;
//     locationLastSeenController.text = widget.report.locationLastSeen;
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Person Information'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => FullScreenImage(imageUrl: report.personImage),
//                     ),
//                   );
//                 },
//                 child: Container(
//                   height: MediaQuery.of(context).size.width * 0.7,
//                   width: MediaQuery.of(context).size.width * 0.7,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.shade400,
//                         blurRadius: 10,
//                       ),
//                     ],
//                   ),
//                   child: PhotoView(
//                     imageProvider: NetworkImage(report.personImage),
//                     minScale: PhotoViewComputedScale.contained,
//                     maxScale: PhotoViewComputedScale.covered * 2.0,
//                     backgroundDecoration: BoxDecoration(
//                       color: Colors.transparent,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 16.0),
//             Text(
//               'Person Details',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 20.0,
//               ),
//             ),
//             SizedBox(height: 16.0),
//             DataTableTheme(
//               data: DataTableThemeData(
//                 dividerThickness: 1.0,
//                 dataRowColor: MaterialStateColor.resolveWith((states) => Colors.grey.shade200),
//                 headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey.shade200),
//                 headingRowHeight: 48.0,
//               ),
//               child: DataTable(
//                 columnSpacing: 16.0,
//                 columns: [
//                   DataColumn(
//                     label: Text(
//                       'Field',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18.0,
//                       ),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Text(
//                       'Information',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18.0,
//                       ),
//                     ),
//                   ),
//                 ],
//                 rows: [
//                   DataRow(
//                     cells: [
//                       DataCell(Text(
//                         'Name',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16.0,
//                         ),
//                       )),
//                       DataCell(Text(
//                         report.personName,
//                         style: TextStyle(
//                           fontSize: 16.0,
//                         ),
//                       )),
//                     ],
//                   ),
//                   DataRow(
//                     cells: [
//                       DataCell(Text(
//                         'Gender',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16.0,
//                         ),
//                       )),
//                       DataCell(Text(
//                         report.personGender,
//                         style: TextStyle(
//                           fontSize: 16.0,
//                         ),
//                       )),
//                     ],
//                   ),
//                   DataRow(
//                     cells: [
//                       DataCell(Text(
//                         'Age',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16.0,
//                         ),
//                       )),
//                       DataCell(Text(
//                         report.personAge,
//                         style: TextStyle(
//                           fontSize: 16.0,
//                         ),
//                       )),
//                     ],
//                   ),
//                   DataRow(
//                     cells: [
//                       DataCell(Text(
//                         'Description',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16.0,
//                         ),
//                       )),
//                       DataCell(Text(
//                         report.personDescription,
//                         style: TextStyle(
//                           fontSize: 16.0,
//                         ),
//                       )),
//                     ],
//                   ),
//                   DataRow(
//                     cells: [
//                       DataCell(Text(
//                         'Date',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16.0,
//                         ),
//                       )),
//                       DataCell(Text(
//                         report.dateLastSeen,
//                         style: TextStyle(
//                           fontSize: 16.0,
//                         ),
//                       )),
//                     ],
//                   ),
//                   DataRow(
//                     cells: [
//                       DataCell(Text(
//                         'Location',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16.0,
//                         ),
//                       )),
//                       DataCell(Text(
//                         report.locationLastSeen,
//                         style: TextStyle(
//                           fontSize: 16.0,
//                         ),
//                       )),
//                     ],
//                   ),
//
//                   DataRow(
//                     cells: [
//                       DataCell(Text(
//                         'City',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16.0,
//                         ),
//                       )),
//                       DataCell(Text(
//                         report.city,
//                         style: TextStyle(
//                           fontSize: 16.0,
//                         ),
//                       )),
//                     ],
//                   ),
//
//                   DataRow(
//                     cells: [
//                       DataCell(Text(
//                         'Contact Name',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16.0,
//                         ),
//                       )),
//                       DataCell(Text(
//                         report.contactName + '  (' + report.contactRelation + ')',
//                         style: TextStyle(
//                           fontSize: 16.0,
//                         ),
//                       )),
//                     ],
//                   ),
//
//
//
//                   DataRow(
//                     cells: [
//                       DataCell(Text(
//                         'Contact Number',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16.0,
//                         ),
//                       )),
//                       DataCell(Text(
//                         report.contact,
//                         style: TextStyle(
//                           fontSize: 16.0,
//                         ),
//                       )),
//                     ],
//                   ),
//
//
//
//
//                   DataRow(
//                     cells: [
//                       DataCell(Text(
//                         'Reported By',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16.0,
//                         ),
//                       )),
//                       DataCell(Text(
//                         report.reportedBy,
//                         style: TextStyle(
//                           fontSize: 16.0,
//                         ),
//                       )),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 16.0),
//
//             // Add the Edit and Delete buttons
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 5.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton(
//                     onPressed: isEditing ? null : _handleEdit,
//                     child: Text(isEditing ? 'Editing...' : 'Edit'),
//                   ),
//                   SizedBox(width: 5,),
//                   ElevatedButton(
//                     onPressed: _handleDelete,
//                     style: ElevatedButton.styleFrom(primary: Colors.red),
//                     child: Text('Delete'),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _handleEdit() {
//     setState(() {
//       isEditing = true;
//     });
//   }
//
//   void _handleDelete() {
//     // Show a confirmation dialog
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Delete Report'),
//           content: Text('Are you sure you want to delete this report?'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: _confirmDeleteReport,
//               child: Text('Delete'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _confirmDeleteReport() async {
//     // Perform the actual deletion from the database
//     final databaseRef = FirebaseFirestore.instance.collection('Users');
//     try {
//       await databaseRef.doc(widget.report.id).delete();
//       Navigator.pop(context);
//     } catch (e) {
//       // Handle any errors that occur during deletion
//       Utils().toastMessage('Error deleting report');
//     }
//   }
// }
//
//
// class FullScreenImage extends StatelessWidget {
//   final String imageUrl;
//
//   const FullScreenImage({required this.imageUrl});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         child: PhotoViewGallery(
//           backgroundDecoration: BoxDecoration(
//             color: Colors.black,
//           ),
//           pageOptions: [
//             PhotoViewGalleryPageOptions(
//               imageProvider: NetworkImage(imageUrl),
//               minScale: PhotoViewComputedScale.contained,
//               maxScale: PhotoViewComputedScale.covered * 2.0,
//             ),
//           ],
//           loadingBuilder: (context, event) => Center(
//             child: CircularProgressIndicator(),
//           ),
//         ),
//       ),
//     );
//   }
// }