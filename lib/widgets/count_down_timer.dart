import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namazvakti/data/models/namaz_vakti_model.dart';
import 'package:namazvakti/providers/namaz_vakti_provider.dart';
import 'package:namazvakti/widgets/widgets.dart';

class CountdownTimer extends ConsumerStatefulWidget {
  const CountdownTimer({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CountDownTimerState();
}

class _CountDownTimerState extends ConsumerState<CountdownTimer> {
  Timer? _timer;
  NamazVakti? namazVakti;
  bool _timerInitialized = false;

  @override
  Widget build(BuildContext context) {
    final namazVaktiData = ref.watch(namazVaktiProvider);
    final timeUntilNextPrayerTime = ref.watch(timeUntilNextPrayerTimeProvider);

    if (!_timerInitialized) {
      namazVaktiData.whenData((data) {
        namazVakti = data;
        if (!_timerInitialized && data != null) {
          initTimer();
          _timerInitialized = true; // Timer başlatıldı olarak işaretle
        }
      });
    }

    return namazVaktiData.when(
        loading: () => const CircularProgressIndicator(),
        error: (error, stackTrace) => Text('Hata: $error'),
        data: (data) {
          return Column(children: [
            const DisplayText(
              text: 'Vaktin Çıkmasına Kalan Süre:', //Sonraki vakit nedir?
              fontWeight: FontWeight.normal,
              fontSize: 18,
            ),
            DisplayText(
              //Sonraki vakta kalan süre
              text: formatDuration(timeUntilNextPrayerTime),
              //text: "Ahmet Baba",
              fontSize: 40,
            ),
          ]);
        });
  }

  String formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);
    return "$hours $minutes $seconds";
  }

  void initTimer() {
    final nextPrayerTime = getNextPrayerTime(namazVakti);
    ref.read(timeUntilNextPrayerTimeProvider.notifier).state =
        (nextPrayerTime ?? DateTime.now()).difference(DateTime.now());

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) async {
      ref.read(timeUntilNextPrayerTimeProvider.notifier).state =
          ref.read(timeUntilNextPrayerTimeProvider.notifier).state -
              const Duration(seconds: 1);
      if (ref.read(timeUntilNextPrayerTimeProvider.notifier).state.isNegative) {
        t.cancel();
      }
    });
  }

  DateTime? getNextPrayerTime(NamazVakti? namazVaktiData) {
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
              return dateTime; // List olarak döndürüyoruz
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
