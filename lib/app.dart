import 'package:flutter/material.dart';

import 'assets.dart';
import 'l10n.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: t.app.title,
      home: Scaffold(body: Center(child: Image.asset(Assets.logo))),
    );
  }
}
