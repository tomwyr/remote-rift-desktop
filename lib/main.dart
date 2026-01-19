import 'package:flutter/material.dart';

import 'api.dart';
import 'ui/app/app.dart';
import 'ui/app/app_tray.dart';
import 'ui/app/app_window.dart';

void main() async {
  runConnectorApi(addressSource: .systemLookup);

  WidgetsFlutterBinding.ensureInitialized();
  await AppWindow.configure();
  await AppTray.configure();

  runApp(const App());
}
