class AppStrings {
  AppStrings._();

  static const String appName = 'NutriMind';
  static const String tagline = 'Your AI Food Intelligence';

  // Onboarding
  static const String onboardingTitle1 = "What's your name?";
  static const String onboardingTitle2 = 'Dietary Preference';
  static const String onboardingTitle3 = 'Your Health Goal';

  // Dietary options
  static const List<String> dietaryOptions = [
    'Vegetarian',
    'Non-Veg',
    'Vegan',
    'Jain',
  ];

  // Health goals
  static const List<String> healthGoals = [
    'Lose Weight',
    'Maintain Weight',
    'Gain Muscle',
    'Eat Healthy',
  ];

  // Quick prompts
  static const List<String> quickPrompts = [
    'What should I eat for lunch?',
    'Is my breakfast healthy?',
    'Give me a light dinner idea',
    'How am I doing this week?',
    'Suggest a healthy snack',
  ];

  // Errors
  static const String noInternet = 'No internet — check your connection';
  static const String genericError = 'Something went wrong. Try again.';
  static const String aiNeedsInternet = 'AI analysis needs internet';
}
