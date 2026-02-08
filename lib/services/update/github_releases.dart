import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:path/path.dart';

import '../../common/platform.dart';

class GitHubReleases {
  GitHubReleases({required this.repoName, required this.userName});

  GitHubReleases.remoteRift() : repoName = 'remote-rift-desktop', userName = 'tomwyr';

  final String repoName;
  final String userName;

  late final _baseUrl = 'https://github.com/$userName/$repoName';
  late final _apiBaseUrl = 'https://api.github.com/repos/$userName/$repoName';

  Future<String?> getLatestReleaseTag() async {
    final url = '$_apiBaseUrl/releases/latest';
    final response = await get(Uri.parse(url));

    if (response.statusCode != 200) {
      return null;
    }
    final json = jsonDecode(response.body);
    return json['tag_name'];
  }

  Future<String?> downloadRelease({required String releaseTag}) async {
    final platform = _getPlatformName();
    final fileName = 'RemoteRift-$releaseTag-$platform.zip';
    final url = '$_baseUrl/releases/download/$releaseTag/$fileName';

    final response = await get(Uri.parse(url));
    if (response.statusCode != 200) {
      return null;
    }

    final downloadPath = join(Directory.systemTemp.path, fileName);
    await File(downloadPath).writeAsBytes(response.bodyBytes);
    return downloadPath;
  }

  String _getPlatformName() {
    return switch (targetPlatform) {
      .windows => 'windows',
      .macos => 'macos',
    };
  }
}
