import 'package:remote_rift_connector_api/remote_rift_connector_api.dart';

import 'app_manager.dart';

Future<void> runConnectorApi(ConnectorApiConfig config) async {
  final (:host, :port) = switch (config) {
    .fromEnv => _parseEnvConfig(),
  };
  final api = RemoteRiftApi();
  await api.run(host: host, port: port);
  final broadcast = await api.register(port: port);
  appManager.onExit(broadcast.dispose);
}

ConnectorApiAddress _parseEnvConfig() {
  const hostKey = 'API_HOST';
  const host = String.fromEnvironment(hostKey);
  if (host.isEmpty) {
    throw StateError('$hostKey must be provided');
  }

  const portKey = 'API_PORT';
  const portStr = String.fromEnvironment(portKey);
  if (portStr.isEmpty) {
    throw StateError('$portKey must be provided');
  }
  final port = int.tryParse(portStr);
  if (port == null) {
    throw StateError('Invalid $portKey: "$portStr"');
  }

  return (host: host, port: port);
}

typedef ConnectorApiAddress = ({String host, int port});

enum ConnectorApiConfig { fromEnv }
