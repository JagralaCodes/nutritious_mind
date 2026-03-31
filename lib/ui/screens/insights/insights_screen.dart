import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive/hive.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/typography.dart';
import '../../../data/models/habit.dart';
import '../../../data/models/food_log_entry.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final habits = Hive.box<Habit>('habits').values.toList();
    final foodLog = Hive.box<FoodLogEntry>('food_log').values.toList();
    final now = DateTime.now();

    // Weekly data
    final weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final habitsPerDay = List.generate(7, (i) {
      final day = now.subtract(Duration(days: now.weekday - 1 - i));
      return habits.where((h) => h.completions.any((c) =>
          c.year == day.year && c.month == day.month && c.day == day.day)).length.toDouble();
    });

    final mealsPerDay = List.generate(7, (i) {
      final day = now.subtract(Duration(days: now.weekday - 1 - i));
      return foodLog.where((f) =>
          f.date.year == day.year && f.date.month == day.month && f.date.day == day.day).length.toDouble();
    });

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(title: Text('Insights', style: AppTypography.heading3)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats row
            Row(children: [
              _CountCard(label: 'Total Meals', value: '${foodLog.length}', color: AppColors.accentBlue),
              const SizedBox(width: 12),
              _CountCard(label: 'Best Streak', value: '${habits.isEmpty ? 0 : habits.map((h) => h.currentStreak).reduce((a, b) => a > b ? a : b)}', color: AppColors.accentOrange),
            ]).animate().fadeIn().slideY(begin: 0.2),
            const SizedBox(height: 24),

            Text('This Week', style: AppTypography.heading3),
            const SizedBox(height: 16),

            // Bar chart
            Container(
              height: 200,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.surface2, borderRadius: BorderRadius.circular(16)),
              child: BarChart(BarChartData(
                barGroups: List.generate(7, (i) => BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(toY: habitsPerDay[i], color: AppColors.primary, width: 8, borderRadius: BorderRadius.circular(4)),
                    BarChartRodData(toY: mealsPerDay[i], color: AppColors.accentBlue, width: 8, borderRadius: BorderRadius.circular(4)),
                  ],
                )),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, _) =>
                    Text(weekDays[v.toInt()], style: AppTypography.bodySmall.copyWith(fontSize: 10)))),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
              )),
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
            const SizedBox(height: 8),
            Row(children: [
              Container(width: 12, height: 12, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(3))),
              const SizedBox(width: 6),
              Text('Habits', style: AppTypography.bodySmall),
              const SizedBox(width: 16),
              Container(width: 12, height: 12, decoration: BoxDecoration(color: AppColors.accentBlue, borderRadius: BorderRadius.circular(3))),
              const SizedBox(width: 6),
              Text('Meals', style: AppTypography.bodySmall),
            ]),
            const SizedBox(height: 24),

            // AI Summary placeholder
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface2,
                borderRadius: BorderRadius.circular(16),
                border: Border(left: BorderSide(color: AppColors.accentPurple, width: 3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Weekly Summary', style: AppTypography.labelLarge),
                  const SizedBox(height: 8),
                  Text(
                    habits.isEmpty
                        ? 'Start tracking habits and meals to see your weekly summary!'
                        : 'You\'ve completed ${habits.where((h) => h.completedToday).length} habits today and checked ${foodLog.length} meals this week. Keep going!',
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.5),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
          ],
        ),
      ),
    );
  }
}

class _CountCard extends StatelessWidget {
  final String label, value;
  final Color color;
  const _CountCard({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface2, borderRadius: BorderRadius.circular(16)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(value, style: AppTypography.mono.copyWith(color: color)),
        const SizedBox(height: 4),
        Text(label, style: AppTypography.bodySmall),
      ]),
    ));
  }
}
