import 'package:equatable/equatable.dart';
import 'package:remote_rift_utils/remote_rift_utils.dart';

sealed class UpdateState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Initial extends UpdateState {}

class UpToDate extends UpdateState {}

class UpdateAvailable extends UpdateState {
  UpdateAvailable({required this.version});

  final Version version;

  @override
  List<Object?> get props => [version];
}

class UpdateInProgress extends UpdateState {}

class UpdateError extends UpdateState {
  UpdateError({required this.version});

  final Version version;

  @override
  List<Object?> get props => [version];
}
