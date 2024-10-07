part of 'counter.dart';

class CounterView extends ViewMvc<CounterModel, CounterController> {
  CounterView(super.model);

  @override
  Widget build(CounterController controller) {
    return _CounterView(controller: controller, model: model);
  }
}

class _CounterView extends StatelessWidget {
  final CounterController controller;
  final CounterModel model;
  // ignore: unused_element
  const _CounterView({super.key, required this.controller, required this.model});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      floatingActionButton: FloatingActionButton(
        onPressed: model.isLoading ? null : controller.onIncrementTap,
        child: model.isLoading
            ? const Center(
                child: SizedBox.square(
                  dimension: 25,
                  child: CircularProgressIndicator(),
                ),
              )
            : const Icon(Icons.add),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You pushed the button this many times:'),
            Text(
              key: ValueKey(model.count),
              '${model.count ?? '-'}',
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ],
        ),
      ),
    );
  }
}
