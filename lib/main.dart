import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Pusula.dart';
import 'namaz_vakti_data.dart';
import 'package:intl/intl.dart';

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
        title: Text('Namaz Vakitleri'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("Ahmet Faruk EKEN"),
              accountEmail: Text("test@osmanli.com"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://www.islamveihsan.com/wp-content/uploads/2017/04/sirpence2-702x336.jpg'),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const Pusula()));
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
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
            SizedBox(height: 40),
            Expanded(child: _buildPrayerTimes(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildClock(BuildContext context) {
    return Center(
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
        return ListTile(
          title: Text(''),
        );
      },
    );
  }

  Future<void> getVakitler() async {
    NamazVakti namazVakti = await fetchNamazVakti();
    data = namazVakti.times;
    // convertDifferanceDateTimeToString(getDifferenceDateTime());
    setState(() {});
  }

  Future<NamazVakti> fetchNamazVakti() async {
    final queryParam = {
      "country": "Turkey",
      "region": "Ankara",
      "city": "Ankara",
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

  // DateTime? getDifferenceDateTime() {
  //   DateTime now = DateTime.now();
  //   for (var element in data) {
  //     final format = DateFormat("Hm");
  //     DateTime dateTime;
  //     try {
  //       dateTime = format.parse(element.saat);
  //
  //       print(
  //           dateTime); // Bu satır, dönüştürülen DateTime nesnesini konsola yazdırır.
  //       Duration difference = dateTime.difference(now);
  //       if (!difference.isNegative) {
  //         return dateTime;
  //       } else {
  //         return null;
  //       }
  //     } catch (e) {
  //       print("Tarih çözümleme hatası: $e");
  //     }
  //   }
  //   return null;
  // }

  String convertDifferanceDateTimeToString(DateTime? dateTime) {
    if (dateTime != null) {
      return dateTime.hour.toString() +
          dateTime.minute.toString() +
          dateTime.second.toString();
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
