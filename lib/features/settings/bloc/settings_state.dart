import 'package:equatable/equatable.dart';
import 'package:fireguard_app/features/settings/data/models/settings_model.dart';

enum SettingsStatus { initial, loading, success, failure }

class SettingsState extends Equatable {
  final SettingsStatus status;
  final SettingsModel settings;
  final String? errorMessage;

  const SettingsState({
    this.status = SettingsStatus.initial,
    this.settings = const SettingsModel(),
    this.errorMessage,
  });

  SettingsState copyWith({
    SettingsStatus? status,
    SettingsModel? settings,
    String? errorMessage,
  }) {
    return SettingsState(
      status: status ?? this.status,
      settings: settings ?? this.settings,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, settings, errorMessage];
}
