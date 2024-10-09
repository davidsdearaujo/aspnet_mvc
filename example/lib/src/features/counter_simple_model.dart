// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'counter_simple.dart';

class CounterModel {
  final int count;
  final bool isLoading;
  const CounterModel({
    required this.count,
    this.isLoading = false,
  });

  CounterModel copyWith({
    int? count,
    bool? isLoading,
  }) {
    return CounterModel(
      count: count ?? this.count,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
