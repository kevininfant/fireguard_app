import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
  @override
  List<Object?> get props => [];
}

class ProfileStarted extends ProfileEvent {}

class ProfileDesignationUpdated extends ProfileEvent {
  final String newDesignation;
  const ProfileDesignationUpdated(this.newDesignation);

  @override
  List<Object?> get props => [newDesignation];
}
