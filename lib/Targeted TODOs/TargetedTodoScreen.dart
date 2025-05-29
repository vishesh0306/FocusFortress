import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';  // for date formatting
import '../Provider/TargetToDoProvider.dart';
class Todo {
  final String id;
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final bool isCompleted;
  final bool isReminderSet;

  Todo({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    this.isCompleted = false,
    this.isReminderSet = false,
  });

  Todo copyWith({
    String? title,
    DateTime? startDate,
    DateTime? endDate,
    bool? isCompleted,
    bool? isReminderSet,
  }) {
    return Todo(
      id: id,
      title: title ?? this.title,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isCompleted: isCompleted ?? this.isCompleted,
      isReminderSet: isReminderSet ?? this.isReminderSet,
    );
  }
}

class TodoCard extends StatelessWidget {
  final Todo todo;
  final VoidCallback onComplete;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onToggleReminder;

  const TodoCard({
    super.key,
    required this.todo,
    required this.onComplete,
    required this.onDelete,
    required this.onEdit,
    required this.onToggleReminder,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.yMMMd();
    final style = todo.isCompleted
        ? const TextStyle(
      decoration: TextDecoration.lineThrough,
      color: Colors.grey,
      fontSize: 18,
    )
        : const TextStyle(fontSize: 18, fontWeight: FontWeight.w600);

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(todo.title, style: style),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.play_arrow, color: Colors.green.shade400, size: 18),
                const SizedBox(width: 6),
                Text("Start: ${dateFormat.format(todo.startDate)}",
                    style: TextStyle(color: Colors.grey[700])),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.stop, color: Colors.red.shade400, size: 18),
                const SizedBox(width: 6),
                Text("End: ${dateFormat.format(todo.endDate)}",
                    style: TextStyle(color: Colors.grey[700])),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue.shade600),
                  tooltip: "Edit ToDo",
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: Icon(
                    todo.isReminderSet
                        ? Icons.notifications_active
                        : Icons.notifications_none,
                    color:
                    todo.isReminderSet ? Colors.orange.shade700 : Colors.grey,
                  ),
                  tooltip: todo.isReminderSet
                      ? "Disable Reminder"
                      : "Enable Reminder",
                  onPressed: onToggleReminder,
                ),
                IconButton(
                  icon: Icon(Icons.check_circle,
                      color: todo.isCompleted ? Colors.green : Colors.grey),
                  tooltip: todo.isCompleted ? "Mark Incomplete" : "Mark Complete",
                  onPressed: onComplete,
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red.shade600),
                  tooltip: "Delete ToDo",
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TodoScreen extends StatefulWidget {
  final String userId;

  const TodoScreen({super.key, required this.userId});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;

  void _showForm({Todo? todo}) {
    if (todo != null) {
      titleController.text = todo.title;
      startDate = todo.startDate;
      endDate = todo.endDate;
    } else {
      titleController.clear();
      startDate = null;
      endDate = null;
    }

    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      context: context,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
            left: 24, right: 24, top: 24, bottom: MediaQuery.of(context).viewInsets.bottom + 24),
        child: Form(
          key: _formKey,
          child: Wrap(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'ToDo Title',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.task),
                ),
                validator: (val) => val!.isEmpty ? 'Enter title' : null,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    startDate == null
                        ? 'Start Date'
                        : DateFormat.yMMMd().format(startDate!),
                    style: const TextStyle(fontSize: 16),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.date_range),
                    label: const Text("Pick Start"),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: startDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) setState(() => startDate = picked);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    endDate == null
                        ? 'End Date'
                        : DateFormat.yMMMd().format(endDate!),
                    style: const TextStyle(fontSize: 16),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.date_range),
                    label: const Text("Pick End"),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: endDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) setState(() => endDate = picked);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(todo == null ? "Add Your Goal" : "Update your Goal",
                      style: const TextStyle(fontSize: 18)),
                  onPressed: () {
                    if (_formKey.currentState!.validate() &&
                        startDate != null &&
                        endDate != null) {
                      final newTodo = Todo(
                        id: todo?.id ?? const Uuid().v4(),
                        title: titleController.text,
                        startDate: startDate!,
                        endDate: endDate!,
                        isCompleted: todo?.isCompleted ?? false,
                        isReminderSet: todo?.isReminderSet ?? false,
                      );
                      final provider = context.read<TodoNotifier>();
                      if (todo == null) {
                        provider.add(newTodo);
                      } else {
                        provider.update(todo.id, newTodo);
                      }
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final todos = context.watch<TodoNotifier>().todos;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text("Set Your Goals", style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 6,
      ),
      body: todos.isEmpty
          ? const Center(
        child: Text(
          "No ToDos yet. Tap + to add",
          style: TextStyle(fontSize: 20, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: todos.length,
        itemBuilder: (_, index) {
          final todo = todos[index];
          return TodoCard(
            todo: todo,
            onEdit: () => _showForm(todo: todo),
            onDelete: () => context.read<TodoNotifier>().delete(todo.id),
            onComplete: () => context.read<TodoNotifier>().toggleComplete(todo.id),
            onToggleReminder: () => context.read<TodoNotifier>().toggleReminder(todo.id),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: _showForm,
        child: const Icon(Icons.add, color: Colors.white,),
        tooltip: "Add New ToDo",
      ),
    );
  }
}
