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
  int? indexOfNextPrayerTime;

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
              const CountdownTimer(),
              const SizedBox(height: 40),
              DisplayText(
                text: DateFormat('d MMMM yyyy', 'tr_TR').format(DateTime.now()),
                fontSize: 20,
              ),
              DisplayText(
                text: HijriCalendar.now().toFormat('MMMM dd yyyy'),
                fontSize: 20,
              ),
              const SizedBox(height: 40)
              //DisplayPrayerTimesList(
              //  data: data,
              //  indices: indices,
              //)
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
    //indexOfNextPrayerTime = getNextPrayerTime();
  }
}
