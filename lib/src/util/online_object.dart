part of util;

/// Extend this and make all constructor arguments optional.

class OnlineObject extends Wrapper<ObservableMap> {
  final ObservableMap internal = ObservableMap();
  String? _id;

  OnlineObject() {
    internal['id'] = uuid();
  }

  String get id => _id ??= internal['id'];

  String toString() => '$runtimeType$internal';
}
