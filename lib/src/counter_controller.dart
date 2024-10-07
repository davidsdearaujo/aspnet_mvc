part of 'counter.dart';

class CounterController extends Controller {
  @override
  late Map<String, Function> routes = {
    '/': counter,
  };

  final data = Datasource();

  Stream<IAction> counter() async* {
    yield CounterView(const CounterModel.loading());
    final count = await data.getTapsCount();
    yield CounterView(CounterModel.fetched(count));
  }

  void onIncrementTap() => RouteHandler(this).handle(increment);

  Stream<IAction> increment(CounterModel? model) async* {
    try {
      yield CounterView(CounterModel.loading(model?.count));
      final count = await data.increment();
      yield CounterView(CounterModel.fetched(count));
      // ignore: unused_catch_stack
    } catch (ex, stack) {
      yield ShowSnackBar(SnackBar(content: Text('Something went wrong: $ex')));
      yield CounterView(model ?? const CounterModel.empty());
    }
  }
}
