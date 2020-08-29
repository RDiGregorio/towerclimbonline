part of util;

class ResourceManager {
  Map<dynamic, dynamic> _map = {};
  SetMultimap<dynamic, dynamic> _futures = SetMultimap();
  Function _exists, _load, _save;
  final bool periodicSave;
  Map<dynamic, StreamSubscription<DateTime>> _metronomeSubscriptions = {};

  ResourceManager(
      {dynamic exists(dynamic key),
      dynamic load(dynamic key),
      dynamic save(dynamic key, dynamic value, void cleanup()),
      this.periodicSave = true}) {
    _exists = exists;
    _load = load;
    _save = save;
  }

  Map<dynamic, dynamic> get resources => UnmodifiableMapView(_map);

  Future<bool> exists(dynamic key) async =>
      _map.containsKey(key) || await _exists(key);

  /// Loads a resource. The resource is saved every 15 minutes or when [future]
  /// completes.

  Future<dynamic> getResource(
      dynamic function(), dynamic key, Future<dynamic> future) async {
    if (_futures[_map[key] ??=
            await _exists(key) ? await _load(key) : _newResource(key, function)]
        .add(future)) {
      if (periodicSave)
        _metronomeSubscriptions[key] ??=
            Metronome.periodic(const Duration(minutes: 5))
                .listen((time) => _save?.call(key, _map[key], () => null));

      Future(() async {
        await future;

        if (_futures.containsKey(_map[key]) &&
            (_futures[_map[key]]..remove(future)).isEmpty)
          _save?.call(key, _map[key], () {
            _metronomeSubscriptions.remove(key)?.cancel();
            _map.remove(key);
          });
      });
    }

    return _map[key];
  }

  void replace(dynamic key, dynamic value) {
    if (!_map.containsKey(key)) Logger.root.warning('missing resource: $key');
    _map[key] = value;
  }

  void saveAll() =>
      _map.forEach((key, value) => _save?.call(key, value, () => null));

  dynamic _newResource(dynamic key, dynamic function()) {
    var result = function();
    _save?.call(key, result, () => null);
    return result;
  }
}
