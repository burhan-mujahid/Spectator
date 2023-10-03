import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SolvedCasesPage2 extends StatefulWidget {



  @override
  _SolvedCasesPage2State createState() => _SolvedCasesPage2State();
}

class _SolvedCasesPage2State extends State<SolvedCasesPage2> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> solvedCasesStream;

  @override
  void initState() {
    super.initState();
    solvedCasesStream = FirebaseFirestore.instance.collection('SolvedCases').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: solvedCasesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No solved cases available.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final solvedCase = snapshot.data!.docs[index];

              final firstReport = solvedCase['firstReport'] as Map<String, dynamic>;
              final secondReport = solvedCase['secondReport'] as Map<String, dynamic>;
              final timestamp = (solvedCase['timestamp'] as Timestamp).toDate();

              return Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.width * 0.05),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
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
                        ListTile(
                          title: Text('Solved: ${firstReport['personName']}', style: TextStyle(color: Colors.green),),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
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
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: MediaQuery.of(context).size.width * 0.08,
                                backgroundImage: NetworkImage(firstReport['personImage']),
                              ),
                              title: Text(firstReport['personName']),
                              subtitle:  Text('${firstReport['locationLastSeen']}, ${firstReport['city']}'),
                            ),
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.width * 0.05),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
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
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: MediaQuery.of(context).size.width * 0.08,
                                backgroundImage: NetworkImage(secondReport['personImage']),
                              ),
                              title: Text(secondReport['personName']),
                              subtitle: Text('${secondReport['locationLastSeen']}, ${secondReport['city']}'),
                            ),
                          ),
                        ),
                        Divider(),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
