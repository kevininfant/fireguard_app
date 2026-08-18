import 'package:equatable/equatable.dart';
import 'package:fireguard_app/features/profile/data/models/badge_model.dart';

enum ProfileStatus { initial, loading, success, failure }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final List<BadgeModel> badges;
  final String? errorMessage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.badges = const [],
    this.errorMessage,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    List<BadgeModel>? badges,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      badges: badges ?? this.badges,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, badges, errorMessage];
}
