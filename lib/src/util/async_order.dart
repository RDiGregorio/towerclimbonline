part of util;

class AsyncOrder {
  Future<dynamic> _future;

  /// Waits for the futures returned from each [function] to complete before
  /// calling the next one.

  Future<dynamic> add(dynamic function()) async {
    while (_future != null) await _future;
    var result = await (_future = Future(function));
    _future = null;
    return result;
  }
}
