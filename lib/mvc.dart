import 'package:fake_reflection/fake_reflection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

sealed class IAction {}

class _Empty implements IAction {
  const _Empty();
}

class LastView implements IAction {
  const LastView();
}

abstract class ViewMvc<TModel, TController extends Controller> implements IAction {
  final TModel model;
  const ViewMvc(this.model);

  Widget build(TController controller);
}

class RedirectTo implements IAction {
  final String route;
  const RedirectTo(this.route);
}

class PushRoute implements IAction {
  final String route;
  const PushRoute(this.route);
}

abstract class Controller extends ValueNotifier<IAction> {
  Controller() : super(const _Empty());
  Map<String, Function> get routes;

  dynamic lastModel;

  @override
  set value(IAction newValue) {
    if (newValue is ViewMvc) {
      lastModel = newValue.model;
    }
    super.value = newValue;
  }
}

class ControllerRoutes<TController extends Controller> {
  final TController controller;
  ControllerRoutes(this.controller);

  Map<String, WidgetBuilder> call() {
    final response = <String, WidgetBuilder>{};
    for (var entry in controller.routes.entries) {
      final path = entry.key;
      final route = entry.value;
      response[path] = (context) => ControllerHandler(controller, route);
    }
    return response;
  }
}

class ControllerHandler<TController extends Controller> extends StatefulWidget {
  final TController controller;
  final Function route;
  const ControllerHandler(this.controller, this.route, {super.key});

  @override
  State<ControllerHandler> createState() => _ControllerHandlerState();
}

class _ControllerHandlerState extends State<ControllerHandler> {
  Widget? lastView;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_controllerListener);
    handleRoute(widget.route);
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
          ViewMvc view => lastView = view.build(widget.controller),
          _ => lastView ?? const NoViewConfigured(),
        };
      },
    );
  }

  Future<void> handleRoute(Function route) async {
    //TODO: Inject model in the parameters when it's needed.
    final classData = route.reflection();
    if (classData.className == 'Stream') {
      final Stream<IAction> stream = Function.apply(route, null);
      await for (IAction emitedAction in stream) {
        widget.controller.value = emitedAction;
      }
    } else if (classData.className == 'Future') {
      try {
        final Future<IAction> actionFuture = Function.apply(route, null);
        final action = await actionFuture;
        widget.controller.value = action;
      } catch (ex, stack) {
        print('ERROR!!!!! $ex');
      }
    } else if (classData.className == 'IAction') {
      final IAction action = Function.apply(route, null);
      widget.controller.value = action;
    }
  }

  void _controllerListener() {
    switch (widget.controller.value) {
      case RedirectTo redirect:
        Navigator.of(context, rootNavigator: true).pushReplacementNamed(redirect.route);
        break;
      case PushRoute push:
        Navigator.of(context, rootNavigator: true).pushNamed(push.route);
        break;
      default:
        break;
    }
  }
}

class NoViewConfigured extends StatelessWidget {
  const NoViewConfigured({super.key});

  @override
  Widget build(BuildContext context) {
    return kDebugMode ? const Center(child: Text('No view configured.')) : const SizedBox.shrink();
  }
}


// class ReactiveView extends StatelessWidget {
//   final IMvcView view;
//   const ReactiveView(this.view, {super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ListenableBuilder(
//       listenable: view.model,
//       builder: (context, _) => view,
//     );
//   }
// }

// class ControllerManager<TController extends MvcController, TModel extends MvcModel> extends StatefulWidget {
//   final FutureOr<Widget> Function(BuildContext context, TModel? model) builder;
//   final TController controller;
//   const ControllerManager({
//     super.key,
//     required this.builder,
//     required this.controller,
//   });

//   @override
//   State<ControllerManager<TController, TModel>> createState() => _ControllerManagerState<TController, TModel>();
// }

// class _ControllerManagerState<TController extends MvcController, TModel extends MvcModel>
//     extends State<ControllerManager<TController, TModel>> {
//   late Future<Widget> future;
//   late TController controller = widget.controller;
//   TModel? model;

//   @override
//   void initState() {
//     super.initState();
//     future = Future.value(widget.builder(context, model));
//   }

//   @override
//   void didUpdateWidget(covariant ControllerManager<TController, TModel> oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.builder != oldWidget.builder) {
//       future = Future.value(widget.builder(context, model));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<Widget>(
//       future: future,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState != ConnectionState.done) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         if (model == null) return snapshot.data!;
//         return ListenableBuilder(
//           listenable: model!,
//           builder: (context),
//         );
//       },
//     );
//   }
// }
