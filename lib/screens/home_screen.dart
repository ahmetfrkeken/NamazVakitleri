import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:namazvakti/widgets/widgets.dart';

class HomeScreen extends ConsumerWidget {
  static HomeScreen builder(BuildContext context, GoRouterState state) =>
      const HomeScreen(title: 'Namaz Vakitleri');
  const HomeScreen({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
}
