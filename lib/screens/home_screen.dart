import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:namazvakti/l10n/locale_keys.g.dart';
import 'package:namazvakti/namaz_vakti_data.dart';
import '../widgets/count_down_timer.dart';
import '../widgets/namaz_vakti_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen(String s, {super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DateTime currentTime = DateTime.now();
  DateTime? eventTime;
  List<NamazVaktiData> data = [];

  @override
  void initState() {
    checkData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var vakitIsimleri = [
      LocaleKeys.imsak.tr(),
      LocaleKeys.sabah.tr(),
      LocaleKeys.ogle.tr(),
      LocaleKeys.ikindi.tr(),
      LocaleKeys.aksam.tr(),
      LocaleKeys.yatsi.tr()
    ];

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
                  currentTime: currentTime,
                  eventTime: eventTime ?? DateTime(0)),
              const SizedBox(height: 40),
              Text(
                  style: const TextStyle(fontSize: 20),
                  DateFormat('d MMMM yyyy', 'tr_TR').format(DateTime.now())),
              Text(
                  style: const TextStyle(fontSize: 20),
                  HijriCalendar.now().toFormat("MMMM dd yyyy")),
              const SizedBox(height: 40),
              Container(
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black, width: 2),
                    color: Colors.red),
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: data.isNotEmpty ? data.first.times.length : 1,
                  itemBuilder: (context, index) {
                    if (data.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Container(
                        width: ((size.width - 32.0) / 6),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                style: const TextStyle(fontSize: 8),
                                vakitIsimleri[index]),
                            Text(data.first.times[index]),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void checkData() {}
}
