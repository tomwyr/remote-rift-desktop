import 'package:draft/draft.dart';
import 'package:remote_rift_connector_core/remote_rift_connector_core.dart';

part 'connection_state.draft.dart';

sealed class ConnectionState {}

class Initial extends ConnectionState {}

class Connecting extends ConnectionState {}

class Connected extends ConnectionState {}

class ConnectedWithError extends ConnectionState {
  ConnectedWithError({required this.cause});

  final RemoteRiftError cause;
}

@draft
class ConnectionError extends ConnectionState {
  ConnectionError({this.reconnectTriggered = false});

  final bool reconnectTriggered;
}
