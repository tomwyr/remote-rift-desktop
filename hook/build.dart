import 'dart:io';

import 'package:hooks/hooks.dart';
import 'package:path/path.dart';

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
  final rootPath = input.packageRoot.path;
  final updaterRoot = join(rootPath, 'packages', 'updater');
  final builtExecutable = join(updaterRoot, 'build', 'bundle', 'bin', 'run_update');
  final assetTarget = join(rootPath, 'assets', 'run_update');
  return (updaterRoot: updaterRoot, builtExecutable: builtExecutable, assetTarget: assetTarget);
}

typedef UpdaterBuildPaths = ({String updaterRoot, String builtExecutable, String assetTarget});
