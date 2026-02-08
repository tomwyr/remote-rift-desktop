import 'dart:io';

import 'package:path/path.dart' as path;

import '../../common/platform.dart';
import 'file_utils.dart';

abstract class UpdateRunner implements PlatformUpdateRunner {
  UpdateRunner({required this.fileUtils});

  factory UpdateRunner.platform({required FileUtils fileUtils}) {
    return switch (targetPlatform) {
      .windows => WindowsUpdateRunner(fileUtils: fileUtils),
      .macos => MacosUpdateRunner(fileUtils: fileUtils),
    };
  }

  final FileUtils fileUtils;

  Future<void> startProcess({required String archivePath}) async {
    final updateDirPath = Directory.systemTemp.path;
    final updaterPath = await _copyUpdater(updateDirPath);
    await Process.start(updaterPath, [archivePath], workingDirectory: updateDirPath);
  }

  Future<void> run({required String archivePath}) async {
    // Wait to ensure the app has fully quit before replacing
    await Future.delayed(Duration(seconds: 1));

    final unzippedPath = await fileUtils.unzipFile(archivePath);
    final appDirPath = await fileUtils.getApplicationDirectory();
    final paths = getUpdatePaths(unzippedPath, appDirPath);

    await fileUtils.replaceWithBackup(
      sourcePath: paths.source,
      targetPath: paths.target,
      backupPath: paths.backup,
      recursive: true,
    );

    await runAppExecutable(paths.executable);
  }

  Future<String> _copyUpdater(String targetDirPath) async {
    final appDirPath = await fileUtils.getApplicationDirectory();
    final updaterPath = path.join(appDirPath, updaterFileName);

    final updater = File(updaterPath);
    if (!await updater.exists()) {
      throw Exception('Updater executable not found at path: $updaterPath');
    }

    final updateTempPath = path.join(targetDirPath, 'remote_rift_$updaterFileName');
    await updater.copy(updateTempPath);
    return updateTempPath;
  }
}

abstract interface class PlatformUpdateRunner {
  String get updaterFileName;
  UpdateRunnerPaths getUpdatePaths(String sourcePath, String targetPath);
  Future<void> runAppExecutable(String executablePath);
}

class WindowsUpdateRunner extends UpdateRunner {
  WindowsUpdateRunner({required super.fileUtils});

  @override
  String get updaterFileName => 'run_update.exe';

  @override
  UpdateRunnerPaths getUpdatePaths(String sourcePath, String targetPath) {
    return .new(
      source: sourcePath,
      target: targetPath,
      backup: '$targetPath.bak',
      executable: path.join(targetPath, 'RemoteRift.exe'),
    );
  }

  @override
  Future<void> runAppExecutable(String executablePath) async {
    await Process.start(executablePath, [], workingDirectory: Directory.systemTemp.path);
  }
}

class MacosUpdateRunner extends UpdateRunner {
  MacosUpdateRunner({required super.fileUtils});

  @override
  String get updaterFileName => 'run_update';

  @override
  UpdateRunnerPaths getUpdatePaths(String sourcePath, String targetPath) {
    return .new(
      source: '$sourcePath/Remote Rift.app',
      target: targetPath,
      backup: '$targetPath.bak',
      executable: targetPath,
    );
  }

  @override
  Future<void> runAppExecutable(String executablePath) async {
    await Process.start('open', [executablePath], mode: .detached);
  }
}

class UpdateRunnerPaths {
  UpdateRunnerPaths({
    required this.source,
    required this.target,
    required this.backup,
    required this.executable,
  });

  final String source;
  final String target;
  final String backup;
  final String executable;
}
