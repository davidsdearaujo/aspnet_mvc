import 'package:flutter/foundation.dart';

import 'actions.dart';
import 'routes.dart';
import 'view.dart';

class _NoAction extends ActionMvc {
  const _NoAction();
}

abstract class ControllerMvc extends ValueNotifier<ActionMvc> {
  ControllerMvc() : super(const _NoAction());
  Map<String, Function> get routes;

  late final _functionHandler = FunctionHandler(this);
  void Function() run(Function fn) => () => _functionHandler.handleFunction(fn);

  dynamic lastModel;

  @override
  set value(ActionMvc newValue) {
    if (newValue is ViewMvc) {
      lastModel = newValue.model;
    }
    super.value = newValue;
  }
}
