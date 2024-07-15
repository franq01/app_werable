import 'package:flutter/foundation.dart';
import 'dart:async';

class TimeProvider with ChangeNotifier {
  String _formattedTime = "00:00:00";
  Timer? _timer;
  int _seconds = 0;

  String get formattedTime => _formattedTime;

  void _updateTime() {
    final duration = Duration(seconds: _seconds);
    _formattedTime = "${duration.inHours.toString().padLeft(2, '0')}:"
        "${(duration.inMinutes % 60).toString().padLeft(2, '0')}:"
        "${(duration.inSeconds % 60).toString().padLeft(2, '0')}";
    notifyListeners();
  }

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _seconds++;
      _updateTime();
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  void resetTimer() {
    stopTimer();
    _seconds = 0;
    _updateTime();
  }
}
