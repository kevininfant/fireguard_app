import 'package:fireguard_app/features/profile/data/models/badge_model.dart';

class ProfileRepository {
  final List<BadgeModel> _defaultBadges = const [
    BadgeModel(
      id: 'b_1',
      title: 'Fire Inspector Level 1',
      description: 'Awarded for passing basic hazard drills and code standards.',
      iconName: 'military_tech',
      triggerCondition: 'Complete Level 2',
      isUnlocked: true,
    ),
    BadgeModel(
      id: 'b_2',
      title: 'NFPA 70 Electrical Specialist',
      description: 'Mastered electrical clearance, arc flash boundary standards.',
      iconName: 'flash_on',
      triggerCondition: 'Complete Level 3',
      isUnlocked: true,
    ),
    BadgeModel(
      id: 'b_3',
      title: 'Hazmat Response Commander',
      description: 'Mastered all chemical and hazardous containment protocols.',
      iconName: 'warning',
      triggerCondition: 'Complete Level 5',
      isUnlocked: false,
    ),
    BadgeModel(
      id: 'b_4',
      title: 'Streak Sentinel',
      description: 'Maintained 5-day continuous safety training streak.',
      iconName: 'local_fire_department',
      triggerCondition: '5-Day Streak',
      isUnlocked: true,
    ),
    BadgeModel(
      id: 'b_5',
      title: 'EHS Top Performer',
      description: 'Reached Top 10 on the Global Field Inspector Leaderboard.',
      iconName: 'emoji_events',
      triggerCondition: 'Top 10 Rank',
      isUnlocked: false,
    ),
    BadgeModel(
      id: 'b_6',
      title: 'Master Drill Marshal',
      description: 'Completed 10 timed evacuation drills with 100% accuracy.',
      iconName: 'security',
      triggerCondition: '10 Perfect Drills',
      isUnlocked: false,
    ),
  ];

  Future<List<BadgeModel>> getBadges() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _defaultBadges;
  }
}
