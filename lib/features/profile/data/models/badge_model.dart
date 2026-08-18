import 'package:equatable/equatable.dart';

class BadgeModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final String iconName;
  final String triggerCondition;
  final bool isUnlocked;

  const BadgeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    required this.triggerCondition,
    required this.isUnlocked,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'iconName': iconName,
      'triggerCondition': triggerCondition,
      'isUnlocked': isUnlocked,
    };
  }

  factory BadgeModel.fromJson(Map<String, dynamic> json) {
    return BadgeModel(
      id: json['id'] ?? 'b1',
      title: json['title'] ?? 'Fire Inspector Level 1',
      description: json['description'] ?? 'Awarded for passing basic hazard drills and code standards.',
      iconName: json['iconName'] ?? 'military_tech',
      triggerCondition: json['triggerCondition'] ?? 'Complete Level 2',
      isUnlocked: json['isUnlocked'] ?? false,
    );
  }

  @override
  List<Object?> get props => [id, title, description, iconName, triggerCondition, isUnlocked];
}
