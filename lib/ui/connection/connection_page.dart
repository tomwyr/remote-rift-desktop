import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_connector_core/remote_rift_connector_core.dart';

import '../../dependencies.dart';
import '../../i18n/strings.g.dart';
import '../widgets/layout.dart';
import '../widgets/lifecycle.dart';
import 'connection_cubit.dart';
import 'connection_state.dart';

class ConnectionPage extends StatelessWidget {
  const ConnectionPage({super.key});

  static Widget builder() {
    return BlocProvider(create: Dependencies.connectionCubit, child: ConnectionPage());
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<ConnectionCubit>();

    return Lifecycle(
      onInit: cubit.initialize,
      child: Scaffold(
        body: Padding(
          padding: .symmetric(horizontal: 24, vertical: 12),
          child: switch (cubit.state) {
            Initial() => SizedBox.shrink(),

            Connecting() => BasicLayout(
              title: t.connection.connectingTitle,
              description: t.connection.connectingDescription,
              loading: true,
            ),

            ConnectionError(:var reconnectTriggered) => BasicLayout(
              title: t.connection.errorTitle,
              description: t.connection.errorDescription,
              loading: reconnectTriggered,
              action: .new(label: t.connection.errorRetry, onPressed: cubit.reconnect),
            ),

            ConnectedWithError(:var cause) => BasicLayout(
              title: cause.title,
              description: cause.description,
            ),

            Connected() => BasicLayout(
              title: t.connection.connectedTitle,
              description: t.connection.connectedDescription,
            ),
          },
        ),
      ),
    );
  }
}

extension on RemoteRiftError {
  String get title => switch (this) {
    .unableToConnect => t.gameError.unableToConnectTitle,
    .unknown => t.gameError.unknownTitle,
  };

  String get description => switch (this) {
    .unableToConnect => t.gameError.unableToConnectDescription,
    .unknown => t.gameError.unknownDescription,
  };
}
