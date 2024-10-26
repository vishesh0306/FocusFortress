
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focusflow/Provider/CountProvider.dart';
import 'package:provider/provider.dart';

class Secondscreen extends StatefulWidget {
  const Secondscreen();

  @override
  State<Secondscreen> createState() => _SecondscreenState();
}

class _SecondscreenState extends State<Secondscreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("Second Screen"),
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

                ],
              );
            },

          ),
        ),
        floatingActionButton:
        Consumer<Countprovider>(
          builder: (BuildContext context, Countprovider pro, Widget? child) {
            return FloatingActionButton(
              onPressed: pro.decrease,
              tooltip: 'Increment',
              child: const Icon(Icons.exposure_minus_1),
            );
          },
        )
    );
  }
}
