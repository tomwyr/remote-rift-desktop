import 'dart:io';

class Assets {
  static const logo = 'assets/logo.png';
  static String get iconTray =>
      Platform.isWindows ? 'assets/icon_tray.ico' : 'assets/icon_tray.png';
}
