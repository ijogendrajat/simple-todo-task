import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      //home: TodoApp(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> todo = [];
  List<String> deletedtodo = [];

  late SharedPreferences prefs;
  bool clicked = false;
  TextEditingController value = TextEditingController();
  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      todo = prefs.getStringList('todos') ?? [];
      deletedtodo = prefs.getStringList('deletedtodo') ?? [];
    });
  }

  Future<void> saveTodos() async {
    await prefs.setStringList('todos', todo);
    await prefs.setStringList("deletedtodo", deletedtodo);
  }

  void addTodo() {
    setState(() {
      todo.add(value.text);
      value.clear();
      saveTodos();
    });
  }

  void removeTodoAt(int index) {
    setState(() {
      todo.remove(todo[index]);
      deletedtodo.add(todo[index]);
      print(todo);
      print(deletedtodo);
      saveTodos();
    });
  }

  // TODO: for more accurate with task update as created we can use timestamp with task List at created time.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                "ToDo List",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(
                height: 20,
              ),
              Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(2),
                      label: Text("Add a new todo item here"),
                    ),
                    controller: value,
                    onSubmitted: (value) => addTodo(),
                  ),
                ),
              ),
              Flexible(
                child: ListView.builder(
                  itemCount: todo.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: Checkbox(
                          value: false,
                          onChanged: (value) {
                            removeTodoAt(index);
                          },
                        ),
                        title: Text(todo[index]),
                      ),
                    );
                  },
                ),
              ),
              const Text(
                "Completed TODO",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Flexible(
                child: ListView.builder(
                  itemCount: deletedtodo.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: Checkbox(
                          value: true,
                          onChanged: (value) {
                            removeTodoAt(index);
                          },
                        ),
                        title: Text(deletedtodo[index]),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
