class Inform {
  static const String notification = '1';

  String getName({required String minor}) {
    switch (minor) {
      case notification:
        return 'notification';
      default:
        return 'unknown';
    }
  }
}
