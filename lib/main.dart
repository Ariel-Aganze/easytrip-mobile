import 'package:flutter/material.dart';

import 'package:easytrip/app.dart';
import 'package:easytrip/core/di/injector.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const EasyTripApp());
}