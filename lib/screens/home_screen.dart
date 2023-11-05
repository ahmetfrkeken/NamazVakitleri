import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:namazvakti/l10n/locale_keys.g.dart';
import 'package:namazvakti/data/models/namaz_vakti_model.dart';
import 'package:namazvakti/widgets/widgets.dart';

import '../services/api_service.dart';
import '../services/shared_preferences_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

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
              CountdownTimer(eventTime: eventTime),
              const SizedBox(height: 40),
              DisplayText(
                text: DateFormat('d MMMM yyyy', 'tr_TR').format(DateTime.now()),
                fontSize: 20,
              ),
              DisplayText(
                text: HijriCalendar.now().toFormat("MMMM dd yyyy"),
                fontSize: 20,
              ),
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
  

  Future<void> _getVakitlerFromApi() async {
    final queryParam = {"country": "Turkey", "region": "Ankara", "city": "Ankara", "days": "7", "timezoneOffset": "180"};

    NamazVakti namazVakti = await ApiService().fetchNamazVakti(queryParam);
    print(jsonEncode(namazVakti));
    print(jsonEncode(namazVakti).toString());
    _saveNamazVakitleri(namazVakti);
    data = namazVakti.times;
    setState(() {
      eventTime = getDifferenceDateTime();
    });
  }

  _saveNamazVakitleri(NamazVakti namazVakti) async {
    final SharedPreferencesService prefsService = SharedPreferencesService();
    prefsService.saveString('NamazVakti', jsonEncode(namazVakti.toJson()).toString());
  }

  Future<NamazVakti?> _getNamazVakitleri() async {
    final SharedPreferencesService prefsService = SharedPreferencesService();
    final jsonString = await prefsService.getString('NamazVakti');
    if (jsonString == null) {
      return null;
    }

    try {
      final jsonMap = jsonDecode(jsonString);
      return NamazVakti.fromJson(jsonMap);
    } catch (e) {
      print('Hata: $e');
      return null;
    }
  }

  void checkData() async {
    final namazVakitleri = await _getNamazVakitleri();

    if (namazVakitleri != null) {
      data = (namazVakitleri).times;
    } else {
      _getVakitlerFromApi();
    }
  }

  DateTime? getDifferenceDateTime() {
    DateTime now = DateTime.now();
    for (var element in data) {
      for (var time in element.times) {
        // final DateFormat format = DateFormat("HH:mm");
        DateTime dateTime;
        try {
          dateTime = DateTime.parse("${element.date}T$time");

          // print(dateTime); //servisten gelen zaman
          // print(now); //şimdiki zaman

          Duration difference = dateTime.difference(now);

          // print(difference.isNegative);
          // print(difference.inMinutes);

          if (!difference.isNegative) {
            return dateTime;
          }
        } catch (e) {
          print("Tarih çözümleme hatası: $e");
        }
      }
    }
    return null;
  }
}
