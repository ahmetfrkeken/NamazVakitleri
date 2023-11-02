import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  final DateTime currentTime;
  final DateTime eventTime;

  CountdownTimer({required this.currentTime, required this.eventTime});

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Duration remainingTime;
  late Timer timer;

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initTimer();
    return Text(
      formatDuration(remainingTime),
      style: TextStyle(fontSize: 48),
    );
  }

  String formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);
    return "${hours}h ${minutes}m ${seconds}s";
  }

  void initTimer() {
    // print(widget.eventTime);
    // print(widget.currentTime);
    remainingTime = widget.eventTime.difference(DateTime.now());
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        remainingTime = remainingTime - const Duration(seconds: 1);
        if (remainingTime.inSeconds <= 0) {
          timer.cancel();
        }
      });
    });
  }
}