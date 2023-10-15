import 'dart:async';

import 'package:ngdart/angular.dart';
import 'package:ngforms/angular_forms.dart';
import 'package:towerclimbonline/client.dart';
import 'package:towerclimbonline/util.dart';

@Component(
    selector: 'scores-modal',
    directives: [coreDirectives, formDirectives],
    templateUrl: 'high_scores_modal.html')
class HighScoresModal {
  static Timer? _timer;

  // Admin accounts should not appear on the high scores.

  static const List<String> _filteredAccounts = [
    'robert',
    'astral',
    'astral2',
    'astral5',
    'astral7',
    'eris',
    'eris2',
    'test3'
  ];

  static String current = 'scores';
  static List<List<dynamic>> scores = const [];

  HighScoresModal() {
    view(current);

    _timer ??= Timer.periodic(Duration(minutes: 1), (timer) {
      if (ClientGlobals.currentModal == 'scores') _update(current);
    });
  }

  String format(dynamic score) => formatCurrency(score, false);

  Future<dynamic> view(String key) async {
    current = key;

    if (ClientGlobals.session == null) {
      Future(() => view(key));
      return null;
    }

    _update(key);
  }

  void _update(String key) async {
    scores = List.from((await ClientGlobals.session!.remote(#scores, [key]))
        .where((score) => !_filteredAccounts.contains(score[0]))
        .take(20));
  }
}
