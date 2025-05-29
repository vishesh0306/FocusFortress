import 'package:flutter/foundation.dart';
import '../Targeted TODOs/TargetedTodoScreen.dart';
import '../utils/TodoService.dart';

class TodoNotifier extends ChangeNotifier {
  final TodoService _service = TodoService();
  List<Todo> _todos = [];

  TodoNotifier() {
    _todos = _service.getTodos();
  }

  List<Todo> get todos => _todos;

  void add(Todo todo) {
    _service.addTodo(todo);
    _todos = _service.getTodos();
    notifyListeners();
  }

  void update(String id, Todo todo) {
    _service.updateTodo(id, todo);
    _todos = _service.getTodos();
    notifyListeners();
  }

  void delete(String id) {
    _service.deleteTodo(id);
    _todos = _service.getTodos();
    notifyListeners();
  }

  void toggleComplete(String id) {
    _service.toggleComplete(id);
    _todos = _service.getTodos();
    notifyListeners();
  }

  void toggleReminder(String id) {
    _service.toggleReminder(id);
    _todos = _service.getTodos();
    notifyListeners();
  }
}
