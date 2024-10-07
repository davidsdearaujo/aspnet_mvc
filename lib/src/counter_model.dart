part of 'counter.dart';

class CounterModel {
  final int? count;
  final bool isLoading;

  const CounterModel.empty()
      : count = null,
        isLoading = false;
  const CounterModel.loading([this.count]) : isLoading = true;
  const CounterModel.fetched(this.count) : isLoading = false;
}
