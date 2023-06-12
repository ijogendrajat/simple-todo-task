import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoApp extends StatefulWidget {
  @override
  _TodoAppState createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  List<String> todos = [];
  final TextEditingController textEditingController = TextEditingController();
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      todos = prefs.getStringList('todos') ?? [];
    });
  }

  Future<void> saveTodos() async {
    await prefs.setStringList('todos', todos);
  }

  void addTodo() {
    setState(() {
      todos.add(textEditingController.text);
      textEditingController.clear();
      saveTodos();
    });
  }

  void removeTodoAt(int index) {
    setState(() {
      todos.removeAt(index);
      saveTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo App'),
      ),
      body: Column(
        children: [
          TextField(
            controller: textEditingController,
            decoration: InputDecoration(
              hintText: 'Enter a todo',
            ),
            onSubmitted: (_) => addTodo(),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(todos[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => removeTodoAt(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
