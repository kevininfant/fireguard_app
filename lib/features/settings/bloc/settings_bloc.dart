import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fireguard_app/features/settings/bloc/settings_event.dart';
import 'package:fireguard_app/features/settings/bloc/settings_state.dart';
import 'package:fireguard_app/features/settings/data/repositories/settings_repository.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository _settingsRepository;

  SettingsBloc({SettingsRepository? settingsRepository})
      : _settingsRepository = settingsRepository ?? SettingsRepository(),
        super(const SettingsState()) {
    on<SettingsStarted>(_onStarted);
    on<SettingsUpdated>(_onUpdated);
  }

  Future<void> _onStarted(
    SettingsStarted event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(status: SettingsStatus.loading));
    try {
      final settings = await _settingsRepository.getSettings();
      emit(state.copyWith(
        status: SettingsStatus.success,
        settings: settings,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SettingsStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onUpdated(
    SettingsUpdated event,
    Emitter<SettingsState> emit,
  ) async {
    await _settingsRepository.saveSettings(event.settings);
    emit(state.copyWith(
      status: SettingsStatus.success,
      settings: event.settings,
    ));
  }
}
