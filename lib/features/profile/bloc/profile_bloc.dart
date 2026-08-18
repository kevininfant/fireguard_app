import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fireguard_app/features/profile/bloc/profile_event.dart';
import 'package:fireguard_app/features/profile/bloc/profile_state.dart';
import 'package:fireguard_app/features/profile/data/repositories/profile_repository.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _profileRepository;

  ProfileBloc({ProfileRepository? profileRepository})
      : _profileRepository = profileRepository ?? ProfileRepository(),
        super(const ProfileState()) {
    on<ProfileStarted>(_onStarted);
  }

  Future<void> _onStarted(
    ProfileStarted event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      final badges = await _profileRepository.getBadges();
      emit(state.copyWith(
        status: ProfileStatus.success,
        badges: badges,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
