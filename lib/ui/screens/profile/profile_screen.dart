import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/typography.dart';
import '../../../core/router/app_router.dart';
import '../../../data/models/user_profile.dart';
import '../../../data/models/habit.dart';
import '../../../data/models/food_log_entry.dart';
import '../../../data/models/conversation.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserProfile? _profile;

  @override
  void initState() {
    super.initState();
    _profile = Hive.box<UserProfile>('user_profile').get('profile');
  }

  void _resetData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface2,
        title: Text('Reset All Data?', style: AppTypography.heading3),
        content: Text('This will delete all your data and restart onboarding.', style: AppTypography.bodyMedium),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text('Reset', style: TextStyle(color: AppColors.error))),
        ],
      ),
    );
    if (confirmed == true) {
      await Hive.box<UserProfile>('user_profile').clear();
      await Hive.box<Habit>('habits').clear();
      await Hive.box<FoodLogEntry>('food_log').clear();
      await Hive.box<Conversation>('conversations').clear();
      await Hive.box('app_state').clear();
      Get.offAllNamed(AppRoutes.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(title: Text('Profile', style: AppTypography.heading3)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Center(child: Text(_profile?.name.isNotEmpty == true ? _profile!.name[0].toUpperCase() : '?',
                  style: AppTypography.display.copyWith(color: AppColors.primary))),
            ).animate().scale(begin: const Offset(0.8, 0.8), duration: 400.ms, curve: Curves.easeOutBack),
            const SizedBox(height: 12),
            Text(_profile?.name ?? 'Guest', style: AppTypography.heading2),
            Text(_profile?.city ?? '', style: AppTypography.bodySmall),
            const SizedBox(height: 32),

            _InfoTile('Dietary', _profile?.dietary ?? '-'),
            _InfoTile('Health Goal', _profile?.healthGoal ?? '-'),
            _InfoTile('Age', '${_profile?.age ?? '-'}'),
            _InfoTile('Allergies', _profile?.allergies.isEmpty != false ? 'None' : _profile!.allergies.join(', ')),

            const SizedBox(height: 32),

            // Context section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.surface2, borderRadius: BorderRadius.circular(16)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Meera knows about you', style: AppTypography.labelLarge),
                const SizedBox(height: 8),
                Text('• Your dietary preference: ${_profile?.dietary}', style: AppTypography.bodySmall),
                Text('• Your health goal: ${_profile?.healthGoal}', style: AppTypography.bodySmall),
                Text('• ${Hive.box<Habit>("habits").length} active habits', style: AppTypography.bodySmall),
                Text('• ${Hive.box<FoodLogEntry>("food_log").length} meals analyzed', style: AppTypography.bodySmall),
              ]),
            ).animate().fadeIn(delay: 200.ms),

            const SizedBox(height: 32),
            OutlinedButton(
              onPressed: _resetData,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Reset All Data'),
            ),
            const SizedBox(height: 16),
            Text('NutriMind v1.0 — Built for AMD Slingshot', style: AppTypography.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label, value;
  const _InfoTile(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(color: AppColors.surface2, borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Text(label, style: AppTypography.bodySmall),
        const Spacer(),
        Text(value, style: AppTypography.labelLarge),
      ]),
    );
  }
}
