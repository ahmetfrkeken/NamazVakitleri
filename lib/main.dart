import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namazvakti/app/namaz_vakti_app.dart';
import 'package:namazvakti/services/shared_preferences_service.dart';
import 'l10n/l10.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  SharedPreferencesService prefsService = SharedPreferencesService();
  await prefsService.init();

  runApp(
      ProviderScope(
        child: EasyLocalization(
          supportedLocales: L10n.all,
          path: 'assets/l10n',
          fallbackLocale: L10n.all[0],
          child: const NamazVaktiApp(),
        ),
      )
  );
}