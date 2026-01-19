import 'package:remote_rift_api/remote_rift_api.dart';
import 'package:remote_rift_ui/remote_rift_ui.dart';

import 'api_address.dart';
import 'app_manager.dart';

Future<void> runConnectorApi({required ConnectorApiAddressSource addressSource}) async {
  final (:host, :port) = await resolveApiAddress(addressSource);

  final service = RemoteRiftApiService();
  await service.run(host: host, port: port);

  final registry = ServiceRegistry.remoteRift();
  final broadcast = await registry.broadcast(port: port);

  appManager.onExit(broadcast.dispose);
}
