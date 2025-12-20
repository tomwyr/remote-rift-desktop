import 'package:flutter/material.dart';

import '../../i18n/strings.g.dart';
import '../connection/connection_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: t.app.title, home: ConnectionPage.builder());
  }
}
