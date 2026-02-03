import 'package:flutter/material.dart';
import 'package:remote_rift_api/remote_rift_api.dart';
import 'package:remote_rift_core/remote_rift_core.dart';

import 'services/api_service_runner.dart';
import 'ui/connection/connection_cubit.dart';
import 'ui/service/service_cubit.dart';

class Dependencies {
  static ConnectionCubit connectionCubit(BuildContext context) =>
      ConnectionCubit(connector: RemoteRiftConnector());

  static ServiceCubit serviceCubit(BuildContext context) => ServiceCubit(
    runner: RemoteRiftApiServiceRunner(service: RemoteRiftApiService(), registry: .remoteRift()),
  );
}
