import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/typography.dart';
import '../../../data/models/habit.dart';

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});
  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  late Box<Habit> _box;

  @override
  void initState() {
    super.initState();
    _box = Hive.box<Habit>('habits');
    if (_box.isEmpty) _seedHabits();
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
      _box.put(h.id, h);
    }
  }

  void _toggleHabit(Habit habit) {
    if (habit.completedToday) return;
    habit.completions = [...habit.completions, DateTime.now()];
    habit.save();
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${habit.title} completed! 🎉'), backgroundColor: AppColors.primary, duration: 1.seconds),
    );
  }

  @override
  Widget build(BuildContext context) {
    final habits = _box.values.toList();
    final done = habits.where((h) => h.completedToday).length;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(title: Text('Habits', style: AppTypography.heading3)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.surface2, borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Today\'s Progress', style: AppTypography.labelLarge),
                  const SizedBox(height: 8),
                  Row(children: [
                    Text('$done/${habits.length}', style: AppTypography.heading2.copyWith(color: AppColors.primary)),
                    const SizedBox(width: 8),
                    Text('habits done', style: AppTypography.bodySmall),
                  ]),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: habits.isEmpty ? 0 : done / habits.length,
                      backgroundColor: AppColors.surface3,
                      valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn().slideY(begin: 0.2),
            const SizedBox(height: 20),

            Text('Today\'s Habits', style: AppTypography.heading3),
            const SizedBox(height: 12),
            ...List.generate(habits.length, (i) {
              final h = habits[i];
              return GestureDetector(
                onTap: () => _toggleHabit(h),
                child: AnimatedContainer(
                  duration: 300.ms,
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: h.completedToday ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surface2,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: h.completedToday ? AppColors.primary.withValues(alpha: 0.3) : AppColors.cardBorder,
                    ),
                  ),
                  child: Row(children: [
                    Text(h.icon, style: const TextStyle(fontSize: 28)),
                    const SizedBox(width: 12),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(h.title, style: AppTypography.bodyLarge.copyWith(
                          decoration: h.completedToday ? TextDecoration.lineThrough : null,
                          color: h.completedToday ? AppColors.textSecondary : Colors.white,
                        )),
                        if (h.currentStreak > 0)
                          Text('🔥 ${h.currentStreak} day streak', style: AppTypography.bodySmall.copyWith(color: AppColors.accentOrange)),
                      ],
                    )),
                    Container(
                      width: 28, height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: h.completedToday ? AppColors.primary : Colors.transparent,
                        border: Border.all(color: h.completedToday ? AppColors.primary : AppColors.textSecondary, width: 2),
                      ),
                      child: h.completedToday ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                    ),
                  ]),
                ),
              ).animate().fadeIn(delay: Duration(milliseconds: 100 * i)).slideX(begin: 0.1);
            }),
          ],
        ),
      ),
    );
  }
}
