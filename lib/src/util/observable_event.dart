part of util;

/// Encodable with [mapWrapperEncoder].

class ObservableEvent implements Wrapper<Map<String, dynamic>> {
  Map<String, dynamic> _internal;

  ObservableEvent(
      {String type = '',
      List<dynamic> path = const [],
      Map<String, dynamic> data = const {}}) {
    _internal = {'type': type, 'path': path, 'data': data};
  }

  Map<String, dynamic> get data => internal['data'];

  Map<String, dynamic> get internal => _internal;

  List<dynamic> get path => internal['path'];

  String get type => internal['type'];
}
