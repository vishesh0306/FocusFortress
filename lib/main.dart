import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:focusflow/auth/login.dart';
import 'package:focusflow/homepage.dart'; // Ensure you import your homepage
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Provider/ToDoProvider.dart';
import 'Shared_Preference.dart';
import 'Provider/CountProvider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Firebase.initializeApp();

  // Get user data (login status and userId)
  Map<String, dynamic> userData = await SharedPrefsHelper.getUserData();
  bool isLoggedIn = userData["isLoggedIn"];
  String? userId = userData["userId"];

  runApp(MyApp(isLoggedIn: isLoggedIn, userId: userId));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String? userId;

  const MyApp({super.key, required this.isLoggedIn, required this.userId});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Countprovider>(create: (_) => Countprovider(),),
        ChangeNotifierProvider<TodoProvider>(create: (_) => TodoProvider()),
      ],
      child: MaterialApp(
        title: 'Focus Fortress',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: isLoggedIn ? '/homepage' : '/login', // Conditional routing
        routes: {
          '/login': (context) => LoginPage(),
          '/signup': (context) => SignupPage(),
          '/homepage': (context) => MyHomePage(userId: userId!), // Pass userId to HomePage
        },
      ),
    );
  }
}
