import 'package:flutter/material.dart';
import 'package:focusflow/auth/login.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'Provider/CountProvider.dart';
import 'homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform,
  );
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
        // home: LoginPage(),
        initialRoute: '/',
        routes: {
          '/': (context) => LoginPage(),
          '/signup': (context) => SignupPage(),
          '/homepage': (context) => MyHomePage(),
        },
      ),
    );
  }
}
