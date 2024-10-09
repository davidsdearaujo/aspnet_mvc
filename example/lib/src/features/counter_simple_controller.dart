part of 'counter_simple.dart';

class CounterController extends ControllerMvc {
  @override
  late Map<String, Function> routes = {
    '/': counter,
  };

  final data = Datasource();

  Stream<ViewMvc> counter() async* {
    yield CounterView();
    final count = await data.getTapsCount();
    yield CounterView(CounterModel(count: count));
  }

  Stream<ActionMvc> increment(CounterModel? model) async* {
    try {
      yield CounterView(model?.copyWith(isLoading: true));
      final count = await data.increment();
      yield CounterView(CounterModel(count: count));
      // ignore: unused_catch_stack
    } catch (ex, stack) {
      yield ShowSnackBarAction(SnackBar(content: Text('Something went wrong: $ex')));
      yield CounterView(model);
    }
  }
}
