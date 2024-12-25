import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focusflow/Challange%20Yourself/AllChallangesPage.dart';
import 'package:provider/provider.dart';

import 'Challange Yourself/CreateChallangePage.dart';
import 'Challange Yourself/ProgressPage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text('DashBoard'),
          automaticallyImplyLeading: false,
        ),
        // body: SingleChildScrollView(
        //   child: Column(
        //     children: [
        //
        //       Text("Challange Yourself", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
        //
        //
        //       GestureDetector(
        //         onTap: (){
        //           Navigator.push(context, MaterialPageRoute(builder: (context)=> AllchallangesPage()));
        //         },
        //         child: Container(
        //           decoration: BoxDecoration(
        //             borderRadius: BorderRadius.circular(20),
        //             color: Colors.blue[300],
        //           ),
        //           margin: EdgeInsets.only(top: 15,left: 15),
        //           padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        //             child: Text("Create a new challange", style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),)),
        //       ),
        //
        //       Text("Active Challanges", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
        //
        //
        //
        //     ],
        //   ),
        // ),

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
                stream: FirebaseFirestore.instance.collection('Challenges').snapshots(),
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
                              builder: (context) => ProgressPage(
                                name: name,
                                duration: doc['duration'],
                                motive: doc['motive'],
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
