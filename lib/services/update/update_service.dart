import 'package:package_info_plus/package_info_plus.dart';
import 'package:remote_rift_utils/remote_rift_utils.dart';

import 'github_releases.dart';

class UpdateService {
  UpdateService({required this.releases});

  final GitHubReleases releases;

  Future<Version?> checkUpdateAvailable() async {
    final latest = await _getLatestVersion();
    final current = await _getCurrentVersion();
    if (latest.isGreaterThan(current)) {
      return latest;
    }
    return null;
  }

  Future<void> installUpdate({required Version version}) async {
    //
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

enum UpdateServiceError implements Exception { latestVersionUnavailable, currentVersionUnavailable }
