import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Challange Yourself/CreateChallangePage.dart';
import 'Challange Yourself/challengeListingPage.dart';
import 'Daily Challenges/ToDOPage.dart';
import 'Progress Package/CertificatePage.dart';
import 'Shared_Preference.dart';
import 'Targeted TODOs/TargetedTodoScreen.dart';
import 'auth/AuthService.dart';

class MyHomePage extends StatefulWidget {
  final userId;
   MyHomePage({super.key, required this.userId});

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
          actions: [
            IconButton(
                onPressed: () async {
                  try {
                    AuthService.logout();
                    await SharedPrefsHelper.logout();
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                  catch(e){
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Logout failed. Please try again.')),
                    );
                  }
                },
                icon: Icon(Icons.logout,))
          ],
        ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChallengeList(userId: widget.userId,)),
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 100),
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent[100],
                   borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    "Challenge Yourself",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),

              SizedBox(height: 20),

              GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TodoPage(userId: widget.userId,)),
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 100),
                  decoration: BoxDecoration(
                    color: Colors.lightGreenAccent[100],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    "Set Daily Targets",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),

              SizedBox(height: 20),

              GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TodoScreen(userId: widget.userId,)),
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 100),
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent[100],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    "Set Your Goals",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),

              SizedBox(height: 20),

              GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CertificatePage(),
                  ));
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 100),
                  decoration: BoxDecoration(
                    color: Colors.yellowAccent[100],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    "Check Progress",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),


            ],
          ),
        ),
      ),



      // floatingActionButton: FloatingActionButton(
      //     onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context)=> CreateChallengePage(userId: widget.userId,)));
      //     },
      //     child: Icon(Icons.add)
      // ),
    );
  }
}
