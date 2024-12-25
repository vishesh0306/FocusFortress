import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focusflow/Challange%20Yourself/AllChallangesPage.dart';
import 'package:provider/provider.dart';

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
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> AllchallangesPage()));
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blue[300],
                  ),
                  margin: EdgeInsets.only(top: 15,left: 15),
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                    child: Text("Challange YourSelf", style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),)),
              ),
            ],
          ),
        ));
  }
}
