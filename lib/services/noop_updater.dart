import 'package:application_updater/application_updater.dart';
import 'package:remote_rift_utils/remote_rift_utils.dart';

class NoopUpdater implements ApplicationUpdater {
  @override
  Future<Version?> checkUpdateAvailable() async => null;

  @override
  Future<void> installUpdate({required Version version}) async {}
}
