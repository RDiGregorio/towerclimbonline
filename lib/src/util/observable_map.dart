part of util;

/// Receives events from wrapped and unwrapped [ObservableMap] children. Unlike
/// other designs, dirty checking isn't needed here.

class ObservableMap extends MapBase<String?, dynamic> {
  late Stream<ObservableEvent> _events;
  StreamController<ObservableEvent> _controller = StreamController();
  Map<String?, dynamic> _map = {};
  SetMultimap<String?, ObservableMap> _parents = SetMultimap();

  ObservableMap([Map<String?, dynamic> map = const {}]) {
    addAll(map);
    _events = _controller.stream.asBroadcastStream();
  }

  Iterable<String?> get keys => _map.keys;

  dynamic operator [](dynamic key) => _map[key];

  /// [key] is removed if [value] is [null]. This allows removals to use
  /// "change" events.

  void operator []=(String? key, dynamic value) {
    assert(primitive(value) ||
        primitiveList(value) ||
        unwrap(value) is ObservableMap);

    if (value == null)
      remove(key);
    else if (_map[key] != value) {
      _unregister(key, _map[key]);
      _register(key, _map[key] = value);

      addEvent(
          ObservableEvent(type: 'change', path: [key], data: {'value': value}));
    }
  }

  void addEvent(ObservableEvent event) => _addEvent(event);

  void clear() {
    for (final k in keys.toList()) remove(k);
  }

  Stream<ObservableEvent> getEvents(
      {String? type, Iterable<String> path = const []}) {
    var list = List<String>.from(path);

    return _events.where((event) =>
        (type == null || event.type == type) &&
        listsEqual(List.from(event.path!.take(path.length)), list));
  }

  dynamic getPath(Iterable<String> path) =>
      path.fold(this, (dynamic value, key) => unwrap(value)[key]);

  dynamic remove(dynamic key) {
    if (!containsKey(key)) return null;
    var result = _map.remove(key);
    _unregister(key, result);

    addEvent(ObservableEvent(
        type: 'change', path: [key], data: const {'value': null}));

    return result;
  }

  void setPath(Iterable<dynamic> path, dynamic value) {
    path.length > 1
        ? unwrap(this[path.first]).setPath(path.skip(1), value)
        : this[path.first] = value;
  }

  void _addEvent(ObservableEvent event) {
    if (_controller.hasListener) _controller.add(event);

    _parents.forEach((key, parent) => parent.addEvent(ObservableEvent(
        type: event.type, path: [key]..addAll(event.path!), data: event.data)));
  }

  void _register(String? key, dynamic value) {
    value = unwrap(value);
    if (value is ObservableMap) value._parents.add(key, this);
  }

  void _unregister(String? key, dynamic value) {
    value = unwrap(value);
    if (value is ObservableMap) value._parents.remove(key, this);
  }
}
