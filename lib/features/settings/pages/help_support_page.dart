import 'package:flutter/material.dart';
import 'package:fireguard_app/core/constants/app_colors.dart';
import 'package:fireguard_app/core/widgets/common_button.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text('Help & Support Center'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.industrialOrange),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.industrialOrange.withValues(alpha: 0.5)),
              ),
              child: Column(
                children: const [
                  Icon(Icons.help_outline, color: AppColors.industrialOrange, size: 48),
                  SizedBox(height: 12),
                  Text(
                    'NFPA Safety & EHS Support Desk',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurfaceText,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Get compliance guidelines, technical assistance, or report facility safety concerns.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.onSurfaceVariantText,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'FREQUENTLY ASKED QUESTIONS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
                color: AppColors.onSurfaceVariantText,
              ),
            ),
            const SizedBox(height: 12),

            _buildFaqItem(
              'How are Safety Points calculated?',
              'Each correct answer in certification drills awards 50 points. Completing daily hazard drills gives bonus points and extends your training streak.',
            ),
            const SizedBox(height: 10),
            _buildFaqItem(
              'How do I redeem PPE equipment vouchers?',
              'Visit the Reward Store, select any available partner voucher from 3M, Honeywell, or MSA Safety, and click Redeem if you meet the points balance.',
            ),
            const SizedBox(height: 10),
            _buildFaqItem(
              'What NFPA codes are covered?',
              'FireGuard covers NFPA 10 (Portable Extinguishers), NFPA 70 / 70E (Electrical Clearances & Arc Flash), NFPA 101 (Life Safety Code), NFPA 80 (Fire Doors), and OSHA standard hazard guidelines.',
            ),
            const SizedBox(height: 24),

            CommonButton(
              text: 'CONTACT EHS SUPPORT DESK',
              icon: Icons.support_agent,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Support ticket created. An EHS Specialist will respond shortly.'),
                    backgroundColor: AppColors.successGreen,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.surfaceContainerHighest),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.industrialOrange,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            answer,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.onSurfaceVariantText,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
