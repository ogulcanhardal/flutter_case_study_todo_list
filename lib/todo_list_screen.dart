import 'package:flutter/material.dart';
import '/task.dart';
import 'add_task_screen.dart';
import '/theme_switch.dart';

class ToDoListScreen extends StatefulWidget {
  final Function toggleTheme;
  final bool isDarkMode;

  ToDoListScreen({required this.toggleTheme, required this.isDarkMode});

  @override
  _ToDoListScreenState createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  List<Task> tasks = [];
  int _taskId = 0;

  void _addTask(String title) {
    setState(() {
      tasks.add(Task(id: _taskId++, title: title));
    });
  }

  void _removeTask(int id) {
    setState(() {
      tasks.removeWhere((task) => task.id == id);
    });
  }

  void _toggleTaskComplete(int id) {
    setState(() {
      tasks.firstWhere((task) => task.id == id).isComplete =
          !tasks.firstWhere((task) => task.id == id).isComplete;
    });
  }

  void _showAddTaskScreen() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AddTaskScreen(addTaskCallback: _addTask);
      },
    );
  }

  void _editTask(int id) {
    Task task = tasks.firstWhere((task) => task.id == id);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController controller =
            TextEditingController(text: task.title);
        return AlertDialog(
          title: const Text('Edit Task'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Enter task title',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.red), // Set text color to red
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  task.title = controller.text;
                });
                Navigator.pop(context); // Close dialog
              },
              child: const Text(
                'Save',
                style: TextStyle(color: Color.fromARGB(255, 1, 119, 87)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Before Sunset'),
        actions: [
          ThemeSwitch(
              isDarkMode: widget.isDarkMode, toggleTheme: widget.toggleTheme),
        ],
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Dismissible(
            key: Key(task.id.toString()),
            direction: DismissDirection.endToStart,
            background:
                Container(), // Empty container to disable left swipe background
            secondaryBackground: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.endToStart) {
                final bool res = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirm'),
                      content: const Text(
                          'Are you sure you want to delete this task?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: const Text(
                            'DELETE',
                            style: TextStyle(
                                color: Colors.red), // Set text color to red
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: const Text('CANCEL'),
                        ),
                      ],
                    );
                  },
                );
                return res;
              }
              return false; // Prevent dismissal for left swipe
            },
            onDismissed: (direction) {
              if (direction == DismissDirection.endToStart) {
                _removeTask(task.id);
              }
            },
            child: ListTile(
              title: Text(
                task.title,
                style: TextStyle(
                  fontSize: 20.0, // Set the font size here
                  decoration:
                      task.isComplete ? TextDecoration.lineThrough : null,
                ),
              ),
              onTap: () {
                _editTask(task.id);
              },
              leading: Checkbox(
                value: task.isComplete,
                onChanged: (value) {
                  _toggleTaskComplete(task.id);
                },
                activeColor: const Color.fromARGB(255, 1, 119, 87),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 1, 119, 87),
        foregroundColor: Colors.white,
        onPressed: _showAddTaskScreen,
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }
}
