import 'package:flutter/material.dart';
import 'package:remote_rift_core/remote_rift_core.dart';

import 'ui/connection/connection_cubit.dart';

class Dependencies {
  static ConnectionCubit connectionCubit(BuildContext context) =>
      ConnectionCubit(connector: RemoteRiftConnector());
}
