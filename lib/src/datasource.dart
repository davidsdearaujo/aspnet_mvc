abstract class Datasource {
  factory Datasource() = DatasourceImpl;
  Future<int> getTapsCount();
  Future<int> increment();
}

class DatasourceImpl implements Datasource {
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
