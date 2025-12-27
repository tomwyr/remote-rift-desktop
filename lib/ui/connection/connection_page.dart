import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_connector_core/remote_rift_connector_core.dart';

import '../../dependencies.dart';
import '../../i18n/strings.g.dart';
import '../app/app_theme.dart';
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
    final colorScheme = AppThemeExtension.of(context).colorScheme;

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
              icon: .new(data: Icons.wifi_tethering_rounded, color: colorScheme.neutral),
              loading: true,
            ),

            ConnectionError(:var reconnectTriggered) => BasicLayout(
              title: t.connection.errorTitle,
              description: t.connection.errorDescription,
              icon: .new(data: Icons.error_outline_rounded, color: colorScheme.error),
              loading: reconnectTriggered,
              action: .new(label: t.connection.errorRetry, onPressed: cubit.reconnect),
            ),

            ConnectedWithError(:var cause) => BasicLayout(
              title: cause.title,
              description: cause.description,
              icon: .new(
                data: Icons.warning_amber_rounded,
                color: colorScheme.warning,
                offset: Offset(0, -2),
              ),
            ),

            Connected() => BasicLayout(
              title: t.connection.connectedTitle,
              description: t.connection.connectedDescription,
              icon: .new(data: Icons.check_rounded, color: colorScheme.success),
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
