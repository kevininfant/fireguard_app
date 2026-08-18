import 'package:flutter/material.dart';
import 'package:fireguard_app/core/constants/app_colors.dart';
import 'package:fireguard_app/core/widgets/custom_text_field.dart';

class EditDesignationDialog extends StatefulWidget {
  final String currentDesignation;
  final ValueChanged<String> onSave;

  const EditDesignationDialog({
    super.key,
    required this.currentDesignation,
    required this.onSave,
  });

  @override
  State<EditDesignationDialog> createState() => _EditDesignationDialogState();
}

class _EditDesignationDialogState extends State<EditDesignationDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentDesignation);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surfaceContainerHigh,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        'Update Designation',
        style: TextStyle(
          color: AppColors.onSurfaceText,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      content: CustomTextField(
        controller: _controller,
        label: 'Official Role / Title',
        hintText: 'e.g. Lead EHS Inspector',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: AppColors.onSurfaceVariantText)),
        ),
        ElevatedButton(
          onPressed: () {
            if (_controller.text.trim().isNotEmpty) {
              widget.onSave(_controller.text.trim());
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.industrialOrange,
            foregroundColor: AppColors.onIndustrialOrange,
          ),
          child: const Text('Save Changes'),
        ),
      ],
    );
  }
}
