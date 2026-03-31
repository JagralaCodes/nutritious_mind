import 'package:get/get.dart';
import '../../ui/screens/splash/splash_screen.dart';
import '../../ui/screens/onboarding/onboarding_screen.dart';
import '../../ui/screens/home/home_screen.dart';
import '../../ui/screens/chat/chat_screen.dart';
import '../../ui/screens/checker/checker_screen.dart';
import '../../ui/screens/habits/habits_screen.dart';
import '../../ui/screens/insights/insights_screen.dart';
import '../../ui/screens/favourites/favourites_screen.dart';
import '../../ui/screens/history/history_screen.dart';
import '../../ui/screens/profile/profile_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboard';
  static const home = '/home';
  static const chat = '/chat';
  static const checker = '/checker';
  static const habits = '/habits';
  static const insights = '/insights';
  static const favourites = '/favourites';
  static const history = '/history';
  static const profile = '/profile';

  static final pages = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: onboarding, page: () => const OnboardingScreen()),
    GetPage(name: home, page: () => const HomeScreen()),
    GetPage(name: chat, page: () => const ChatScreen()),
    GetPage(name: checker, page: () => const CheckerScreen()),
    GetPage(name: habits, page: () => const HabitsScreen()),
    GetPage(name: insights, page: () => const InsightsScreen()),
    GetPage(name: favourites, page: () => const FavouritesScreen()),
    GetPage(name: history, page: () => const HistoryScreen()),
    GetPage(name: profile, page: () => const ProfileScreen()),
  ];
}
