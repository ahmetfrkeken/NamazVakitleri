import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:namazvakti/config/config.dart';
import 'package:namazvakti/screens/screens.dart';

class NamazVaktiApp extends StatelessWidget {
  const NamazVaktiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      home: HomeScreen(title: 'Namaz Vakitleri'),
    );
  }
}
