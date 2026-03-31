import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';
import 'data/models/user_profile.dart';
import 'data/models/habit.dart';
import 'data/models/food_log_entry.dart';
import 'data/models/conversation.dart';
import 'data/models/message.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // Load env
  await dotenv.load(fileName: '.env');

  // Init Hive
  await Hive.initFlutter();
  Hive.registerAdapter(UserProfileAdapter());
  Hive.registerAdapter(HabitAdapter());
  Hive.registerAdapter(FoodLogEntryAdapter());
  Hive.registerAdapter(ConversationAdapter());
  Hive.registerAdapter(MessageAdapter());

  await Hive.openBox<UserProfile>('user_profile');
  await Hive.openBox<Habit>('habits');
  await Hive.openBox<FoodLogEntry>('food_log');
  await Hive.openBox<Conversation>('conversations');
  await Hive.openBox('app_state');

  runApp(const NutriMindApp());
}
