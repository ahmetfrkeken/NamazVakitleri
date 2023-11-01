import 'dart:async';
import 'package:flutter/material.dart';
import 'package:namazvakti/l10n/locale_keys.g.dart';
import 'package:namazvakti/services/api_service.dart';
import 'l10n/l10.dart';
import 'pusula.dart';
import 'namaz_vakti_data.dart';
import 'widgets/count_down_timer.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(EasyLocalization(
    supportedLocales: L10n.all,
    path: 'assets/l10n',
    fallbackLocale: L10n.all[0],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DateTime currentTime = DateTime.now();
  DateTime? eventTime;

  List<NamazVaktiData> data = [];

  void initState() {
    getVakitler();
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const UserAccountsDrawerHeader(
              accountName: Text("Ahmet Faruk EKEN"),
              accountEmail: Text("test@osmanli.com"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://www.islamveihsan.com/wp-content/uploads/2017/04/sirpence2-702x336.jpg'),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const Pusula()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CountdownTimer(
                currentTime: currentTime, eventTime: eventTime ?? DateTime(0)),
            const SizedBox(height: 40),
            Text(
                style: const TextStyle(fontSize: 20),
                DateFormat(
                        'd MMMM yyyy',
                        't'
                            'r_TR')
                    .format(DateTime.now())),
            const SizedBox(height: 40),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
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
    );
  }

  Future<void> getVakitler() async {
    final queryParam = {
      "country": "Turkey",
      "region": "Ankara",
      "city": "Ankara",
      "days": "1",
      "timezoneOffset": "180"
    };

    NamazVakti namazVakti = await ApiService().fetchNamazVakti(queryParam);
    data = namazVakti.times;
    setState(() {
      eventTime = getDifferenceDateTime();
    });
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

  String convertDifferanceDateTimeToString(DateTime? dateTime) {
    if (dateTime != null) {
      return "${dateTime.hour}:${dateTime.minute}:${dateTime.second}";
    }
    return "";
  }
}
