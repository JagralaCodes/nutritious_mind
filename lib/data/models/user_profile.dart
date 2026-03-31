import 'package:hive/hive.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 0)
class UserProfile extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int age;

  @HiveField(2)
  String city;

  @HiveField(3)
  String dietary;

  @HiveField(4)
  List<String> allergies;

  @HiveField(5)
  String healthGoal;

  @HiveField(6)
  bool onboardingDone;

  UserProfile({
    this.name = '',
    this.age = 0,
    this.city = '',
    this.dietary = 'Vegetarian',
    this.allergies = const [],
    this.healthGoal = 'Eat Healthy',
    this.onboardingDone = false,
  });
}
