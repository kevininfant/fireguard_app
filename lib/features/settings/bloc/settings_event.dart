import 'package:equatable/equatable.dart';
import 'package:fireguard_app/features/settings/data/models/settings_model.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
  @override
  List<Object?> get props => [];
}

class SettingsStarted extends SettingsEvent {}

class SettingsUpdated extends SettingsEvent {
  final SettingsModel settings;
  const SettingsUpdated(this.settings);

  @override
  List<Object?> get props => [settings];
}
