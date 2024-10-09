abstract class Datasource {
  factory Datasource() = DatasourceImpl;
  Future<int> getTapsCount();
  Future<int> increment();
  Future<int> reset();
}

class DatasourceImpl implements Datasource {
  int tapsCount = 0;
  DateTime lastIncrementTime = DateTime.fromMillisecondsSinceEpoch(0);

  @override
  Future<int> getTapsCount() async {
    await Future.delayed(const Duration(seconds: 2));
    return tapsCount;
  }

  @override
  Future<int> increment() async {
    await Future.delayed(const Duration(seconds: 1));
    validateCanIncrement();

    tapsCount++;
    return tapsCount;
  }

  @override
  Future<int> reset() async {
    await Future.delayed(const Duration(seconds: 1));
    tapsCount = 0;
    return tapsCount;
  }

  void validateCanIncrement() {
    final now = DateTime.now();
    final secondsSinceLastTap = lastIncrementTime.difference(now).inSeconds.abs();
    if (secondsSinceLastTap < 5) {
      throw 'Time waited: ${secondsSinceLastTap}s.\nPlease wait 5s between each increment request.';
    }
    lastIncrementTime = now;
  }
}
