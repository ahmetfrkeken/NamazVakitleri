import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namazvakti/data/models/namaz_vakti_model.dart';
import 'package:namazvakti/providers/namaz_vakti_provider.dart';
import 'package:namazvakti/widgets/widgets.dart';

class CountdownTimer extends ConsumerWidget {
  const CountdownTimer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final namazVaktiData = ref.watch(namazVaktiDataProvider);
    initTimer(namazVaktiData);

    return const Column(children: [
      DisplayText(
        text: 'Vaktin Çıkmasına Kalan Süre:', //Sonraki vakit nedir?
        fontWeight: FontWeight.normal,
        fontSize: 18,
      ),
      DisplayText(
        //Sonraki vakta kalan süre
        //text: formatDuration(remainingTime),
        text: "Ahmet Baba",
        fontSize: 40,
      ),
    ]);
  }

  String formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);
    return "$hours $minutes $seconds";
  }

  void initTimer(NamazVakti? namazVaktiData) {
    final nextPrayerIndex = getNextPrayerTime(namazVaktiData);

    // debugPrint(widget.eventTime);
    // debugPrint(widget.currentTime);
    //data[widget.indices["indexElement"]]

    // DateTime dateTime = DateTime.parse("${widget.data.date}T$time");

    // remainingTime = dateTime.difference(DateTime.now());
    // timer = Timer.periodic(const Duration(seconds: 1), (Timer t) async {
    //   setState(() {
    //     remainingTime = remainingTime - const Duration(seconds: 1);
    //     if (remainingTime.isNegative) {
    //       t.cancel();
    //     }
    //   });
    // });
  }

  int? getNextPrayerTime(NamazVakti? namazVaktiData) {
    if (namazVaktiData != null && namazVaktiData.times.isNotEmpty) {
      DateTime now = DateTime.now();
      for (var element in namazVaktiData.times) {
        for (int indexOfNextPrayerTime = 0;
            indexOfNextPrayerTime < element.times.length;
            indexOfNextPrayerTime++) {
          var time = element.times[indexOfNextPrayerTime];
          try {
            // debugPrint(dateTime); //servisten gelen zaman
            // debugPrint(now); //şimdiki zaman

            DateTime dateTime = DateTime.parse('${element.date}T$time');
            Duration difference = dateTime.difference(now);

            // debugPrint(difference.isNegative);
            // debugPrint(difference.inMinutes);

            if (!difference.isNegative) {
              return indexOfNextPrayerTime; // List olarak döndürüyoruz
            }
          } catch (e) {
            debugPrint('Tarih çözümleme hatası: $e');
          }
        }
      }
      return null;
    } else {
      return null;
    }
  }
}