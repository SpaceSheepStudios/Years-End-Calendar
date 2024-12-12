import 'dart:async';

class Countdown {
  final DateTime targetDate;
  late Timer _timer;
  String countdownText = '';

  Countdown(this.targetDate);

  // Starts countdown and updates countdownText every 1 second
  void startCountdown(void Function(String) updateCountdown) {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      updateCountdown(getCountdown());
    });
  }



  // Calculates the remaining time until targetDate and returns it in "DD:HH:MM:SS" format
  String getCountdown() {
    // Current Date and Time
    final currentDate = DateTime.now();

    // --- DEBUGGING ---
    // Time-Travel for debugging Calendar(02.12 of this year, 22:59:59)
    //final currentDate = DateTime.utc(DateTime.now().year, 12, 2, 22, 59, 59);
    // Time-Travel for debugging History and Countdown (05.05 of next year, 22:59:59)
    //final currentDate = DateTime.utc(DateTime.now().year +1, 5, 5, 22, 59, 59);

    final difference = targetDate.difference(currentDate);
    print("INFO! --- Difference currentDate to targetDate in days: ${difference.inDays}");

    if (difference.isNegative) {
      // Stops countdown on targetDate
      _timer.cancel();
      return 'Countdown finished!';
    }
    else {
      // Transform Date to "DD:HH:MM:SS" format for the Countdown String
      int days = difference.inDays;
      int hours = difference.inHours % 24;
      int minutes = difference.inMinutes % 60;
      int seconds = difference.inSeconds % 60;

      return '${days.toString().padLeft(2, '0')}:${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    }

  }

  // Stopps countdown if no longer needed
  void stopCountdown() {
    _timer.cancel();
  }
}