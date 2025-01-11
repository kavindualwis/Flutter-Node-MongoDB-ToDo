// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:to_do/Api%20Services/api_services.dart';
import 'package:to_do/Widgets/colors.dart';
import 'package:to_do/Widgets/task_tile.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final String token;
  const HomePage({super.key, required this.token});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //TextEditingController for the task input field
  TextEditingController taskController = TextEditingController();

  //User ID from the token decoded
  late String userId;

  //Get the user ID from the token decoded
  @override
  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodToken = JwtDecoder.decode(widget.token);

    userId = jwtDecodToken['_id'];
    getTodolist(userId);
  }

  //Show time based on time of the day
  DateTime dateTime = DateTime.now();
  Text showtime() {
    if (dateTime.hour < 12) {
      return Text('Good Morning');
    } else if (dateTime.hour < 17) {
      return Text('Good Afternoon');
    } else {
      return Text('Good Evening');
    }
  }

  //Task list
  List todos = [];

  //Pop up ModalBottomSheet Methods
  void addTask() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      sheetAnimationStyle: AnimationStyle(
        curve: Curves.linear,
        duration: const Duration(milliseconds: 700),
      ),
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(""),
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: red,
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close_outlined,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            TextField(
              controller: taskController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.black, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                    width: 2,
                  ),
                ),
                hintText: 'Add Task',
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 25,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                if (taskController.text.isNotEmpty) {
                  createTask();
                  getTodolist(userId);
                  Navigator.pop(context);
                  taskController.clear();
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog.adaptive(
                      backgroundColor: Colors.grey[200],
                      insetAnimationCurve: Curves.linear,
                      insetAnimationDuration:
                          const Duration(milliseconds: 2000),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35),
                      ),
                      title: const Text(
                        'Oops you forgot to add a task 🤔👀!!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Oops',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Add Task',
                  style: TextStyle(
                    color: bgColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Create Task Method to add task to the database
  void createTask() async {
    if (taskController.text.isNotEmpty) {
      var regBody = {
        'desc': taskController.text,
        'userId': userId,
      };

      // ignore: unused_local_variable
      var response = await http.post(
        Uri.parse(createToDo),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(regBody),
      );
    }
  }

  //Get all the tasks from the database
  void getTodolist(userId) async {
    var regBody = {
      'userId': userId,
    };

    var response = await http.post(
      Uri.parse(getToDo),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(regBody),
    );

    var jsonResponse = jsonDecode(response.body);

    todos = jsonResponse['success'];

    setState(() {});
  }

  //Delete Task Method to delete task from the database
  void deleteToDoItem(String id) async {
    var regBody = {
      'id': id,
    };

    var response = await http.post(
      Uri.parse(deleteToDo),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(regBody),
    );

    var jsonResponse = jsonDecode(response.body);

    if (jsonResponse['status']) {
      showSnackBar(context, 'Task Deleted');
      getTodolist(userId);
    } else {
      showSnackBar(context, 'Failed to delete task');
    }
  }

  //SnackBar Method to show a message at the bottom of the screen
  void showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: red,
        duration: const Duration(seconds: 3),
        content: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: _buildAppBar(),

      //New task Listview
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Stack(
          children: [
            // List of tasks
            Positioned.fill(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  searchBox(),
                  const SizedBox(height: 20),
                  const Text(
                    "All ToDos",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: todos.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: TaskTile(
                            text: todos[index]['desc'],
                            onTap: () => deleteToDoItem(todos[index]['_id']),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Floating container at the bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap:
                    addTask, // Call the addTask method when the container is tapped
                child: addTaskButton(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Appbar Widget
  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: bgColor,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello.!',
                style: const TextStyle(
                  color: black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                showtime().data.toString(),
                style: const TextStyle(
                  color: black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              height: 45,
              width: 45,
              child: Image.asset('assets/images/kavi.png'),
            ),
          ),
        ],
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: bgColor, // Prevents color change on scroll
        ),
      ),
    );
  }
}

//Search Box
Widget searchBox() {
  return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: black,
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
          hintText: '  Search',
          hintStyle: TextStyle(
            color: grey,
          ),
          border: InputBorder.none,
        ),
      ));
}

//Add task button
Widget addTaskButton(BuildContext context) {
  return Container(
    margin: const EdgeInsets.only(bottom: 5),
    width: double.infinity,
    height: MediaQuery.of(context).size.height * 0.06,
    decoration: BoxDecoration(
      color: blue,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Center(
      child: Text(
        'Add a new todo item',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    ),
  );
}
