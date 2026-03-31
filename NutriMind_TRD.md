# NutriMind — Technical Requirements Document (TRD)
**Version:** 1.0 | **Stack:** Flutter 3.x + Gemini API + Hive

---

## 1. Tech Stack

| Layer | Technology | Why |
|-------|-----------|-----|
| Framework | Flutter 3.x (Dart) | Single codebase iOS + Android, rich animation support |
| AI | Gemini 2.0 Flash via REST API | Fast, cheap, instruction-following, great for conversation |
| Local Storage | Hive (NoSQL) | Fast, Flutter-native, no setup, works offline |
| State Management | Riverpod 2.x | Clean, testable, async-first |
| Voice Input | speech_to_text | Cross-platform, works offline |
| Voice Output | flutter_tts | Cross-platform text-to-speech |
| Charts | fl_chart | Beautiful, animated Flutter charts |
| Animations | flutter_animate | Declarative animation chaining |
| HTTP | dio | Interceptors, error handling, retry logic |
| Env Config | flutter_dotenv | Secure API key management |

---

## 2. Project Structure

```
nutrimind/
├── lib/
│   ├── main.dart                        ← App entry, Hive init, Riverpod scope
│   ├── app.dart                         ← MaterialApp, routes, theme
│   │
│   ├── core/
│   │   ├── constants/
│   │   │   ├── colors.dart              ← Color tokens
│   │   │   ├── typography.dart          ← TextStyles
│   │   │   └── strings.dart            ← Static text
│   │   ├── theme/
│   │   │   └── app_theme.dart          ← ThemeData (dark default)
│   │   ├── router/
│   │   │   └── app_router.dart         ← GoRouter routes
│   │   └── utils/
│   │       ├── date_utils.dart
│   │       └── context_builder.dart    ← Builds AI context string
│   │
│   ├── data/
│   │   ├── models/
│   │   │   ├── user_profile.dart       ← Hive model
│   │   │   ├── conversation.dart       ← Hive model
│   │   │   ├── message.dart            ← Hive model
│   │   │   ├── habit.dart              ← Hive model
│   │   │   ├── food_log_entry.dart     ← Hive model
│   │   │   └── app_state.dart          ← Hive model
│   │   ├── repositories/
│   │   │   ├── profile_repository.dart
│   │   │   ├── conversation_repository.dart
│   │   │   ├── habit_repository.dart
│   │   │   └── food_log_repository.dart
│   │   └── services/
│   │       ├── gemini_service.dart     ← All Gemini API calls
│   │       ├── voice_service.dart      ← STT + TTS wrapper
│   │       └── context_service.dart   ← Builds user context for AI
│   │
│   ├── providers/
│   │   ├── profile_provider.dart
│   │   ├── chat_provider.dart
│   │   ├── habit_provider.dart
│   │   ├── food_log_provider.dart
│   │   └── insights_provider.dart
│   │
│   └── ui/
│       ├── screens/
│       │   ├── splash/
│       │   │   └── splash_screen.dart
│       │   ├── onboarding/
│       │   │   ├── onboarding_screen.dart
│       │   │   ├── step_name.dart
│       │   │   ├── step_dietary.dart
│       │   │   └── step_goal.dart
│       │   ├── home/
│       │   │   ├── home_screen.dart
│       │   │   ├── widgets/
│       │   │   │   ├── wellness_score_card.dart
│       │   │   │   ├── daily_tip_card.dart
│       │   │   │   ├── quick_stats_row.dart
│       │   │   │   └── recent_activity_feed.dart
│       │   ├── chat/
│       │   │   ├── chat_screen.dart
│       │   │   ├── widgets/
│       │   │   │   ├── message_bubble.dart
│       │   │   │   ├── typing_indicator.dart
│       │   │   │   ├── voice_overlay.dart
│       │   │   │   ├── quick_prompt_chips.dart
│       │   │   │   └── chat_input_bar.dart
│       │   ├── checker/
│       │   │   ├── checker_screen.dart
│       │   │   └── widgets/
│       │   │       ├── ingredient_input.dart
│       │   │       ├── health_score_circle.dart
│       │   │       └── analysis_card.dart
│       │   ├── habits/
│       │   │   ├── habits_screen.dart
│       │   │   └── widgets/
│       │   │       ├── habit_card.dart
│       │   │       ├── streak_display.dart
│       │   │       └── habit_grid.dart
│       │   ├── insights/
│       │   │   ├── insights_screen.dart
│       │   │   └── widgets/
│       │   │       ├── weekly_bar_chart.dart
│       │   │       ├── wellness_trend_chart.dart
│       │   │       └── ai_weekly_summary.dart
│       │   ├── favourites/
│       │   │   └── favourites_screen.dart
│       │   ├── history/
│       │   │   └── history_screen.dart
│       │   └── profile/
│       │       └── profile_screen.dart
│       │
│       └── shared/
│           ├── widgets/
│           │   ├── bottom_nav.dart
│           │   ├── app_bar.dart
│           │   ├── loading_dots.dart
│           │   ├── animated_card.dart
│           │   └── gradient_button.dart
│           └── transitions/
│               └── slide_up_transition.dart
│
├── assets/
│   ├── fonts/                           ← Poppins, Inter
│   ├── images/
│   │   ├── splash_logo.png
│   │   └── onboarding/
│   └── animations/                     ← Lottie JSON files
│
├── .env                                ← GEMINI_API_KEY=
├── pubspec.yaml
└── README.md
```

---

## 3. pubspec.yaml Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter

  # AI & Networking
  dio: ^5.4.0
  flutter_dotenv: ^5.1.0

  # Local Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0

  # State Management
  flutter_riverpod: ^2.4.9
  riverpod_annotation: ^2.3.3

  # Voice
  speech_to_text: ^6.6.0
  flutter_tts: ^4.0.2
  permission_handler: ^11.3.0

  # Charts & Animations
  fl_chart: ^0.66.2
  flutter_animate: ^4.5.0
  confetti: ^0.7.0
  lottie: ^3.1.0

  # Navigation
  go_router: ^13.2.0

  # UI Utilities
  google_fonts: ^6.2.1
  shimmer: ^3.0.0
  cached_network_image: ^3.3.1
  intl: ^0.19.0
  uuid: ^4.3.3

dev_dependencies:
  hive_generator: ^2.0.1
  build_runner: ^2.4.8
  flutter_lints: ^3.0.0
```

---

## 4. Gemini Integration

### 4.1 API Call Structure

```dart
// lib/data/services/gemini_service.dart

class GeminiService {
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

  final Dio _dio;
  final String _apiKey;

  Future<String> sendMessage({
    required List<Map<String, dynamic>> messages,
    required String systemPrompt,
  }) async {
    final response = await _dio.post(
      '$_baseUrl?key=$_apiKey',
      data: {
        'system_instruction': {
          'parts': [{'text': systemPrompt}]
        },
        'contents': messages.map((m) => {
          'role': m['role'] == 'assistant' ? 'model' : 'user',
          'parts': [{'text': m['content']}]
        }).toList(),
        'generationConfig': {
          'temperature': 0.7,
          'maxOutputTokens': 800,
        }
      },
    );
    return response.data['candidates'][0]['content']['parts'][0]['text'];
  }
}
```

### 4.2 System Prompt with Context

```dart
// lib/data/services/context_service.dart

String buildSystemPrompt(UserProfile profile, List<Habit> habits,
    List<FoodLogEntry> recentMeals, List<Conversation> recentChats) {

  final habitSummary = habits
      .map((h) => '${h.title} (streak: ${h.currentStreak} days)')
      .join(', ');

  final recentMealSummary = recentMeals
      .take(5)
      .map((m) => '${m.mealName} on ${formatDate(m.date)}')
      .join(', ');

  final lastChatSummary = recentChats.isNotEmpty
      ? recentChats.last.summary
      : 'No previous conversations';

  return '''
You are Meera, a warm, knowledgeable, and empathetic Indian nutritionist.
You speak like a friendly expert — not clinical, not preachy.
You deeply understand Indian food culture: regional dishes, seasonal eating,
vegetarian nutrition, Indian dietary patterns, and busy Indian lifestyles.

USER PROFILE:
- Name: ${profile.name}
- Age: ${profile.age} | City: ${profile.city}
- Dietary preference: ${profile.dietary}
- Allergies: ${profile.allergies.join(', ') ?? 'None'}
- Health goal: ${profile.healthGoal}

CURRENT HABITS (being tracked):
$habitSummary

RECENT MEALS CHECKED:
$recentMealSummary

LAST CONVERSATION SUMMARY:
$lastChatSummary

YOUR RULES:
- Always address user by name occasionally — makes it personal
- Give specific, actionable advice — not generic platitudes
- Understand Indian food: dal, roti, sabzi, chawal, poha, upma etc.
- Never recommend extreme diets or anything medically dangerous
- If user seems emotionally stressed about food, respond with empathy first
- Keep responses concise — 3-5 sentences max unless asked for detail
- Suggest small habit improvements based on what you know about this user
- For DIY meal checks: give a score 0-100 and explain why

Always remember: you know this user. Reference their habits and recent meals naturally.
''';
}
```

---

## 5. Voice Service

```dart
// lib/data/services/voice_service.dart

class VoiceService {
  final SpeechToText _stt = SpeechToText();
  final FlutterTts _tts = FlutterTts();
  bool _voiceModeActive = false;

  Future<void> initialize() async {
    await _stt.initialize();
    await _tts.setLanguage('en-IN');
    await _tts.setSpeechRate(0.5);
    await _tts.setPitch(1.0);
  }

  Future<String> listen() async {
    String result = '';
    await _stt.listen(
      onResult: (val) => result = val.recognizedWords,
      localeId: 'en_IN',
    );
    return result;
  }

  Future<void> speak(String text) async {
    // Strip markdown before speaking
    final clean = text.replaceAll(RegExp(r'[*_#`]'), '');
    await _tts.speak(clean);
  }

  void setVoiceMode(bool active) => _voiceModeActive = active;
  bool get isVoiceModeActive => _voiceModeActive;
}
```

---

## 6. Hive Models

```dart
// User Profile Model
@HiveType(typeId: 0)
class UserProfile extends HiveObject {
  @HiveField(0) String name;
  @HiveField(1) int age;
  @HiveField(2) String city;
  @HiveField(3) String dietary;       // vegetarian/non-veg/vegan/jain
  @HiveField(4) List<String> allergies;
  @HiveField(5) String healthGoal;    // lose weight/maintain/gain muscle/eat healthy
  @HiveField(6) bool onboardingDone;
}

// Habit Model
@HiveType(typeId: 2)
class Habit extends HiveObject {
  @HiveField(0) String id;
  @HiveField(1) String title;
  @HiveField(2) String category;     // eating/hydration/timing/mindfulness
  @HiveField(3) String icon;         // emoji
  @HiveField(4) DateTime createdAt;
  @HiveField(5) List<DateTime> completions;

  int get currentStreak {
    // Calculate streak from completions
    if (completions.isEmpty) return 0;
    int streak = 0;
    DateTime check = DateTime.now();
    for (int i = 0; i < 60; i++) {
      final day = DateTime(check.year, check.month, check.day - i);
      if (completions.any((c) =>
          c.year == day.year && c.month == day.month && c.day == day.day)) {
        streak++;
      } else if (i > 0) break;
    }
    return streak;
  }

  bool get completedToday {
    final today = DateTime.now();
    return completions.any((c) =>
        c.year == today.year && c.month == today.month && c.day == today.day);
  }
}

// Food Log Entry
@HiveType(typeId: 3)
class FoodLogEntry extends HiveObject {
  @HiveField(0) String id;
  @HiveField(1) String mealName;
  @HiveField(2) List<String> ingredients;
  @HiveField(3) int healthScore;      // 0-100
  @HiveField(4) String aiAnalysis;
  @HiveField(5) DateTime date;
  @HiveField(6) List<String> tags;
  @HiveField(7) bool isFavourite;
}
```

---

## 7. Key Widget Specs

### Wellness Score Card
- Circular animated progress indicator (AnimatedCircularChart or custom painter)
- Score animates from 0 to value on widget load
- Color: green > 70, orange 40-70, red < 40
- Pulsing glow effect on the circle

### Voice Overlay
- Full-screen dark overlay with 50% opacity
- Central animated waveform (custom painter, sine wave animation)
- Pulsing green circle behind waveform
- "Listening..." text with animated dots
- Tap anywhere to stop listening

### Habit Card
- Swipeable card (Dismissible widget)
- Tap to complete — shows confetti burst
- Streak flame emoji with count
- Background changes from Surface2 to green-tinted when complete
- Subtle shimmer animation on incomplete habits

### Chat Message Bubble
- User: right-aligned, primary green background
- Meera: left-aligned, Surface2 background, Meera avatar (🌿 emoji in circle)
- Slide-in animation: user bubbles from right, Meera from left
- Fade + scale animation on appear
- Timestamp shown on long press

### DIY Checker Analysis Card
- Animated score circle fills up on result load
- Nutrient tags: protein (blue), carbs (orange), fibre (green), fat (yellow)
- Warning badges for red flags (high sugar, no protein etc.)
- "Save to Favourites" button with heart animation

---

## 8. Performance Requirements

- Cold start: < 2 seconds
- Gemini API response: displayed within 3 seconds (show typing indicator)
- Chart render: < 500ms
- Local data read: < 100ms (Hive is in-memory)
- Animations: locked to 60fps
- Voice recognition: starts within 500ms of tap

---

## 9. Offline Behaviour

| Feature | Offline behaviour |
|---------|------------------|
| Home dashboard | Fully functional (all data local) |
| Habit tracker | Fully functional |
| History/Insights | Fully functional |
| AI Chat | Show "No internet — check connection" toast |
| DIY Checker | Show "AI analysis needs internet" message |
| Voice input | STT still works offline (device-level) |
| Voice output | TTS works offline |

---

## 10. Security

- Gemini API key stored in `.env`, never hardcoded
- All user data stored locally — no server, no data breach risk
- No account/login — reduces friction and privacy concerns
- `.env` file listed in `.gitignore`
