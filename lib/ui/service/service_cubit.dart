import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_api/remote_rift_api.dart';

import '../../services/service_runner.dart';
import 'service_state.dart';

class ServiceCubit extends Cubit<ServiceState> {
  ServiceCubit({required this.runner}) : super(Initial());

  final RemoteRiftServiceRunner runner;

  void initialize() async {
    if (state is! Initial) {
      throw StateError('Tried to initialize while not in initial state (was ${state.runtimeType})');
    }

    emit(Starting());
    await _startService();
  }

  void restart() async {
    final startupError = switch (state) {
      StartupError state => state,
      _ => throw StateError('Tried to restart while not in error state (was ${state.runtimeType})'),
    };

    emit(startupError.produce((draft) => draft.reconnectTriggered = true));
    await _startService();
  }

  Future<void> _startService() async {
    try {
      await runner.run();
      emit(Started());
    } catch (error) {
      emit(StartupError(cause: _resolveErrorCause(error)));
    }
  }

  ServiceErrorCause _resolveErrorCause(Object error) {
    if (error case AddressLookupError()) {
      return switch (error) {
        AddressNotFound() => .addressNotFound,
        MultipleAddressesFound() => .multipleAddressesFound,
      };
    }

    return .unknown;
  }

  Future<void> dispose() async {
    await runner.close();
  }
}
