part of 'counter_simple.dart';

class CounterView extends ViewMvc<CounterModel?, CounterController> {
  CounterView([super.model]);

  @override
  Widget build(CounterController controller) {
    return _CounterView(
      controller: controller,
      model: model,
    );
  }
}

class _CounterView extends StatelessWidget {
  final CounterController controller;
  final CounterModel? model;
  // ignore: unused_element
  const _CounterView({super.key, required this.controller, required this.model});

  @override
  Widget build(BuildContext context) {
    return CustomFloatingActionButton(
      isLoading: model?.isLoading != false,
      onPressed: controller.run(controller.increment),
      icon: const Icon(Icons.add),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You pushed the button this many times:'),
            Text(
              '${model?.count ?? '--'}',
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ],
        ),
      ),
    );
  }
}
