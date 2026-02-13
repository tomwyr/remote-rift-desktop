import 'package:flutter/material.dart';
import 'package:remote_rift_api/remote_rift_api.dart';
import 'package:remote_rift_core/remote_rift_core.dart';
import 'package:remote_rift_desktop_updater/remote_rift_desktop_updater.dart';

import 'common/platform.dart';
import 'services/api_service_runner.dart';
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
      releases: GitHubReleases(
        repoName: 'remote-rift-desktop',
        userName: 'tomwyr',
        resolveArtifactName: (releaseTag) {
          final platform = switch (targetPlatform) {
            .windows => 'windows',
            .macos => 'macos',
          };
          return 'RemoteRift-$releaseTag-$platform.zip';
        },
      ),
      updateRunner: UpdateRunner.platform(
        applicationLabel: 'remote-rift',
        macosBundleName: 'Remote Rift.app',
        windowsExecutableName: 'RemoteRift.exe',
      ),
    ),
  );
}
