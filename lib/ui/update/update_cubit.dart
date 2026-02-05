import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/update/update_service.dart';
import 'update_state.dart';

class UpdateCubit extends Cubit<UpdateState> {
  UpdateCubit({required this.updateService}) : super(Initial());

  final UpdateService updateService;

  void initialize() async {
    final updateAvailable = await updateService.isUpdateAvailable();
    if (updateAvailable) {
      emit(UpdateAvailable());
    } else {
      emit(UpToDate());
    }
  }

  void installUpdate() async {
    try {
      emit(UpdateInProgress());
      await updateService.installUpdate();
    } catch (_) {
      emit(UpdateError());
    }
  }

  void recoverOnDismiss() {
    if (state case UpdateError()) {
      emit(UpdateAvailable());
    }
  }
}
