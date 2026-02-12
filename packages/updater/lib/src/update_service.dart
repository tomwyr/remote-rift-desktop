import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:remote_rift_desktop_updater/remote_rift_desktop_updater.dart';
import 'package:remote_rift_utils/remote_rift_utils.dart';

import 'github_releases.dart';

class UpdateService {
  UpdateService({required this.releases, required this.updateRunner, required this.fileUtils});

  final GitHubReleases releases;
  final UpdateRunner updateRunner;
  final FileUtils fileUtils;

  Future<Version?> checkUpdateAvailable() async {
    return Version.parse('0.6.4');
    final latest = await _getLatestVersion();
    final current = await _getCurrentVersion();
    if (latest.isGreaterThan(current)) {
      return latest;
    }
    return null;
  }

  Future<void> installUpdate({required Version version}) async {
    final downloadPath = await releases.downloadRelease(releaseTag: version.stringValue);
    if (downloadPath == null) {
      throw UpdateServiceError.updateDownloadFailed;
    }

    try {
      final applicationPath = fileUtils.getApplicationDirectory();
      await updateRunner.startProcess(archivePath: downloadPath, applicationPath: applicationPath);
      exit(0);
    } catch (_) {
      UpdateServiceError.installerStartupFailed;
    }
  }

  Future<Version> _getLatestVersion() async {
    try {
      final latestTag = await releases.getLatestReleaseTag();
      if (latestTag == null) {
        throw UpdateServiceError.latestVersionUnavailable;
      }
      return .parse(latestTag);
    } catch (_) {
      throw UpdateServiceError.latestVersionUnavailable;
    }
  }

  Future<Version> _getCurrentVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      return .parse(info.version);
    } catch (_) {
      throw UpdateServiceError.currentVersionUnavailable;
    }
  }
}

enum UpdateServiceError implements Exception {
  latestVersionUnavailable,
  currentVersionUnavailable,
  updateDownloadFailed,
  installerStartupFailed,
}
