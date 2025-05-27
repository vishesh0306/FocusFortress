
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focusflow/Provider/CountProvider.dart';
import 'package:provider/provider.dart';

import 'CreateChallangePage.dart';

class AllchallangesPage extends StatefulWidget {
  final String userId;
  AllchallangesPage({super.key, required this.userId});

  @override
  State<AllchallangesPage> createState() => _AllchallangesPageState();
}

class _AllchallangesPageState extends State<AllchallangesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Challanges"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text("Are You\n Ready?",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),),

              SizedBox(height: 25,),
              Center(
                child: Text("Are You Ready to challange yourself?",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: 15,),

              ElevatedButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> CreateChallengePage(userId: widget.userId,)));
              },

              child: Text("Start A New Challange"))

            ],
          ),
        ),
      ),

    );
  }
}
