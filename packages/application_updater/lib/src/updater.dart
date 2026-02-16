import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:remote_rift_utils/remote_rift_utils.dart';

import 'github_releases.dart';
import 'update_runner.dart';

abstract interface class ApplicationUpdater {
  Future<void> installUpdate({required Version version});
  Future<Version?> checkUpdateAvailable();
}

class DesktopUpdater implements ApplicationUpdater {
  DesktopUpdater({required this.releases, required this.updateRunner});

  final GitHubReleases releases;
  final UpdateRunner updateRunner;

  @override
  Future<Version?> checkUpdateAvailable() async {
    final latest = await _getLatestVersion();
    final current = await _getCurrentVersion();
    if (latest.isGreaterThan(current)) {
      return latest;
    }
    return null;
  }

  @override
  Future<void> installUpdate({required Version version}) async {
    final downloadPath = await releases.downloadRelease(releaseTag: version.stringValue);
    if (downloadPath == null) {
      throw ApplicationUpdaterError.updateDownloadFailed;
    }

    try {
      await updateRunner.startProcess(archivePath: downloadPath);
      exit(0);
    } catch (_) {
      throw ApplicationUpdaterError.installerStartupFailed;
    }
  }

  Future<Version> _getLatestVersion() async {
    try {
      final latestTag = await releases.getLatestReleaseTag();
      if (latestTag == null) {
        throw ApplicationUpdaterError.latestVersionUnavailable;
      }
      return .parse(latestTag);
    } catch (_) {
      throw ApplicationUpdaterError.latestVersionUnavailable;
    }
  }

  Future<Version> _getCurrentVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      return .parse(info.version);
    } catch (_) {
      throw ApplicationUpdaterError.currentVersionUnavailable;
    }
  }
}

enum ApplicationUpdaterError implements Exception {
  latestVersionUnavailable,
  currentVersionUnavailable,
  updateDownloadFailed,
  installerStartupFailed,
}
