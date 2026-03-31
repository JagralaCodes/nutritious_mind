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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  late Box<UserProfile> _profileBox;
  late Box<Habit> _habitBox;
  late Box<FoodLogEntry> _foodBox;

  @override
  void initState() {
    super.initState();
    _profileBox = Hive.box<UserProfile>('user_profile');
    _habitBox = Hive.box<Habit>('habits');
    _foodBox = Hive.box<FoodLogEntry>('food_log');
    // Seed habits if empty
    if (_habitBox.isEmpty) _seedHabits();
    // Seed food log if empty
    if (_foodBox.isEmpty) _seedFoodLog();
  }

  void _seedHabits() {
    final now = DateTime.now();
    final seeds = [
      Habit(id: '1', title: 'Eat breakfast daily', icon: '🌅', category: 'eating',
          completions: List.generate(5, (i) => DateTime(now.year, now.month, now.day - i))),
      Habit(id: '2', title: 'Drink 8 glasses of water', icon: '💧', category: 'hydration',
          completions: List.generate(3, (i) => DateTime(now.year, now.month, now.day - i))),
      Habit(id: '3', title: 'No sugar after 8pm', icon: '🚫', category: 'timing',
          completions: [DateTime(now.year, now.month, now.day)]),
      Habit(id: '4', title: 'Eat 2 fruits daily', icon: '🍎', category: 'eating'),
      Habit(id: '5', title: '10 min mindful eating', icon: '🧘', category: 'mindfulness'),
    ];
    for (final h in seeds) {
      _habitBox.put(h.id, h);
    }
  }

  void _seedFoodLog() {
    final now = DateTime.now();
    final seeds = [
      FoodLogEntry(id: 'f1', mealName: 'Poha with peanuts', ingredients: ['poha', 'peanuts', 'onion', 'turmeric'],
          healthScore: 82, aiAnalysis: 'Excellent breakfast! Rich in complex carbs and protein from peanuts.', date: now.subtract(const Duration(days: 1))),
      FoodLogEntry(id: 'f2', mealName: 'Dal rice + ghee', ingredients: ['dal', 'rice', 'ghee'],
          healthScore: 74, aiAnalysis: 'Good balanced meal with protein from dal and carbs from rice.', date: now.subtract(const Duration(days: 2))),
      FoodLogEntry(id: 'f3', mealName: 'Vada Pav', ingredients: ['bread', 'potato', 'chutney', 'oil'],
          healthScore: 42, aiAnalysis: 'High in refined carbs and oil. Occasional treat is fine!', date: now.subtract(const Duration(days: 3))),
      FoodLogEntry(id: 'f4', mealName: 'Oats upma', ingredients: ['oats', 'vegetables', 'mustard', 'curry leaves'],
          healthScore: 88, aiAnalysis: 'Excellent choice! High fiber, vitamins from veggies.', date: now.subtract(const Duration(days: 4)), isFavourite: true),
    ];
    for (final f in seeds) {
      _foodBox.put(f.id, f);
    }
  }

  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final profile = _profileBox.get('profile');
    final name = profile?.name.isNotEmpty == true ? profile!.name : 'Friend';

    final hour = DateTime.now().hour;
    final greeting = hour < 12 ? 'Good morning' : hour < 17 ? 'Good afternoon' : 'Good evening';

    final habits = _habitBox.values.toList();
    final completedToday = habits.where((h) => h.completedToday).length;
    final bestStreak = habits.isEmpty ? 0 : habits.map((h) => h.currentStreak).reduce((a, b) => a > b ? a : b);
    final mealsThisWeek = _foodBox.values.where((f) {
      return f.date.isAfter(DateTime.now().subtract(const Duration(days: 7)));
    }).length;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          backgroundColor: AppColors.surface2,
          onRefresh: () async => _refresh(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting header
                Row(
                  children: [
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('$greeting,', style: AppTypography.bodySmall)
                            .animate().fadeIn(duration: 400.ms),
                        Text(name, style: AppTypography.heading1)
                            .animate().fadeIn(delay: 100.ms).slideX(begin: -0.1),
                      ],
                    )),
                    GestureDetector(
                      onTap: () async { await Get.toNamed(AppRoutes.profile); _refresh(); },
                      child: Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            name.isNotEmpty ? name[0].toUpperCase() : 'N',
                            style: AppTypography.heading3.copyWith(color: AppColors.primary),
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: 200.ms),
                  ],
                ),
                const SizedBox(height: 24),

                // Wellness Score Card
                _WellnessCard(habits: habits)
                    .animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
                const SizedBox(height: 16),

                // Quick Stats
                Row(children: [
                  _StatCard(icon: Icons.local_fire_department, label: 'Best Streak', value: '$bestStreak d', color: AppColors.accentOrange, delay: 300),
                  const SizedBox(width: 12),
                  _StatCard(icon: Icons.restaurant_menu, label: 'Meals', value: '$mealsThisWeek', color: AppColors.accentBlue, delay: 400),
                  const SizedBox(width: 12),
                  _StatCard(icon: Icons.check_circle_outline, label: 'Today', value: '$completedToday/${habits.length}', color: AppColors.accentPurple, delay: 500),
                ]),
                const SizedBox(height: 24),

                // Quick Actions
                Text('Quick Actions', style: AppTypography.heading3).animate().fadeIn(delay: 500.ms),
                const SizedBox(height: 12),
                Row(children: [
                  _ActionButton(icon: Icons.chat_bubble_outline, label: 'Ask Meera', onTap: () async { await Get.toNamed(AppRoutes.chat); _refresh(); }, delay: 600),
                  const SizedBox(width: 12),
                  _ActionButton(icon: Icons.science_outlined, label: 'Check Meal', onTap: () async { await Get.toNamed(AppRoutes.checker); _refresh(); }, delay: 700),
                  const SizedBox(width: 12),
                  _ActionButton(icon: Icons.track_changes, label: 'Habits', onTap: () async { await Get.toNamed(AppRoutes.habits); _refresh(); }, delay: 800),
                ]),
                const SizedBox(height: 24),

                // Daily Tip
                const _DailyTipCard().animate().fadeIn(delay: 700.ms).slideY(begin: 0.2),
                const SizedBox(height: 20),

                // Recent meals
                if (mealsThisWeek > 0) ...[
                  Text('Recent Meals', style: AppTypography.heading3).animate().fadeIn(delay: 800.ms),
                  const SizedBox(height: 12),
                  ..._foodBox.values.toList()
                      .sorted((a, b) => b.date.compareTo(a.date))
                      .take(3)
                      .toList()
                      .asMap()
                      .entries
                      .map((entry) => _RecentMealTile(entry: entry.value, delay: 900 + entry.key * 100)),
                ],
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppColors.surface2,
        indicatorColor: AppColors.primary.withValues(alpha: 0.15),
        selectedIndex: 0,
        onDestinationSelected: (i) async {
          switch (i) {
            case 1: await Get.toNamed(AppRoutes.chat); _refresh(); break;
            case 2: await Get.toNamed(AppRoutes.checker); _refresh(); break;
            case 3: await Get.toNamed(AppRoutes.habits); _refresh(); break;
            case 4: await Get.toNamed(AppRoutes.insights); _refresh(); break;
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.surface2, AppColors.primary.withValues(alpha: 0.05)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(children: [
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Wellness Score', style: AppTypography.bodySmall),
            const SizedBox(height: 4),
            Text('Based on today\'s habits', style: AppTypography.bodySmall.copyWith(fontSize: 11, color: AppColors.textTertiary)),
            const SizedBox(height: 12),
            Text(
              score > 70 ? 'Great job! 🎉' : score > 40 ? 'Keep going! 💪' : 'Start strong! 🌱',
              style: AppTypography.labelLarge.copyWith(color: AppColors.primary),
            ),
          ],
        )),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: score / 100),
          duration: const Duration(milliseconds: 1200),
          curve: Curves.easeOutCubic,
          builder: (context, value, _) {
            final displayScore = (value * 100).round();
            final color = displayScore > 70 ? AppColors.primary : displayScore > 40 ? AppColors.accentOrange : AppColors.error;
            return SizedBox(
              width: 84, height: 84,
              child: Stack(alignment: Alignment.center, children: [
                CircularProgressIndicator(
                  value: value,
                  strokeWidth: 7,
                  backgroundColor: AppColors.surface3,
                  valueColor: AlwaysStoppedAnimation(color),
                ),
                Column(mainAxisSize: MainAxisSize.min, children: [
                  Text('$displayScore', style: AppTypography.mono.copyWith(color: color, fontSize: 20)),
                  Text('%', style: AppTypography.bodySmall.copyWith(fontSize: 10)),
                ]),
              ]),
            );
          },
        ),
      ]),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final Color color;
  final int delay;
  const _StatCard({required this.icon, required this.label, required this.value, required this.color, required this.delay});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface2,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(value, style: AppTypography.heading3.copyWith(fontSize: 16)),
          Text(label, style: AppTypography.bodySmall.copyWith(fontSize: 10), textAlign: TextAlign.center),
        ]),
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
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
          ),
          child: Column(children: [
            Icon(icon, color: AppColors.primary, size: 26),
            const SizedBox(height: 6),
            Text(label, style: AppTypography.bodySmall.copyWith(color: AppColors.primary, fontSize: 11), textAlign: TextAlign.center),
          ]),
        ),
      ).animate().fadeIn(delay: Duration(milliseconds: delay)).scale(begin: const Offset(0.9, 0.9)),
    );
  }
}

class _DailyTipCard extends StatelessWidget {
  const _DailyTipCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(16),
        border: const Border(left: BorderSide(color: AppColors.primary, width: 3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('💡', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Daily Tip', style: AppTypography.labelLarge),
              const SizedBox(height: 4),
              Text(
                'Add a handful of peanuts to your poha for a protein boost.',
                style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.4),
              ),
            ],
          )),
        ],
      ),
    );
  }
}

class _RecentMealTile extends StatelessWidget {
  final FoodLogEntry entry;
  final int delay;
  const _RecentMealTile({required this.entry, required this.delay});

  @override
  Widget build(BuildContext context) {
    final color = entry.healthScore > 70 ? AppColors.primary : entry.healthScore > 40 ? AppColors.accentOrange : AppColors.error;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface2, borderRadius: BorderRadius.circular(14)),
      child: Row(children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
          child: Center(child: Text('${entry.healthScore}', style: AppTypography.labelLarge.copyWith(color: color, fontSize: 13))),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(entry.mealName, style: AppTypography.labelLarge)),
        if (entry.isFavourite) const Icon(Icons.favorite, color: AppColors.error, size: 16),
      ]),
    ).animate().fadeIn(delay: Duration(milliseconds: delay)).slideX(begin: 0.1);
  }
}

extension _ListX<T> on List<T> {
  List<T> sorted(int Function(T a, T b) compare) {
    final copy = List<T>.from(this);
    copy.sort(compare);
    return copy;
  }
}
