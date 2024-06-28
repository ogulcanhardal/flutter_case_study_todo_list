import 'package:flutter/material.dart';

class AddTaskScreen extends StatefulWidget {
  final Function(String) addTaskCallback;
  AddTaskScreen({required this.addTaskCallback});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _taskController = TextEditingController();
  String? _errorMessage;

  void _handleAddTask() {
    if (_taskController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter task title';
      });
    } else {
      widget.addTaskCallback(_taskController.text);
      Navigator.pop(context); // Close the add task screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _taskController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Enter task title',
                errorText: _errorMessage,
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the add task screen
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _handleAddTask,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 1, 119, 87)),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  child: const Text('Create To-Do'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
