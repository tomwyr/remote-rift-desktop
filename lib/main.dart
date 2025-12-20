import 'package:flutter/material.dart';

import 'app.dart';
import 'app_window.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppWindow.configure();
  runApp(const App());
}
