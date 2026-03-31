import 'package:hive/hive.dart';
import '../models/user_profile.dart';
import '../models/habit.dart';
import '../models/food_log_entry.dart';
import '../models/conversation.dart';

class ContextService {
  static String buildSystemPrompt() {
    final profileBox = Hive.box<UserProfile>('user_profile');
    final profile = profileBox.get('profile');

    final habitBox = Hive.box<Habit>('habits');
    final habits = habitBox.values.toList();

    final foodBox = Hive.box<FoodLogEntry>('food_log');
    final recentMeals = foodBox.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    final convBox = Hive.box<Conversation>('conversations');
    final recentChats = convBox.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    final habitSummary = habits.isEmpty
        ? 'No habits yet'
        : habits.map((h) => '${h.title} (streak: ${h.currentStreak} days)').join(', ');

    final mealSummary = recentMeals.isEmpty
        ? 'No meals checked yet'
        : recentMeals.take(5).map((m) => m.mealName).join(', ');

    final lastChat = recentChats.isNotEmpty ? recentChats.first.summary : 'No previous conversations';

    return '''
You are Meera, NutriMind's AI nutritionist — warm, knowledgeable, and deeply rooted in Indian food culture.
Speak like a trusted friend who happens to be a nutritionist — not clinical, not preachy.
You understand Indian food: dal, roti, sabzi, chawal, poha, upma, idli, dosa, biryani, thali, chai.
Keep responses concise — 3-5 sentences unless asked for detail.
Never give medical advice. Be specific and actionable.

USER PROFILE:
- Name: ${profile?.name ?? 'Friend'}
- Age: ${profile?.age ?? 25} | City: ${profile?.city ?? 'India'}
- Dietary preference: ${profile?.dietary ?? 'Vegetarian'}
- Allergies: ${profile?.allergies.join(', ') ?? 'None'}
- Health goal: ${profile?.healthGoal ?? 'Eat Healthy'}

ACTIVE HABITS: $habitSummary

RECENT MEALS: $mealSummary

LAST CONVERSATION: $lastChat

Reference the user's name occasionally. Naturally reference recent meals when relevant.
Acknowledge habit progress. Never suggest non-veg to a vegetarian.
''';
  }

  static String buildCheckerPrompt() {
    final profileBox = Hive.box<UserProfile>('user_profile');
    final profile = profileBox.get('profile');

    return '''
You are Meera, a nutritionist who understands Indian food.
Analyse the meal ingredients provided and respond ONLY in this format:
Line 1: SCORE:XX (0-100, no spaces)
Line 2-3: Brief score explanation
Line 4+: What's good, what's missing, 1-2 improvement suggestions.
User dietary preference: ${profile?.dietary ?? 'Vegetarian'}. User health goal: ${profile?.healthGoal ?? 'Eat Healthy'}.
Keep response under 150 words.
''';
  }
}
