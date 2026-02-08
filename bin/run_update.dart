import 'package:remote_rift_desktop/services/update/file_utils.dart';
import 'package:remote_rift_desktop/services/update/update_runner.dart';

void main(List<String> args) async {
  final archivePath = readArg(args, 0, 'archive path');
  final runner = UpdateRunner.platform(fileUtils: FileUtils());
  await runner.run(archivePath: archivePath);
}

String readArg(List<String> args, int index, String argDebugLabel) {
  final path = args.elementAtOrNull(index);
  if (path == null) {
    throw Exception('Input argument #$index ($argDebugLabel) missing');
  }
  return path;
}
