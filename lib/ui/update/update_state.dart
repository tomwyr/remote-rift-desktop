import 'package:equatable/equatable.dart';

sealed class UpdateState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Initial extends UpdateState {}

class UpToDate extends UpdateState {}

class UpdateAvailable extends UpdateState {}

class UpdateInProgress extends UpdateState {}

class UpdateError extends UpdateState {}
