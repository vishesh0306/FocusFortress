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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Your Challenges'),
        automaticallyImplyLeading: false,
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

                      return ListTile(
                        title: Text(name),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChallengeProofPage(
                                id: doc.id,
                                name: name,
                                // You can pass more fields like duration and motive
                                // duration: doc['duration'],
                                // motive: doc['motive'],
                              ),
                            ),
                          );
                        },
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
          onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context)=> CreateChallengePage()));
          },
          child: Icon(Icons.add)
      ),
    );
  }
}
