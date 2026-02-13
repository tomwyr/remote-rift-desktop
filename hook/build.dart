import 'dart:io';

import 'package:hooks/hooks.dart';
import 'package:path/path.dart' as path;
import 'package:remote_rift_desktop_updater/remote_rift_desktop_updater.dart';

void main(List<String> args) async {
  await build(args, (input, output) async {
    final paths = resolvePaths(input);
    await buildExecutable(paths.updaterRoot);
    File(paths.builtExecutable).copySync(paths.assetTarget);
  });
}

Future<void> buildExecutable(String workingDirectory) async {
  await Process.run('dart', [
    'build',
    'cli',
    'bin/run_update.dart',
    '-o',
    'build',
  ], workingDirectory: workingDirectory);
}

UpdaterBuildPaths resolvePaths(BuildInput input) {
  final rootPath = path.fromUri(input.packageRoot);
  final updaterRoot = path.join(rootPath, 'packages', 'updater');
  final updaterFileName = DesktopUpdater.executableFileName;
  final builtExecutable = path.join(updaterRoot, 'build', 'bundle', 'bin', updaterFileName);
  final assetTarget = path.join(rootPath, 'assets', updaterFileName);
  return (updaterRoot: updaterRoot, builtExecutable: builtExecutable, assetTarget: assetTarget);
}

typedef UpdaterBuildPaths = ({String updaterRoot, String builtExecutable, String assetTarget});
