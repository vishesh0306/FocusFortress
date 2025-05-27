import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _todos = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _userId;

  List<Map<String, dynamic>> get todos => _todos;

  void setUserId(String userId) {
    _userId = userId;
    fetchTodos(); // fetch on setting user
  }

  Future<void> fetchTodos() async {
    if (_userId == null) return;
    final snapshot = await _firestore
        .collection("Users")
        .doc(_userId)
        .collection("DailyMissions")
        .get();

    _todos = snapshot.docs
        .map((doc) => {"id": doc.id, "text": doc["text"], "completed": doc["completed"]})
        .toList();
    notifyListeners();
  }

  Future<void> addTodo(String text) async {
    if (_userId == null) return;

    final docRef = await _firestore
        .collection("Users")
        .doc(_userId)
        .collection("DailyMissions")
        .add({"text": text, "completed": false});

    _todos.add({"id": docRef.id, "text": text, "completed": false});
    notifyListeners();
  }

  Future<void> toggleTodo(int index, bool? value) async {
    if (_userId == null || index < 0 || index >= _todos.length) return;

    String id = _todos[index]["id"];
    bool newValue = value ?? false;

    await _firestore
        .collection("Users")
        .doc(_userId)
        .collection("DailyMissions")
        .doc(id)
        .update({"completed": newValue});

    _todos[index]["completed"] = newValue;
    notifyListeners();
  }

  Future<void> clearTodo(int index) async {
    if (_userId == null || index < 0 || index >= _todos.length) return;

    String id = _todos[index]["id"];

    await _firestore
        .collection("Users")
        .doc(_userId)
        .collection("DailyMissions")
        .doc(id)
        .delete();

    _todos.removeAt(index);
    notifyListeners();
  }
}
