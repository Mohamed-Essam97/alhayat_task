import 'package:flutter/material.dart';

import 'app/app.dart';
import 'app/providers/app_providers.dart';
import 'core/di/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureDependencies();

  runApp(const AppProviders(child: MyApp()));
}
