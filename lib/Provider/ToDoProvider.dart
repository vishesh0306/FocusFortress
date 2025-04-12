import 'package:flutter/material.dart';

class TodoProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _todos = [];

  List<Map<String, dynamic>> get todos => _todos;

  void addTodo(String text) {
    _todos.add({"text": text, "completed": false});
    notifyListeners();
  }

  void toggleTodo(int index, bool? value) {
    if (index >= 0 && index < _todos.length) {
      _todos[index]["completed"] = value ?? false;
      notifyListeners();
    }
  }

  void clearTodo(int index) {
    if (index >= 0 && index < _todos.length) {
      _todos.removeAt(index);
      notifyListeners();
    }
  }
}
