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
import 'package:flutter/material.dart';
import 'package:testing/controllers/notification_service.dart';
import 'package:testing/views/cart/cart_view.dart';
import 'views/auth/login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await NotificationService().initialize();

  runApp(const MvcApp());
}

class MvcApp extends StatelessWidget {
  const MvcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter MVC App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (snapshot.hasData) {
            return const CartView();
          }
          return const LoginView();
        },
      ),
    );
  }
}