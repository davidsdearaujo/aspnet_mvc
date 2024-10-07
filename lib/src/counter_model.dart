class CounterModel {
  final int? count;
  final bool isLoading;

  const CounterModel.loading([this.count]) : isLoading = true;
  const CounterModel.fetched(this.count) : isLoading = false;

  @override
  bool operator ==(covariant CounterModel other) {
    if (identical(this, other)) return true;
    return other.count == count && other.isLoading == isLoading;
  }

  @override
  int get hashCode => count.hashCode ^ isLoading.hashCode;
}
