import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:namazvakti/data/models/namaz_vakti_model.dart';
import 'package:namazvakti/services/shared_preferences_service.dart';
import 'package:namazvakti/widgets/display_prayer_times_list.dart';
import 'package:namazvakti/widgets/widgets.dart';

import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  static HomeScreen builder(BuildContext context, GoRouterState state) =>
      const HomeScreen(title: 'Namaz Vakitleri');
  const HomeScreen({super.key, required this.title});
  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DateTime currentTime = DateTime.now();
  List<NamazVaktiData>? data;
  Map<String, int>? indices;

  @override
  void initState() {
    super.initState();
    checkData().then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Namaz Vakitleri'),
      ),
      drawer: const NamazVaktiDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/main_bckg_green_mosque.png'),
                fit: BoxFit.cover),
          ),
          child: Column(
            children: [
              CountdownTimer(
                data: data,
                indices: indices,
              ),
              const SizedBox(height: 40),
              DisplayText(
                text: DateFormat('d MMMM yyyy', 'tr_TR').format(DateTime.now()),
                fontSize: 20,
              ),
              DisplayText(
                text: HijriCalendar.now().toFormat('MMMM dd yyyy'),
                fontSize: 20,
              ),
              const SizedBox(height: 40),
              DisplayPrayerTimesList(
                data: data,
                indices: indices,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> checkData() async {
    final namazVakitleri = await SharedPreferencesService().getNamazVakitleri();

    if (namazVakitleri != null) {
      data = (namazVakitleri).times;
    } else {
      await _getVakitlerFromApi();
    }
  }

  Future<void> _getVakitlerFromApi() async {
    final queryParam = {
      'country': 'Turkey',
      'region': 'Ankara',
      'city': 'Ankara',
      'days': '7',
      'timezoneOffset': '180'
    };

    NamazVakti namazVakti = await ApiService().fetchNamazVakti(queryParam);
    // print(jsonEncode(namazVakti));
    // print(jsonEncode(namazVakti).toString());
    SharedPreferencesService().saveNamazVakitleri(namazVakti);
    data = namazVakti.times;
    indices = getNextPrayerTime();
  }

  Map<String, int>? getNextPrayerTime() {
    if (data != null) {
      Map<String, int> result = <String, int>{};
      DateTime now = DateTime.now();
      for (int indexElement = 0; indexElement < data!.length; indexElement++) {
        var element = data![indexElement];
        for (int indexTime = 0; indexTime < element.times.length; indexTime++) {
          var time = element.times[indexTime];
          try {
            // debugPrint(dateTime); //servisten gelen zaman
            // debugPrint(now); //şimdiki zaman

            DateTime dateTime = DateTime.parse('${element.date}T$time');
            Duration difference = dateTime.difference(now);

            // debugPrint(difference.isNegative);
            // debugPrint(difference.inMinutes);

            if (!difference.isNegative) {
              result['indexElement'] = indexElement;
              result['indexTime'] = indexTime;
              return result; // List olarak döndürüyoruz
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
