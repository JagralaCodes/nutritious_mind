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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileBox = Hive.box<UserProfile>('user_profile');
    final profile = profileBox.get('profile');
    final name = profile?.name ?? 'Friend';
    final habitBox = Hive.box<Habit>('habits');
    final foodBox = Hive.box<FoodLogEntry>('food_log');

    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Good morning';
    } else if (hour < 17) {
      greeting = 'Good afternoon';
    } else {
      greeting = 'Good evening';
    }

    final habits = habitBox.values.toList();
    final completedToday = habits.where((h) => h.completedToday).length;
    final totalHabits = habits.length;
    final bestStreak = habits.isEmpty ? 0 : habits.map((h) => h.currentStreak).reduce((a, b) => a > b ? a : b);
    final mealsThisWeek = foodBox.values.where((f) {
      final now = DateTime.now();
      return f.date.isAfter(now.subtract(const Duration(days: 7)));
    }).length;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Text('$greeting,', style: AppTypography.bodySmall)
                  .animate().fadeIn(duration: 400.ms),
              Text(name, style: AppTypography.heading1)
                  .animate().fadeIn(delay: 100.ms).slideX(begin: -0.1),
              const SizedBox(height: 24),

              // Wellness Score Card
              _WellnessCard(habits: habits)
                  .animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
              const SizedBox(height: 16),

              // Quick Stats
              Row(
                children: [
                  _StatCard(icon: Icons.local_fire_department, label: 'Streak', value: '$bestStreak', color: AppColors.accentOrange, delay: 300),
                  const SizedBox(width: 12),
                  _StatCard(icon: Icons.restaurant_menu, label: 'Meals', value: '$mealsThisWeek', color: AppColors.accentBlue, delay: 400),
                  const SizedBox(width: 12),
                  _StatCard(icon: Icons.check_circle_outline, label: 'Habits', value: '$completedToday/$totalHabits', color: AppColors.accentPurple, delay: 500),
                ],
              ),
              const SizedBox(height: 24),

              // Quick Actions
              Text('Quick Actions', style: AppTypography.heading3)
                  .animate().fadeIn(delay: 500.ms),
              const SizedBox(height: 12),
              Row(
                children: [
                  _ActionButton(icon: Icons.chat_bubble_outline, label: 'Ask Meera', onTap: () => Get.toNamed(AppRoutes.chat), delay: 600),
                  const SizedBox(width: 12),
                  _ActionButton(icon: Icons.science_outlined, label: 'Check Meal', onTap: () => Get.toNamed(AppRoutes.checker), delay: 700),
                  const SizedBox(width: 12),
                  _ActionButton(icon: Icons.track_changes, label: 'Habits', onTap: () => Get.toNamed(AppRoutes.habits), delay: 800),
                ],
              ),
              const SizedBox(height: 24),

              // Daily Tip
              _DailyTipCard()
                  .animate().fadeIn(delay: 700.ms).slideY(begin: 0.2),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppColors.surface2,
        indicatorColor: AppColors.primary.withValues(alpha: 0.2),
        selectedIndex: 0,
        onDestinationSelected: (i) {
          switch (i) {
            case 1: Get.toNamed(AppRoutes.chat); break;
            case 2: Get.toNamed(AppRoutes.checker); break;
            case 3: Get.toNamed(AppRoutes.habits); break;
            case 4: Get.toNamed(AppRoutes.insights); break;
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline), selectedIcon: Icon(Icons.chat_bubble), label: 'Chat'),
          NavigationDestination(icon: Icon(Icons.science_outlined), selectedIcon: Icon(Icons.science), label: 'Check'),
          NavigationDestination(icon: Icon(Icons.track_changes_outlined), selectedIcon: Icon(Icons.track_changes), label: 'Habits'),
          NavigationDestination(icon: Icon(Icons.insights_outlined), selectedIcon: Icon(Icons.insights), label: 'Insights'),
        ],
      ),
    );
  }
}

class _WellnessCard extends StatelessWidget {
  final List<Habit> habits;
  const _WellnessCard({required this.habits});

  @override
  Widget build(BuildContext context) {
    final total = habits.length;
    final done = habits.where((h) => h.completedToday).length;
    final score = total > 0 ? ((done / total) * 100).round() : 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Wellness Score', style: AppTypography.bodySmall),
                const SizedBox(height: 4),
                Text('Based on today\'s habits', style: AppTypography.bodySmall.copyWith(fontSize: 11)),
              ],
            ),
          ),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: score / 100),
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) {
              final displayScore = (value * 100).round();
              final color = displayScore > 70 ? AppColors.primary : displayScore > 40 ? AppColors.accentOrange : AppColors.error;
              return SizedBox(
                width: 80,
                height: 80,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: value,
                      strokeWidth: 6,
                      backgroundColor: AppColors.surface3,
                      valueColor: AlwaysStoppedAnimation(color),
                    ),
                    Text('$displayScore', style: AppTypography.mono.copyWith(color: color)),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final int delay;
  const _StatCard({required this.icon, required this.label, required this.value, required this.color, required this.delay});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface2,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(value, style: AppTypography.heading3),
            Text(label, style: AppTypography.bodySmall),
          ],
        ),
      ).animate().fadeIn(delay: Duration(milliseconds: delay)).slideY(begin: 0.3),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final int delay;
  const _ActionButton({required this.icon, required this.label, required this.onTap, required this.delay});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              Icon(icon, color: AppColors.primary, size: 28),
              const SizedBox(height: 8),
              Text(label, style: AppTypography.bodySmall.copyWith(color: AppColors.primary)),
            ],
          ),
        ),
      ).animate().fadeIn(delay: Duration(milliseconds: delay)).scale(begin: const Offset(0.9, 0.9)),
    );
  }
}

class _DailyTipCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: AppColors.primary, width: 3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('💡', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Daily Tip', style: AppTypography.labelLarge),
                const SizedBox(height: 4),
                Text(
                  'Add a handful of peanuts to your poha for a protein boost.',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
