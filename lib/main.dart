import 'package:flutter/material.dart';
import 'controllers/task.dart';
import 'encrypted/env.dart';
import 'views/task_list.dart';

void main() {
  runApp(TaskListApp());
}

class TaskListApp extends StatelessWidget {
  final TaskListController controller = TaskListController();
  final Env env = Env.create();

  TaskListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(env.envKeyOne),
        ),
        body: TaskListView(controller: controller),
      ),
    );
  }
}
