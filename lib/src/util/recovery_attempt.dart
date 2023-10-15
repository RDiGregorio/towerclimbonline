part of util;

class RecoveryAttempt {
  late DateTime _expirationDate;
  final String code;

  RecoveryAttempt(this.code) {
    _expirationDate = DateTime.now().add(const Duration(hours: 1));
  }

  bool get expired => DateTime.now().isAfter(_expirationDate);
}
