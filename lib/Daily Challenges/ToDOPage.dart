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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Add New Task",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: "Task Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.task_alt, color: Colors.deepPurple),
                ),
                autofocus: true,
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    if (controller.text.isNotEmpty) {
                      await Provider.of<TodoProvider>(context, listen: false)
                          .addTodo(controller.text);
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    "Add Task",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
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
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Set Daily Targets", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        elevation: 5,

      ),
      body: Consumer<TodoProvider>(
        builder: (context, todoProvider, child) {
          if (todoProvider.todos.isEmpty) {
            return Center(
              child: Text(
                "You have no TODOs",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurpleAccent,
                ),
              ),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            itemCount: todoProvider.todos.length,
            separatorBuilder: (_, __) => SizedBox(height: 10),
            itemBuilder: (context, index) {
              final todo = todoProvider.todos[index];
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                shadowColor: Colors.deepPurple.withOpacity(0.3),
                child: ListTile(
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  leading: Checkbox(
                    activeColor: Colors.deepPurple,
                    value: todo["completed"],
                    onChanged: (value) =>
                        todoProvider.toggleTodo(index, value),
                  ),
                  title: Text(
                    todo["text"],
                    style: TextStyle(
                      fontSize: 16,
                      decoration: todo["completed"]
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      color:
                      todo["completed"] ? Colors.grey : Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: todo["completed"]
                      ? TextButton(
                    onPressed: () => todoProvider.clearTodo(index),
                    child: Text(
                      "Clear",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                      : null,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () => _showAddTodoDialog(context),
        child: Icon(Icons.add, color: Colors.white,),
      ),
    );
  }
}
