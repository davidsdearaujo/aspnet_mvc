import 'package:fake_reflection/fake_reflection.dart';
import 'package:flutter/material.dart';

import 'actions.dart';
import 'controller.dart';
import 'view.dart';

typedef ValidationCallback = bool Function(Object action);
typedef ExecutionCallback = void Function(BuildContext context, Object action);
typedef LayoutBuilder = Widget Function(BuildContext context, Widget child);
Widget _defaultLayoutBuilder(BuildContext context, Widget child) => child;

class ControllerRoutes<TController extends ControllerMvc> {
  final TController controller;
  final Map<ValidationCallback, ExecutionCallback> customActions;
  final LayoutBuilder layoutBuilder;
  ControllerRoutes(this.controller, {this.customActions = const {}, this.layoutBuilder = _defaultLayoutBuilder});

  Map<String, WidgetBuilder> call() {
    final response = <String, WidgetBuilder>{};
    for (var entry in controller.routes.entries) {
      final path = entry.key;
      final route = entry.value;
      response[path] = (context) => ControllerHandler(controller, route, customActions, layoutBuilder);
    }
    return response;
  }
}

class ControllerHandler<TController extends ControllerMvc> extends StatefulWidget {
  final TController controller;
  final Function route;
  final Map<ValidationCallback, ExecutionCallback> customHandlers;
  final LayoutBuilder layoutBuilder;
  const ControllerHandler(this.controller, this.route, this.customHandlers, this.layoutBuilder, {super.key});

  @override
  State<ControllerHandler> createState() => _ControllerHandlerState();
}

class _ControllerHandlerState extends State<ControllerHandler> {
  Widget? lastView;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_controllerListener);
    widget.controller.run(widget.route).call();
  }

  @override
  void reassemble() {
    widget.controller.removeListener(_controllerListener);
    super.reassemble();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_controllerListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.controller,
      builder: (context, action, _) {
        return switch (action) {
          ViewMvc view => lastView = widget.layoutBuilder(
              context,
              view.build(widget.controller),
            ),
          _ => lastView ?? const NoViewConfigured(),
        };
      },
    );
  }

  void _controllerListener() {
    widget.controller.value.mapOrElse(
      navigate: (action) {
        Navigator.of(context, rootNavigator: true).pushReplacementNamed(action.route);
      },
      pushRoute: (action) {
        Navigator.of(context, rootNavigator: true).pushNamed(action.route);
      },
      orElse: () {
        for (final MapEntry(key: validate, value: execute) in widget.customHandlers.entries) {
          if (validate(widget.controller.value)) {
            execute(context, widget.controller.value);
          }
        }
      },
    );
  }
}

class FunctionHandler {
  final ControllerMvc _controller;
  const FunctionHandler(this._controller);

  Future<void> handleFunction(Function route) async {
    final classData = route.reflection();
    final params = handleParams(classData);

    if (classData.className == 'Stream') {
      final Stream<ActionMvc> stream = Function.apply(route, params);
      await for (ActionMvc emitedAction in stream) {
        _controller.value = emitedAction;
      }
    } else if (classData.className == 'Future') {
      try {
        final Future<ActionMvc> actionFuture = Function.apply(route, params);
        final action = await actionFuture;
        _controller.value = action;
        // ignore: unused_catch_stack
      } catch (ex, stack) {
        print('ERROR!!!!! $ex');
      }
    } else {
      //if (classData.className == '$ActionMvc') {
      final action = Function.apply(route, params);
      print(action);
      _controller.value = action;
    }
  }

  List handleParams(ClassData classData) {
    final response = [];
    if (classData.positionalParams.isNotEmpty) {
      for (var param in classData.positionalParams) {
        if (param.type == '${_controller.lastModel.runtimeType}' || (param.nullable && _controller.lastModel == null)) {
          response.add(_controller.lastModel);
        }
      }
    }
    return response;
  }
}

class NoViewConfigured extends StatelessWidget {
  const NoViewConfigured({super.key});

  @override
  Widget build(BuildContext context) {
    return const Material(
      child: Center(child: CircularProgressIndicator()),
    );
    // return const Material(
    //   child: kDebugMode ? Center(child: Text('No view configured.')) : SizedBox.shrink(),
    // );
  }
}
