part of 'counter.dart';

class CounterController extends MvcController {
  @override
  late Map<String, Function> routes = {
    '/': counter,
  };

  final data = Datasource();

  Stream<MvcAction> counter() async* {
    yield CounterView(const CounterModel.loading());
    final count = await data.getTapsCount();
    yield CounterView(CounterModel.fetched(count));
  }

  Stream<MvcAction> increment(CounterModel? model) async* {
    try {
      yield CounterView(CounterModel.loading(model?.count));
      final count = await data.increment();
      yield CounterView(CounterModel.fetched(count));
      // ignore: unused_catch_stack
    } catch (ex, stack) {
      yield ShowSnackBarAction(SnackBar(content: Text('Something went wrong: $ex')));
      yield CounterView(model ?? const CounterModel.empty());
    }
  }
}
