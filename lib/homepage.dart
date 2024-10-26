
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focusflow/Provider/CountProvider.dart';
import 'package:focusflow/secondScreen.dart';
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
      body: Center(
        child: Consumer<Countprovider>(
          builder: (BuildContext context, Countprovider pro, Widget? child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'You have pushed the button this many times:',
                ),
                Text(
                  '${pro.count}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),

                ElevatedButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Secondscreen()));
                }, child: Text("Next Screen"))

              ],
            );
          },

        ),
      ),
      floatingActionButton:
      Consumer<Countprovider>(
        builder: (BuildContext context, Countprovider pro, Widget? child) {
          return FloatingActionButton(
            onPressed: pro.increase,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          );
        },
      )
    );
  }
}
