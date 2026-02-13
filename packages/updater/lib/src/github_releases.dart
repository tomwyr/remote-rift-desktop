import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:path/path.dart';

import 'platform.dart';

typedef GitHubNameResolver = String Function(String releaseTag);

class GitHubReleases {
  GitHubReleases({
    required this.repoName,
    required this.userName,
    required this.resolveArtifactName,
  });

  final String repoName;
  final String userName;
  final GitHubNameResolver resolveArtifactName;

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
    return switch (targetPlatform) {
      .windows => r'C:\Users\tomwyr\AppData\Local\Temp\RemoteRift-0.6.4-windows.zip',
      .macos =>
        '/Users/tomwyr/Library/Containers/com.tomwyr.remoterift.desktop/Data/tmp/RemoteRift-0.6.4-macos.zip',
    };
    final artifactName = resolveArtifactName(releaseTag);
    final url = '$_baseUrl/releases/download/$releaseTag/$artifactName';

    final response = await get(Uri.parse(url));
    if (response.statusCode != 200) {
      return null;
    }

    final downloadPath = join(Directory.systemTemp.path, artifactName);
    await File(downloadPath).writeAsBytes(response.bodyBytes);
    return downloadPath;
  }
}
