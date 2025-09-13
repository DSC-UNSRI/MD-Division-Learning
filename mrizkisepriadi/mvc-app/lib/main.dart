// import 'package:flutter/material.dart';
// import 'controllers/task.dart';
// // import 'encrypted/env.dart';
// import 'views/task_list.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

//   runApp(TaskListApp());
// }

// class TaskListApp extends StatelessWidget {
//   final TaskListController controller = TaskListController();

//   TaskListApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text(controller.tasks.isNotEmpty
//               ? "${controller.tasks.length} tasks"
//               : "No tasks"),
//         ),
//         body: TaskListView(controller: controller),
//       ),
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:testing/controllers/notification_controller.dart';
import 'package:testing/firebase_options.dart';
import 'package:testing/views/cart/cart_view.dart';
import 'views/auth/login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await NotificationController.initialize();
      } catch (e) {
        print('Error initializing notifications in main: $e');
      }
    }
  } catch (e) {
    print('Error in main initialization: $e');
  }

  runApp(MvcApp());
}

class MvcApp extends StatelessWidget {
  MvcApp({super.key});
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter MVC App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: user != null ? CartView() : LoginView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
