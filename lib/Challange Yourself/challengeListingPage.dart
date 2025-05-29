import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CreateChallangePage.dart';
import 'ProgressPage.dart';

class ChallengeList extends StatefulWidget {
  final userId;
  ChallengeList({super.key, required this.userId});

  @override
  State<ChallengeList> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ChallengeList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Your Challenges', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Example: Some other widgets on the page
              Text(
                'Welcome to Challenges!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text('Track your progress by choosing a challenge below.'),
              SizedBox(height: 20),
              // StreamBuilder embedded in a Column
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .collection('Challenges')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text('No challenges found.');
                  }

                  List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: documents.map((doc) {
                      String name = doc['name'];

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            leading: Icon(Icons.folder_open, color: Colors.deepPurple),
                            title: Text(
                              name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChallengeProofPage(
                                    id: doc.id,
                                    name: name,
                                    userId: widget.userId,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  );

                },
              ),

              SizedBox(height: 20),


            ],
          ),
        ),
      ),



      floatingActionButton: FloatingActionButton(
          onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context)=> CreateChallengePage(userId: widget.userId,)));
          },
          child: Icon(Icons.add)
      ),
    );
  }
}
