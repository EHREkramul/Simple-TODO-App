import 'package:flutter/material.dart';
import 'package:todo_list/todo.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO',
      debugShowCheckedModeBanner: false,
      home: TODO(),
    );
  }
}
