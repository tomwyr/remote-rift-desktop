import 'package:draft/draft.dart';
import 'package:equatable/equatable.dart';

import '../../i18n/strings.g.dart';

part 'service_state.draft.dart';

sealed class ServiceState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Initial extends ServiceState {}

class Starting extends ServiceState {}

class Started extends ServiceState {}

@draft
class StartupError extends ServiceState {
  StartupError({required this.cause, this.reconnectTriggered = false});

  final ServiceErrorCause cause;
  final bool reconnectTriggered;

  @override
  List<Object?> get props => [cause, reconnectTriggered];
}

enum ServiceErrorCause {
  addressNotFound,
  multipleAddressesFound,
  unknown;

  String get description => switch (this) {
    .addressNotFound => t.service.errorNoAddressDescription,
    .multipleAddressesFound => t.service.errorMultipleAddressesDescription,
    .unknown => t.service.errorUnknownDescription,
  };
}
