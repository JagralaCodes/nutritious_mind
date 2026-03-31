# NutriMind — Product Requirements Document
**Version:** 1.0 | **Platform:** Flutter (iOS + Android) | **Event:** AMD Slingshot Regional Ideathon
**Challenge Statement:** Design a smart solution that helps individuals make better food choices and build healthier eating habits by leveraging available data, user behaviour, and contextual inputs.

---

## 1. Executive Summary

NutriMind is an AI-powered personal food intelligence app for health-conscious Indians. It combines a conversational AI food advisor, a DIY meal health checker, a smart habit tracker, and a personalised weekly dashboard — all powered by Gemini and stored locally on the device.

The app learns from every conversation, meal log, and habit check-in to build a rich contextual profile of the user. This context is injected into every AI interaction, making the AI feel like a personal nutritionist who genuinely knows you — not a generic chatbot.

**Why it wins the challenge:** It directly addresses all three pillars — better food choices (AI advisor + DIY checker), healthier habits (habit tracker + nudges), and contextual intelligence (local context engine that grows smarter over time).

---

## 2. Problem Statement

Health-conscious Indians face a fragmented problem:

- **No personalised guidance** — generic diet apps don't understand Indian food culture, regional dishes, or Indian dietary patterns (vegetarian, Jain, sattvic, etc.)
- **No accountability** — people know what to eat but don't track or stay consistent
- **No food intelligence at the point of cooking** — people making food at home have no way to quickly assess if what they're preparing is nutritionally balanced
- **No conversational interface** — existing apps are form-based and rigid, not conversational
- **Context amnesia** — every interaction with a health app starts from scratch; it never remembers your preferences, allergies, or past patterns

---

## 3. Solution Overview

```
┌─────────────────────────────────────────────────────────────┐
│                        NutriMind                            │
├──────────────┬──────────────┬─────────────┬────────────────┤
│   HOME       │   AI CHAT    │   TRACKER   │   INSIGHTS     │
│  Dashboard   │  + Voice     │  + Habits   │  + History     │
│              │              │             │                 │
│ Weekly score │ Gemini AI    │ Daily goals │ Weekly charts  │
│ Quick stats  │ Voice input  │ Streak      │ Favourites     │
│ Today's tips │ DIY checker  │ Reminders   │ Food log       │
└──────────────┴──────────────┴─────────────┴────────────────┘
                        │
              Local Context Engine
              (SharedPreferences / Hive)
                        │
        ┌───────────────┴───────────────┐
        │    User Profile + History     │
        │    Conversation Memory        │
        │    Habit Log                  │
        │    Favourites                 │
        └───────────────────────────────┘
```

---

## 4. User Persona

**Priya, 26 — Ahmedabad, Gujarat**
- Works in IT, busy lifestyle, eats home food + office canteen
- Vegetarian, no specific diet plan, wants to "eat healthier"
- Has tried MyFitnessPal — found it too tedious (too much manual input)
- Wants an app she can just *talk to* and get intelligent suggestions
- Pain points: late-night snacking, skipping breakfast, emotional eating

**What NutriMind gives her:**
- Conversational AI she can ask "is my dal-rice lunch okay?" while cooking
- A habit tracker that tracks her breakfast streak
- Weekly dashboard showing her patterns without manual calorie counting
- Voice mode so she can ask questions while cooking without touching phone

---

## 5. Core Features

### 5.1 Home Dashboard (P0)
- **Wellness score** — AI-computed weekly score (0–100) based on habit check-ins and food conversations
- **Today's contextual tip** — single AI-generated tip based on user's recent patterns
- **Quick stats row** — streak, meals logged this week, habits completed today
- **Recent activity feed** — last 3 conversations + habit check-ins
- **Quick action buttons** — "Ask AI", "Check my meal", "Log habit"
- **Greeting with user name** — changes based on time of day

### 5.2 AI Chat + Voice Advisor (P0)
- **Conversational interface** — chat bubbles, typing indicator, smooth scroll
- **Full context injection** — every Gemini call includes user profile + last 20 conversations
- **Voice input** — speech_to_text Flutter package
- **Voice output** — flutter_tts package, auto-speak when voice mode active
- **Auto-detect voice mode** — if last input was voice, response is spoken
- **Conversation history** — stored in Hive, last 50 conversations persisted
- **Suggested quick prompts** — chips shown when chat is empty ("What should I eat for lunch?", "Is my breakfast healthy?", "Give me a light dinner idea")
- **Message types** — text, voice, system (context updates)
- **AI persona** — "Meera", a warm Indian nutritionist who understands Indian food

### 5.3 DIY Food Checker (P0)
- **Ingredient input** — user types what they are cooking with
- **Real-time AI analysis** — Gemini evaluates nutritional balance, missing nutrients, warnings
- **Visual health score** — circular progress indicator (0–100)
- **Detailed breakdown** — proteins, carbs, fats, fibre assessment (qualitative, not calorie-counted)
- **Suggestions** — "Add a handful of spinach to increase iron"
- **Save to favourites** — save a meal combination they like
- **Indian food intelligence** — understands dal-chawal, roti-sabzi, poha, upma etc.

### 5.4 Habit Tracker (P0)
- **AI-generated habits** — on first use, Meera asks 3 questions and generates 5 personalised habits
- **Daily habit cards** — swipeable cards with checkbox completion
- **Streak counter** — fire emoji streak per habit
- **Weekly grid view** — GitHub-style contribution graph per habit
- **Habit categories** — Eating, Hydration, Timing, Mindfulness
- **Gentle nudge system** — AI-generated encouragement messages on check-in
- **Edit/add habits** — user can customise habit list

### 5.5 Favourites & Saved Meals (P1)
- **Save from DIY checker** — one-tap save of any meal analysis
- **Save from AI chat** — save any AI food suggestion
- **Favourites grid** — card view with meal name, health score badge, saved date
- **Quick re-analyse** — tap favourite to re-run AI analysis
- **Tags** — breakfast, lunch, dinner, snack

### 5.6 History & Insights (P0)
- **Weekly chart** — bar chart of meals checked / habits completed per day (fl_chart)
- **Wellness trend** — line chart of weekly wellness score over last 4 weeks
- **Top patterns** — AI-generated weekly summary ("You've been skipping breakfast 4 days this week")
- **Conversation history** — scrollable log of all past AI chats
- **Food log** — list of all meals checked via DIY checker

---

## 6. AI Context Engine — The Core Differentiator

Every Gemini API call includes a dynamically built context block from local storage:

```
USER CONTEXT:
- Name: Priya | Age: 26 | City: Ahmedabad
- Dietary: Vegetarian | Allergies: None | Health goal: Lose weight
- Active habits: Eat breakfast daily, Drink 8 glasses water, No sugar after 8pm
- Current streaks: Breakfast (5 days), Water (2 days)
- This week: 4 meals checked, 3/5 habits maintained
- Recent meals: Poha (Monday), Dal Rice (Tuesday), Vada Pav (Wednesday - flagged unhealthy)
- Last conversation summary: Asked about healthy snacks for office
- Favourite meals: Moong Dal Chilla, Oats Upma, Fruit Salad
```

This makes Meera feel like she genuinely knows Priya — not a fresh chatbot every session.

---

## 7. Screens List

| Screen | Route | Description |
|--------|-------|-------------|
| Splash | `/` | Animated logo, loads context |
| Onboarding (3 slides) | `/onboard` | Name, dietary pref, health goal |
| Home Dashboard | `/home` | Main tab |
| AI Chat | `/chat` | Full screen chat with Meera |
| Voice Mode | `/chat` (overlay) | Voice UI overlay on chat |
| DIY Checker | `/checker` | Ingredient input + analysis |
| Habit Tracker | `/habits` | Daily habits + streaks |
| Insights | `/insights` | Charts + weekly summary |
| Favourites | `/favourites` | Saved meals grid |
| History | `/history` | Conversation + meal log |
| Profile & Settings | `/profile` | Edit user context |

---

## 8. Local Storage Schema (Hive)

```
Box: user_profile
  - name: String
  - age: int
  - city: String
  - dietary: String (vegetarian/non-veg/vegan/jain)
  - allergies: List<String>
  - healthGoal: String
  - onboardingDone: bool

Box: conversations
  - id: String (timestamp)
  - messages: List<Map> [{role, content, timestamp}]
  - summary: String (AI-generated summary of this chat)
  - date: DateTime

Box: habits
  - id: String
  - title: String
  - category: String
  - icon: String
  - createdAt: DateTime
  - completions: List<DateTime> (dates when completed)

Box: food_log
  - id: String
  - mealName: String
  - ingredients: List<String>
  - healthScore: int
  - aiAnalysis: String
  - date: DateTime
  - tags: List<String>
  - isFavourite: bool

Box: app_state
  - lastContextUpdate: DateTime
  - weeklyWellnessScores: List<int>
  - totalMealsChecked: int
  - longestStreak: int
```

---

## 9. Design System

### Colors
| Token | Value | Usage |
|-------|-------|-------|
| Primary | `#1DB954` (fresh green) | CTAs, active states |
| Primary Dark | `#158A3E` | Pressed states |
| Surface | `#0A0A0A` | Dark mode background |
| Surface 2 | `#1A1A1A` | Cards |
| Surface 3 | `#2A2A2A` | Input fields |
| Text Primary | `#FFFFFF` | Headings |
| Text Secondary | `#A0A0A0` | Subtitles |
| Accent Orange | `#FF6B35` | Warnings, calories |
| Accent Blue | `#4FC3F7` | Info, insights |
| Accent Purple | `#CE93D8` | Habits, streaks |

### Typography
- Display: `Poppins` (Bold 700) — headings
- Body: `Inter` (Regular 400, Medium 500) — body text
- Mono: `JetBrains Mono` — scores, numbers

### Animations
- Page transitions: `slide_up` with fade
- Chat bubbles: slide in from side + fade
- Habit completion: confetti burst (confetti_flutter)
- Score circle: animated fill on load
- Voice: ripple pulse animation while listening
- Dashboard cards: staggered slide-up on load

---

## 10. Theme Statement for Judges

> *"NutriMind is not a calorie counter. It's a contextual food intelligence system. Every time you talk to Meera — our AI nutritionist — she already knows your last 3 meals, your active habits, your health goal, and your food preferences. She's not starting from scratch. That's the difference."*

---

## 11. AMD Slingshot Theme Fit

- **Primary:** AI in Consumer Experiences — AI-powered personal health assistant
- **Secondary:** Generative AI for Everyone — conversational AI accessible to non-technical users in vernacular contexts
