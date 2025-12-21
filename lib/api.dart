import 'package:remote_rift_connector_api/remote_rift_connector_api.dart';

Future<void> runConnectorApi(ConnectorApiConfig config) async {
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

  await RemoteRiftApi().run(host: host, port: port);
}

enum ConnectorApiConfig { fromEnv }
