import 'package:flutter/material.dart';
import 'package:fireguard_app/core/constants/app_colors.dart';

class RoleSelectorCard extends StatelessWidget {
  final String selectedRole;
  final ValueChanged<String> onRoleSelected;

  const RoleSelectorCard({
    super.key,
    required this.selectedRole,
    required this.onRoleSelected,
  });

  static const List<Map<String, dynamic>> roles = [
    {
      'role': 'EHS Manager',
      'label': 'EHS Manager / Compliance Lead',
      'icon': Icons.admin_panel_settings,
    },
    {
      'role': 'Safety Inspector',
      'label': 'Safety Inspector / Auditor',
      'icon': Icons.verified_user,
    },
    {
      'role': 'Fire Officer',
      'label': 'Fire Officer / Response Lead',
      'icon': Icons.local_fire_department,
    },
    {
      'role': 'Student / Trainee',
      'label': 'Student / Safety Trainee',
      'icon': Icons.school,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'OFFICIAL CLEARANCE LEVEL / ROLE',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
            color: AppColors.onSurfaceVariantText,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.outlineVariantColor),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              dropdownColor: AppColors.surfaceContainerHigh,
              value: roles.any((r) => r['role'] == selectedRole)
                  ? selectedRole
                  : roles.first['role'] as String,
              icon: const Icon(Icons.arrow_drop_down, color: AppColors.industrialOrange),
              items: roles.map((r) {
                final isSelected = r['role'] == selectedRole;
                return DropdownMenuItem<String>(
                  value: r['role'] as String,
                  child: Row(
                    children: [
                      Icon(
                        r['icon'] as IconData,
                        color: isSelected ? AppColors.industrialOrange : AppColors.onSurfaceVariantText,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          r['label'] as String,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? AppColors.industrialOrange : AppColors.onSurfaceText,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  onRoleSelected(val);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
