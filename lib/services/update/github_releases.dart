import 'dart:convert';

import 'package:http/http.dart';

class GitHubReleases {
  GitHubReleases({required this.repoName, required this.userName});

  GitHubReleases.remoteRift() : repoName = 'remote-rift-desktop', userName = 'tomwyr';

  final String repoName;
  final String userName;

  late final _baseUrl = 'https://api.github.com/repos/$userName/$repoName';

  Future<String?> getLatestReleaseTag() async {
    final url = '$_baseUrl/releases/latest';
    final response = await get(Uri.parse(url));

    if (response.statusCode != 200) {
      return null;
    }
    final json = jsonDecode(response.body);
    return json['tag_name'];
  }
}
