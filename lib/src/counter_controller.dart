import 'package:mvc_poc/mvc.dart';
import 'package:mvc_poc/src/counter_view.dart';

import 'counter_model.dart';

class CounterController extends Controller {
  @override
  late Map<String, Function> routes = {
    '/': counter,
  };

  final data = CounterData();

  Stream<IAction> counter() async* {
    yield CounterView(const CounterModel.loading());
    final count = await data.getTapsCount();
    yield CounterView(CounterModel.fetched(count));
  }

  Future<void> onIncrementTap() async {
    await for (IAction action in increment(lastModel)) {
      value = action;
    }
  }

  Stream<IAction> increment(CounterModel model) async* {
    yield CounterView(CounterModel.loading(model.count));
    final count = await data.increment();
    yield CounterView(CounterModel.fetched(count));
  }
}

abstract class CounterData {
  factory CounterData() = CounterDataImpl;
  Future<int> getTapsCount();
  Future<int> increment();
}

class CounterDataImpl implements CounterData {
  int tapsCount = 0;

  @override
  Future<int> getTapsCount() async {
    await Future.delayed(const Duration(seconds: 2));
    return tapsCount;
  }

  @override
  Future<int> increment() async {
    await Future.delayed(const Duration(seconds: 2));
    tapsCount++;
    return tapsCount;
  }
}
