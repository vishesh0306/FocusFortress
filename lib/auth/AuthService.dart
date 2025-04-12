import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<void> logout() async {
    // 1. Sign out from Firebase
    await FirebaseAuth.instance.signOut();

    // 2. Clear local session (SharedPreferences)
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
