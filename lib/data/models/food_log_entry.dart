import 'package:hive/hive.dart';

part 'food_log_entry.g.dart';

@HiveType(typeId: 3)
class FoodLogEntry extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String mealName;

  @HiveField(2)
  List<String> ingredients;

  @HiveField(3)
  int healthScore;

  @HiveField(4)
  String aiAnalysis;

  @HiveField(5)
  DateTime date;

  @HiveField(6)
  List<String> tags;

  @HiveField(7)
  bool isFavourite;

  FoodLogEntry({
    required this.id,
    required this.mealName,
    this.ingredients = const [],
    this.healthScore = 0,
    this.aiAnalysis = '',
    DateTime? date,
    this.tags = const [],
    this.isFavourite = false,
  }) : date = date ?? DateTime.now();
}
