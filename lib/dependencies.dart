import 'package:flutter/material.dart';
import 'package:remote_rift_api/remote_rift_api.dart';
import 'package:remote_rift_core/remote_rift_core.dart';

import 'services/api_service_runner.dart';
import 'services/update/file_utils.dart';
import 'services/update/update_runner.dart';
import 'services/update/update_service.dart';
import 'ui/connection/connection_cubit.dart';
import 'ui/service/service_cubit.dart';
import 'ui/update/update_cubit.dart';

class Dependencies {
  static ConnectionCubit connectionCubit(BuildContext context) =>
      ConnectionCubit(connector: RemoteRiftConnector());

  static ServiceCubit serviceCubit(BuildContext context) => ServiceCubit(
    runner: RemoteRiftApiServiceRunner(service: RemoteRiftApiService(), registry: .remoteRift()),
  );

  static UpdateCubit updateCubit(BuildContext context) => UpdateCubit(
    updateService: UpdateService(
      releases: .remoteRift(),
      updateRunner: UpdateRunner.platform(fileUtils: FileUtils()),
    ),
  );
}
