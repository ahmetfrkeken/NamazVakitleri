import 'dart:async';
import 'package:flutter/material.dart';
import 'package:namazvakti/data/models/namaz_vakti_model.dart';
import 'package:namazvakti/widgets/widgets.dart';

class CountdownTimer extends StatefulWidget {
  final List<NamazVaktiData>? data;
  final Map<String, int>? indices;

  const CountdownTimer({super.key, required this.data, required this.indices});

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
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
    if (widget.data != null && widget.indices != null) {
      initTimer();
      return Column(children: [
        const DisplayText(
          text: 'Vaktin Çıkmasına Kalan Süre:', //Sonraki vakit nedir?
          fontWeight: FontWeight.normal,
          fontSize: 18,
        ),
        DisplayText(
          //Sonraki vakta kalan süre
          text: formatDuration(remainingTime),
          fontSize: 40,
        ),
      ]);
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  String formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);
    return "$hours $minutes $seconds";
  }

  void initTimer() {
    // debugPrint(widget.eventTime);
    // debugPrint(widget.currentTime);
    //data[widget.indices["indexElement"]]

    var element = widget.data![widget.indices!["indexElement"]!];
    var time = element.times[widget.indices!['indexTime']!];
    DateTime dateTime = DateTime.parse("${element.date}T$time");

    remainingTime = dateTime.difference(DateTime.now());
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) async {
      setState(() {
        remainingTime = remainingTime - const Duration(seconds: 1);
        if (remainingTime.isNegative) {
          t.cancel();
        }
      });
    });
  }
}
