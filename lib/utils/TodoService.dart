
import '../Targeted TODOs/TargetedTodoScreen.dart';

class TodoService {
  final List<Todo> _todos = [];

  List<Todo> getTodos() => [..._todos];

  void addTodo(Todo todo) {
    _todos.add(todo);
  }

  void updateTodo(String id, Todo updated) {
    final index = _todos.indexWhere((t) => t.id == id);
    if (index == -1) throw Exception("ToDo not found");
    _todos[index] = updated;
  }

  void deleteTodo(String id) {
    _todos.removeWhere((t) => t.id == id);
  }

  void toggleComplete(String id) {
    final index = _todos.indexWhere((t) => t.id == id);
    if (index == -1) throw Exception("ToDo not found");
    _todos[index] = _todos[index].copyWith(isCompleted: !_todos[index].isCompleted);
  }

  void toggleReminder(String id) {
    final index = _todos.indexWhere((t) => t.id == id);
    if (index == -1) throw Exception("ToDo not found");
    _todos[index] = _todos[index].copyWith(isReminderSet: !_todos[index].isReminderSet);
  }
}
