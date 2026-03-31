import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/typography.dart';
import '../../../data/models/food_log_entry.dart';
import '../../../data/models/conversation.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.surface,
        appBar: AppBar(
          title: Text('History', style: AppTypography.heading3),
          bottom: TabBar(
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            tabs: const [Tab(text: 'Meal Log'), Tab(text: 'Conversations')],
          ),
        ),
        body: TabBarView(children: [
          _MealLogTab(),
          _ConversationsTab(),
        ]),
      ),
    );
  }
}

class _MealLogTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final entries = Hive.box<FoodLogEntry>('food_log').values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    if (entries.isEmpty) return Center(child: Text('No meals checked yet', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)));
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: entries.length,
      itemBuilder: (context, i) {
        final e = entries[i];
        final color = e.healthScore > 70 ? AppColors.primary : e.healthScore > 40 ? AppColors.accentOrange : AppColors.error;
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: AppColors.surface2, borderRadius: BorderRadius.circular(14)),
          child: Row(children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
              child: Center(child: Text('${e.healthScore}', style: AppTypography.labelLarge.copyWith(color: color, fontSize: 13))),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(e.mealName, style: AppTypography.labelLarge),
              Text(DateFormat('MMM d, h:mm a').format(e.date), style: AppTypography.bodySmall),
            ])),
          ]),
        ).animate().fadeIn(delay: Duration(milliseconds: i * 80));
      },
    );
  }
}

class _ConversationsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final convs = Hive.box<Conversation>('conversations').values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    if (convs.isEmpty) return Center(child: Text('No conversations yet', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)));
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: convs.length,
      itemBuilder: (context, i) {
        final c = convs[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: AppColors.surface2, borderRadius: BorderRadius.circular(14)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(c.summary.isNotEmpty ? c.summary : 'Chat', style: AppTypography.labelLarge),
            const SizedBox(height: 4),
            Text(DateFormat('MMM d, h:mm a').format(c.date), style: AppTypography.bodySmall),
          ]),
        ).animate().fadeIn(delay: Duration(milliseconds: i * 80));
      },
    );
  }
}
