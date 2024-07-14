import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:namazvakti/config/routes/routes.dart';
import 'package:namazvakti/screens/compass_screen.dart';
import 'package:namazvakti/screens/screens.dart';

final navigationKey = GlobalKey<NavigatorState>();

final appRoutes = [
  GoRoute(
    path: RouteLocation.home,
    parentNavigatorKey: navigationKey,
    builder: HomeScreen.builder,
  ),
  /*
  GoRoute(
    path: RouteLocation.compass,
    parentNavigatorKey: navigationKey,
    builder: CompassScreen.builder,
  ),
  */
];
