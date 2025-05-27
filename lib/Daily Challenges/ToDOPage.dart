import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/ToDoProvider.dart';

class TodoPage extends StatelessWidget {
  final String userId;
  TodoPage({super.key, required this.userId});

  void _showAddTodoDialog(BuildContext context) {
    TextEditingController controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(labelText: "Task Name"),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  if (controller.text.isNotEmpty) {
                    await Provider.of<TodoProvider>(context, listen: false)
                        .addTodo(controller.text);
                    Navigator.pop(context);
                  }
                },
                child: Text("Add"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);
    todoProvider.setUserId(userId); // Setup Firestore path and load data

    return Scaffold(
      appBar: AppBar(title: Text("Dynamic TODO List")),
      body: Consumer<TodoProvider>(
        builder: (context, todoProvider, child) {
          if (todoProvider.todos.isEmpty) {
            return Center(
              child: Text(
                "You have no TODOs",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }

          return ListView.builder(
            itemCount: todoProvider.todos.length,
            itemBuilder: (context, index) {
              final todo = todoProvider.todos[index];
              return ListTile(
                leading: Checkbox(
                  value: todo["completed"],
                  onChanged: (value) =>
                      todoProvider.toggleTodo(index, value),
                ),
                title: Text(
                  todo["text"],
                  style: TextStyle(
                    decoration: todo["completed"]
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                trailing: todo["completed"]
                    ? TextButton(
                  onPressed: () => todoProvider.clearTodo(index),
                  child: Text("Clear", style: TextStyle(color: Colors.red)),
                )
                    : null,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTodoDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
