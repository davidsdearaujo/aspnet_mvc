import 'package:aspnet_mvc/aspnet_mvc.dart';
import 'package:flutter/material.dart';

import 'src/core/custom_actions.dart';
import 'src/features/counter_simple.dart';
import 'src/layouts/counter_layout.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final counter = CounterController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        ...ControllerRoutes(
          counter,
          customActions: customActions,
          layoutBuilder: CounterLayout.builder,
        ).call(),
      },
    );
  }
}
