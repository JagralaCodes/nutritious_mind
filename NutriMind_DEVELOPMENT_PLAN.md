# NutriMind — Development Plan & Build TODO
**For use with Google Antigravity + Claude Code + Stitch**
**Build this in order. Complete each phase fully before moving to the next.**

---

## Build Strategy

- **Antigravity:** Use for autonomous code generation — feed it the PRD + TRD + this file as context
- **Stitch:** Use for UI design/prototyping of key screens before coding
- **Claude Code:** Use for complex logic — context builder, Gemini service, Hive models

---

## PHASE 0 — Project Setup

- [ ] Run `flutter create nutrimind --org com.nutrimind` and open in Antigravity
- [ ] Add all dependencies to `pubspec.yaml` (see TRD section 3)
- [ ] Run `flutter pub get` — verify zero errors
- [ ] Create `.env` file in root: `GEMINI_API_KEY=your_key_here`
- [ ] Add `.env` to `.gitignore`
- [ ] Add `assets/fonts/`, `assets/images/`, `assets/animations/` directories to `pubspec.yaml`
- [ ] Download and add Poppins + Inter fonts from Google Fonts to `assets/fonts/`
- [ ] Create folder structure exactly as defined in TRD section 2
- [ ] Run `flutter run` — verify blank app launches on device/emulator

---

## PHASE 1 — Core, Theme & Constants

- [ ] Create `lib/core/constants/colors.dart` — define all color tokens from PRD section 9
- [ ] Create `lib/core/constants/typography.dart` — define TextStyles using Poppins + Inter
- [ ] Create `lib/core/theme/app_theme.dart` — build full dark ThemeData using color tokens
- [ ] Apply theme in `lib/app.dart` — MaterialApp with theme and darkTheme both set to dark
- [ ] Create `lib/core/router/app_router.dart` — GoRouter with all routes: `/`, `/onboard`, `/home`, `/chat`, `/checker`, `/habits`, `/insights`, `/favourites`, `/history`, `/profile`
- [ ] Implement route guard: if `onboardingDone == false` redirect to `/onboard`, else `/home`
- [ ] Create `lib/core/utils/date_utils.dart` — helper functions: `formatDate()`, `isToday()`, `daysBetween()`, `getWeekDates()`

---

## PHASE 2 — Hive Data Layer

- [ ] Create `lib/data/models/user_profile.dart` — HiveType(typeId: 0), all fields from TRD section 6
- [ ] Create `lib/data/models/message.dart` — HiveType(typeId: 1): id, role, content, timestamp
- [ ] Create `lib/data/models/habit.dart` — HiveType(typeId: 2), include `currentStreak` and `completedToday` computed getters
- [ ] Create `lib/data/models/food_log_entry.dart` — HiveType(typeId: 3), all fields including isFavourite
- [ ] Create `lib/data/models/conversation.dart` — HiveType(typeId: 4): id, messages[], summary, date
- [ ] Create `lib/data/models/app_state_model.dart` — HiveType(typeId: 5): weeklyScores, totalMeals, etc.
- [ ] Run `flutter pub run build_runner build` — generate all Hive adapters
- [ ] Create `lib/data/repositories/profile_repository.dart` — getProfile(), saveProfile(), updateField()
- [ ] Create `lib/data/repositories/habit_repository.dart` — getHabits(), addHabit(), completeHabit(id), deleteHabit(id), getCompletionsThisWeek()
- [ ] Create `lib/data/repositories/food_log_repository.dart` — addEntry(), getAll(), getFavourites(), toggleFavourite(id), getThisWeek()
- [ ] Create `lib/data/repositories/conversation_repository.dart` — addConversation(), getAll(), getLast(n), deleteConversation(id)
- [ ] Initialize all Hive boxes in `main.dart` before runApp()

---

## PHASE 3 — Services

- [ ] Create `lib/data/services/gemini_service.dart` — implement `sendMessage({messages, systemPrompt})` using Dio, error handling, retry once on timeout
- [ ] In GeminiService: implement `analyzeIngredients(List<String> ingredients, String userContext)` — returns structured analysis with score
- [ ] In GeminiService: implement `generateHabits(UserProfile profile)` — returns List<String> of 5 personalised habit suggestions
- [ ] In GeminiService: implement `generateWeeklySummary(context)` — returns 2-sentence weekly insight
- [ ] In GeminiService: implement `generateDailyTip(context)` — returns single tip string
- [ ] Create `lib/data/services/context_service.dart` — implement `buildSystemPrompt(profile, habits, recentMeals, recentChats)` from TRD section 4.2
- [ ] In ContextService: implement `buildShortContext()` — shorter version for DIY checker
- [ ] Create `lib/data/services/voice_service.dart` — implement `initialize()`, `listen()`, `speak(text)`, `stopListening()`, `stopSpeaking()`
- [ ] In VoiceService: request microphone permission via permission_handler on first voice use
- [ ] Create `lib/core/utils/context_builder.dart` — utility that calls ContextService and formats the full context string

---

## PHASE 4 — Riverpod Providers

- [ ] Create `lib/providers/profile_provider.dart` — StateNotifierProvider wrapping ProfileRepository
- [ ] Create `lib/providers/chat_provider.dart` — StateNotifierProvider with: messages[], isLoading, isVoiceMode, lastInputWasVoice — methods: sendMessage(), toggleVoiceMode(), clearChat()
- [ ] Create `lib/providers/habit_provider.dart` — StateNotifierProvider: habits[], completeHabit(), addHabit(), deleteHabit(), getTodayCompletionRate()
- [ ] Create `lib/providers/food_log_provider.dart` — StateNotifierProvider: entries[], analyzeIngredients(), toggleFavourite()
- [ ] Create `lib/providers/insights_provider.dart` — FutureProvider: weekly chart data, wellness trend, AI summary

---

## PHASE 5 — Splash & Onboarding

- [ ] Create `splash_screen.dart` — animated logo (scale + fade in), Poppins "NutriMind" text, green glow, 2 second delay then navigate
- [ ] Create `onboarding_screen.dart` — PageView with 3 steps, dot indicators, skip button, next button
- [ ] Create `step_name.dart` — name + age input with keyboard, validation, animated entrance
- [ ] Create `step_dietary.dart` — grid of dietary preference cards (Vegetarian, Non-Veg, Vegan, Jain) with icon + tap-to-select highlight animation
- [ ] Create `step_goal.dart` — 4 health goal cards (Lose Weight, Maintain, Gain Muscle, Eat Healthy), animated selection
- [ ] On onboarding complete: save profile to Hive, call `generateHabits()` to create initial habits, set `onboardingDone = true`, navigate to `/home`

---

## PHASE 6 — Home Dashboard

- [ ] Create `home_screen.dart` — scaffold with scroll view, staggered animation on load
- [ ] Create `wellness_score_card.dart` — large card with animated circular score (CustomPainter or percent_indicator), greeting text changes by time of day ("Good morning Priya" / "Good evening Priya"), score animates 0 → value on widget appear
- [ ] Create `daily_tip_card.dart` — loads AI-generated tip on mount, shimmer while loading, green left border accent, lightbulb emoji
- [ ] Create `quick_stats_row.dart` — 3 mini cards: 🔥 Streak, 🥗 Meals this week, ✅ Habits today — each with flutter_animate slide-up with delay
- [ ] Create `recent_activity_feed.dart` — last 3 activities (habit check-in, meal logged, chat) with time-ago text
- [ ] Add bottom navigation bar with 5 tabs: Home, Chat, Check, Habits, Insights — animated active indicator
- [ ] Add floating action button on home for quick "Ask Meera" shortcut

---

## PHASE 7 — AI Chat Screen

- [ ] Create `chat_screen.dart` — full screen, dark bg, messages ListView with reverse:false, auto-scroll to bottom on new message
- [ ] Create `message_bubble.dart` — user bubble (right, green), Meera bubble (left, Surface2, 🌿 avatar) — slide + fade animation on appear
- [ ] Create `typing_indicator.dart` — three dots bouncing animation, shown while loading
- [ ] Create `quick_prompt_chips.dart` — shown only when messages is empty, horizontal scroll of suggestion chips: "What should I eat for lunch?", "Is my breakfast healthy?", "Give me a light dinner idea", "How am I doing this week?", "Suggest a healthy snack"
- [ ] Create `chat_input_bar.dart` — text field, send button (arrow icon), mic button — mic pulses red while listening
- [ ] Create `voice_overlay.dart` — full screen overlay, animated waveform CustomPainter, "Listening..." text, tap to stop
- [ ] In chat screen: show voice toggle in AppBar — when tapped, show voice overlay
- [ ] Wire up voice: tap mic → start listening → auto-send transcript → if lastInputWasVoice → speak response
- [ ] Add conversation save: when user navigates away, save conversation to Hive with AI-generated summary

---

## PHASE 8 — DIY Food Checker

- [ ] Create `checker_screen.dart` — two states: INPUT state and RESULT state
- [ ] Create `ingredient_input.dart` — text field for ingredient entry, chip tags showing added ingredients, "Add" button, example placeholder "e.g. dal, rice, ghee, spinach"
- [ ] Add minimum 2 ingredients validation before enabling Analyze button
- [ ] Create `health_score_circle.dart` — large animated circle score (0-100), color coded: green/orange/red, animates fill when result loads, Poppins Bold score number in center
- [ ] Create `analysis_card.dart` — shows AI analysis text, nutrient tag chips (Protein ✓, Fibre ✓, Iron ⚠️), suggestions list with ✨ prefix
- [ ] On successful analysis: auto-save to food log with all data
- [ ] Add "Save to Favourites" heart button — tap triggers confetti + fill animation
- [ ] Add "Analyse Again" button to reset to INPUT state
- [ ] Parse Gemini response: expect score on first line as "SCORE:75", rest is analysis text — if parse fails, show fallback UI

---

## PHASE 9 — Habit Tracker

- [ ] Create `habits_screen.dart` — two sections: Today's Habits, All Habits (weekly grid)
- [ ] Create `habit_card.dart` — gradient card, emoji icon, habit title, streak 🔥 count, large circular checkbox — tap checkbox triggers completion animation
- [ ] Completion animation: card flashes green, confetti burst from checkbox position, checkmark animates in
- [ ] Create `streak_display.dart` — flame emoji with animated scale pulse, streak count in Poppins Bold
- [ ] Create `habit_grid.dart` — GitHub-style 7×n grid, each cell is a colored dot (green = completed, gray = missed, lighter gray = future), shows last 4 weeks per habit
- [ ] Add "Add Habit" FAB — bottom sheet with title input, category selector, icon emoji picker
- [ ] Add swipe-to-delete on habit cards with confirmation
- [ ] At top of screen: show today's completion rate "3/5 habits done" with animated progress bar

---

## PHASE 10 — Insights Screen

- [ ] Create `insights_screen.dart` — scrollable screen with cards
- [ ] Create `weekly_bar_chart.dart` — fl_chart BarChart showing meals checked + habits completed per day for last 7 days, animate bars on first load, custom tooltip
- [ ] Create `wellness_trend_chart.dart` — fl_chart LineChart showing weekly wellness score for last 4 weeks, gradient fill under line, animated draw-on effect
- [ ] Create `ai_weekly_summary.dart` — card that loads AI-generated 2-sentence weekly summary, shimmer while loading, purple accent border
- [ ] Add streak records section — personal bests for each habit
- [ ] Add "Total meals analysed" and "Total conversations" counters with large Poppins numbers

---

## PHASE 11 — Favourites & History

- [ ] Create `favourites_screen.dart` — GridView of saved meals, each card shows meal name, health score badge, date saved, ingredient tags
- [ ] On tap: navigate to a detail view showing full analysis + ingredients + option to re-analyse
- [ ] Add empty state illustration when no favourites yet
- [ ] Create `history_screen.dart` — TabBar with two tabs: Conversations | Meal Log
- [ ] Conversations tab: list of past chats with date, first message preview, tap to expand full conversation
- [ ] Meal Log tab: chronological list of DIY checker entries with health score badge and meal name
- [ ] Add pull-to-refresh on both tabs
- [ ] Add search bar to filter history by keyword

---

## PHASE 12 — Profile Screen

- [ ] Create `profile_screen.dart` — edit name, age, dietary pref, health goal, allergies
- [ ] Show "NutriMind knows you" section — list of context items the AI currently knows about user
- [ ] Add "Reset all data" option with confirmation dialog
- [ ] Show app version and "Built for AMD Slingshot" credit

---

## PHASE 13 — Polish & Demo Prep

- [ ] Add page transition animations — all routes use `SlideUpTransition`
- [ ] Add loading shimmer on all screens that fetch from Hive or API
- [ ] Add error states for all API calls — red snackbar with retry option
- [ ] Test full onboarding flow → home → chat → DIY checker → habit check-in → insights
- [ ] Test voice mode: tap mic, speak, verify transcript + spoken response
- [ ] Test offline: turn off WiFi, verify home/habits/insights still work, chat shows graceful error
- [ ] Verify Hive data persists across app restarts
- [ ] Test on both Android and iOS if possible (or at least Android emulator)
- [ ] Pre-populate demo data: create 1 user profile, 5 habits with streaks, 5 food log entries, 2 past conversations
- [ ] Record a demo video or have the live demo flow ready (see PRD demo script)

---

## Demo Flow for Judges (3 minutes)

1. **Open app** → splash animation → home dashboard with wellness score and today's tip
2. **Chat tab** → show quick prompt chips → tap "How am I doing this week?" → Meera responds with personalised insight mentioning name and recent habits
3. **Voice mode** → tap mic icon → speak "What should I have for dinner tonight?" → show Meera's spoken response
4. **DIY Checker** → type ingredients "dal, chawal, ghee, haldi, jeera" → tap Analyze → show score + analysis + suggestions
5. **Habits tab** → tap to complete a habit → confetti → show streak update
6. **Insights tab** → show weekly chart + AI summary
7. **Say to judges:** *"Every time Meera responds, she already knows Priya's last 3 meals, her habit streaks, her health goal, and her dietary preferences — stored entirely on device. No server. No account. Pure contextual intelligence."*
