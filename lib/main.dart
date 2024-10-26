import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Provider/CountProvider.dart';
import 'homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Countprovider>(create: (_) => Countprovider(),),
      ],
      child: MaterialApp(
        title: 'Focus Fortress',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: MyHomePage(),
      ),
    );
  }
}
