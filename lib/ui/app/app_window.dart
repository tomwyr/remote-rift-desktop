import 'dart:io';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class AppWindow {
  static Future<void> configure() async {
    await windowManager.ensureInitialized();
    await Future.wait([
      windowManager.setAlignment(_resolveAlignment()),
      windowManager.setTitleBarStyle(Platform.isWindows ? .normal : .hidden),
      windowManager.setSize(Size(300, 400)),
      windowManager.setResizable(false),
      windowManager.setPreventClose(true),
    ]);
    windowManager.addListener(AppWindowListener());
    windowManager.show();
  }

  static Alignment _resolveAlignment() {
    if (Platform.isWindows) {
      return .bottomRight;
    } else if (Platform.isMacOS) {
      return .topRight;
    } else {
      throw UnsupportedError(
        'Unsupported platform. Supported operating systems are Windows and macOS.',
      );
    }
  }
}

class AppWindowListener with WindowListener {
  @override
  void onWindowClose() async {
    await windowManager.hide();
  }
}
