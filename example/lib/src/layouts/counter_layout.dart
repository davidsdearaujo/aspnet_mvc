import 'package:flutter/material.dart';

class CounterLayout extends StatelessWidget {
  static Widget builder(BuildContext context, Widget child) {
    return CounterLayout(child: child);
  }

  final Widget? child;
  const CounterLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      resizeToAvoidBottomInset: true,
      primary: true,
      body: child,
    );
  }
}
