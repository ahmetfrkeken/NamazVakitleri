import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Pusula.dart';
import 'namaz_vakti_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //apikey 1X8EKPiBRDqsvlZbnns2Tp:5QauOiqsbK75MLMZ8n6o71

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  List<NamazVaktiData> data = [];
  Timer? _timer;
  DateTime? _remainingTime;

  @override
  void initState() {
    getVakitler();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            _buildClock(context),
            const SizedBox(height: 40),
            Expanded(child: _buildPrayerTimes(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildClock(BuildContext context) {
    return const Center(
      child: Text(
        '',
        style: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPrayerTimes(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return const ListTile(
          title: Text(''),
        );
      },
    );
  }

  Future<void> getVakitler() async {
    NamazVakti namazVakti = await fetchNamazVakti();
    data = namazVakti.times;
    print(convertDifferanceDateTimeToString(getDifferenceDateTime()));
    setState(() {});
  }

  Future<NamazVakti> fetchNamazVakti() async {
    final queryParam = {
      "country": "Turkey",
      "region": "Ankara",
      "city": "Ankara",
      "day": "1",
      "timezoneOffset": "180"
    };
    var url =
        Uri.https('namaz-vakti.vercel.app', '/api/timesFromPlace', queryParam);
    // var header = {
    //   "Authorization": "apikey 1X8EKPiBRDqsvlZbnns2Tp:5QauOiqsbK75MLMZ8n6o71",
    //   "content-type": "application/json"
    // };
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return NamazVakti.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('failed to load Namaz Vakitleri');
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
          // print(format.parse(format.format(now))); //şimdiki zaman

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

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime!.isAfter(DateTime.now())) {
        timer.cancel();
      } else {
        setState(() {
          _remainingTime = _remainingTime!.subtract(Duration(seconds: 1));
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
