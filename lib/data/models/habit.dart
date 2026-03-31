import 'package:hive/hive.dart';

part 'habit.g.dart';

@HiveType(typeId: 2)
class Habit extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String category;

  @HiveField(3)
  String icon;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  List<DateTime> completions;

  Habit({
    required this.id,
    required this.title,
    required this.category,
    this.icon = '',
    DateTime? createdAt,
    List<DateTime>? completions,
  })  : createdAt = createdAt ?? DateTime.now(),
        completions = completions ?? [];

  int get currentStreak {
    if (completions.isEmpty) return 0;
    int streak = 0;
    final now = DateTime.now();
    for (int i = 0; i < 60; i++) {
      final day = DateTime(now.year, now.month, now.day - i);
      if (completions.any((c) => c.year == day.year && c.month == day.month && c.day == day.day)) {
        streak++;
      } else if (i > 0) {
        break;
      }
    }
    return streak;
  }

  bool get completedToday {
    final today = DateTime.now();
    return completions.any((c) => c.year == today.year && c.month == today.month && c.day == today.day);
  }
}
