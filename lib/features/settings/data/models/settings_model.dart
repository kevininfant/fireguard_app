import 'package:equatable/equatable.dart';

class SettingsModel extends Equatable {
  final String displayName;
  final String designation;
  final bool darkModeEnabled;
  final bool sfxEnabled;
  final bool hapticEnabled;
  final String explanationPopups; // 'Always', 'Only on Error', 'Never'
  final bool timerWarningsEnabled;
  final bool dailyReminderEnabled;
  final String dailyReminderTime;
  final bool streakSaverEnabled;

  const SettingsModel({
    this.displayName = 'Alex Rivera',
    this.designation = 'EHS Manager',
    this.darkModeEnabled = true,
    this.sfxEnabled = true,
    this.hapticEnabled = true,
    this.explanationPopups = 'Always',
    this.timerWarningsEnabled = true,
    this.dailyReminderEnabled = true,
    this.dailyReminderTime = '09:00 AM',
    this.streakSaverEnabled = true,
  });

  SettingsModel copyWith({
    String? displayName,
    String? designation,
    bool? darkModeEnabled,
    bool? sfxEnabled,
    bool? hapticEnabled,
    String? explanationPopups,
    bool? timerWarningsEnabled,
    bool? dailyReminderEnabled,
    String? dailyReminderTime,
    bool? streakSaverEnabled,
  }) {
    return SettingsModel(
      displayName: displayName ?? this.displayName,
      designation: designation ?? this.designation,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
      sfxEnabled: sfxEnabled ?? this.sfxEnabled,
      hapticEnabled: hapticEnabled ?? this.hapticEnabled,
      explanationPopups: explanationPopups ?? this.explanationPopups,
      timerWarningsEnabled: timerWarningsEnabled ?? this.timerWarningsEnabled,
      dailyReminderEnabled: dailyReminderEnabled ?? this.dailyReminderEnabled,
      dailyReminderTime: dailyReminderTime ?? this.dailyReminderTime,
      streakSaverEnabled: streakSaverEnabled ?? this.streakSaverEnabled,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'designation': designation,
      'darkModeEnabled': darkModeEnabled,
      'sfxEnabled': sfxEnabled,
      'hapticEnabled': hapticEnabled,
      'explanationPopups': explanationPopups,
      'timerWarningsEnabled': timerWarningsEnabled,
      'dailyReminderEnabled': dailyReminderEnabled,
      'dailyReminderTime': dailyReminderTime,
      'streakSaverEnabled': streakSaverEnabled,
    };
  }

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      displayName: json['displayName'] ?? 'Alex Rivera',
      designation: json['designation'] ?? 'EHS Manager',
      darkModeEnabled: json['darkModeEnabled'] ?? true,
      sfxEnabled: json['sfxEnabled'] ?? true,
      hapticEnabled: json['hapticEnabled'] ?? true,
      explanationPopups: json['explanationPopups'] ?? 'Always',
      timerWarningsEnabled: json['timerWarningsEnabled'] ?? true,
      dailyReminderEnabled: json['dailyReminderEnabled'] ?? true,
      dailyReminderTime: json['dailyReminderTime'] ?? '09:00 AM',
      streakSaverEnabled: json['streakSaverEnabled'] ?? true,
    );
  }

  @override
  List<Object?> get props => [
        displayName,
        designation,
        darkModeEnabled,
        sfxEnabled,
        hapticEnabled,
        explanationPopups,
        timerWarningsEnabled,
        dailyReminderEnabled,
        dailyReminderTime,
        streakSaverEnabled,
      ];
}
