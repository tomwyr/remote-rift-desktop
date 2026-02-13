import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_desktop_updater/remote_rift_desktop_updater.dart';
import 'package:remote_rift_utils/remote_rift_utils.dart';

import 'update_state.dart';

class UpdateCubit extends Cubit<UpdateState> {
  UpdateCubit({required this.updater}) : super(Initial());

  final ApplicationUpdater updater;

  void initialize() async {
    _assertInitializeState();
    final updatableVersion = await updater.checkUpdateAvailable();
    if (updatableVersion != null) {
      emit(UpdateAvailable(version: updatableVersion));
    } else {
      emit(UpToDate());
    }
  }

  void installUpdate() async {
    final version = _assertInstallUpdateState();
    try {
      emit(UpdateInProgress());
      await updater.installUpdate(version: version);
    } catch (_) {
      emit(UpdateError(version: version));
    }
  }

  void recoverOnDismiss() {
    if (state case UpdateError(:var version)) {
      emit(UpdateAvailable(version: version));
    }
  }
}

extension UpdateCubitAssertions on UpdateCubit {
  void _assertInitializeState() {
    if (state is! Initial) {
      throw StateError('Tried to initialize while not in initial state (was ${state.runtimeType})');
    }
  }

  Version _assertInstallUpdateState() {
    return switch (state) {
      UpdateAvailable(:var version) || UpdateError(:var version) => version,
      _ => throw StateError(
        'Tried to install update while not in updatable state (was ${state.runtimeType})',
      ),
    };
  }
}
