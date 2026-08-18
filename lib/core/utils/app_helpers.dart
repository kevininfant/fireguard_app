import 'package:intl/intl.dart';

class AppHelpers {
  AppHelpers._();

  static String formatPoints(int points) {
    final formatter = NumberFormat('#,###');
    return '${formatter.format(points)} PTS';
  }

  static String formatTimeRemaining(int seconds) {
    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }
}
