part of util;

/// Holds the highest scores.

class Scores extends OnlineObject {
  Scores() {
    internal['scores'] ??= ObservableMap();
  }

  List<dynamic> get list {
    var scores = internal['scores'],
        result = List.from(scores.keys.map((key) => [key, scores[key]]))
          ..sort((first, second) => -big(first[1])!.compareTo(big(second[1])!));

    return List<dynamic>.from(
        result.map((list) => [list[0], formatNumber(list[1])]));
  }

  void add(String username, dynamic score) {
    username = sanitizeName(username);
    var scores = internal['scores'];

    if (scores.length >= 100) {
      if (List<dynamic>.from(scores.values)
          .any((value) => big(value)! < big(score)!)) {
        scores.remove(List<String>.from(scores.keys).reduce((first, second) =>
            big(scores[first])! < big(scores[second])! ? first : second));

        scores[username] = '$score';
      }

      return;
    }

    scores[username] = '$score';
  }

  void clear() => internal['scores'].clear();

  void remove(String username) {
    internal['scores'].remove(sanitizeName(username));
  }
}
