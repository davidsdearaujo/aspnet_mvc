// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:fake_reflection/fake_reflection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Stream<int> customAction() async* {
    yield 0;
    await Future.delayed(const Duration(seconds: 2));
    yield 1;
  }

  test('Counter increments smoke test', () async {
    final Function fn = customAction;
    final data = fn.reflection();
    if (data.className == 'Stream') {
      final Stream<int> stream = Function.apply(fn, null);
      await for (int emitedItem in stream) {
        debugPrint('$emitedItem');
      }
    }
  });
}
