import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namazvakti/data/models/namaz_vakti_model.dart';
import 'package:namazvakti/services/api_service.dart';
import 'package:namazvakti/services/shared_preferences_service.dart';

final timeUntilNextPrayerTimeProvider = StateProvider<Duration>((ref) => const Duration());

final namazVaktiProvider = FutureProvider<NamazVakti?>((ref) async {
  final namazVakitleri = await SharedPreferencesService().getNamazVakitleri();

  if (namazVakitleri != null) {
    return namazVakitleri;
  } else {
    return await _getVakitlerFromApi();
  }
});

Future<NamazVakti> _getVakitlerFromApi() async {
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
  return namazVakti;
  //indexOfNextPrayerTime = getNextPrayerTime();
}