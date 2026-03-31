import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/typography.dart';
import '../../../core/router/app_router.dart';
import '../../../data/models/user_profile.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    final box = Hive.box<UserProfile>('user_profile');
    final profile = box.get('profile');
    if (profile != null && profile.onboardingDone) {
      Get.offAllNamed(AppRoutes.home);
    } else {
      Get.offAllNamed(AppRoutes.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(Icons.eco_rounded, color: Colors.white, size: 42),
            )
                .animate()
                .scale(begin: const Offset(0.5, 0.5), duration: 600.ms, curve: Curves.easeOutBack)
                .fadeIn(duration: 400.ms),
            const SizedBox(height: 24),
            Text('NutriMind', style: AppTypography.display.copyWith(color: AppColors.primary))
                .animate()
                .fadeIn(delay: 300.ms, duration: 500.ms)
                .slideY(begin: 0.3, duration: 500.ms),
            const SizedBox(height: 8),
            Text('Your AI Food Intelligence', style: AppTypography.bodySmall)
                .animate()
                .fadeIn(delay: 600.ms, duration: 500.ms),
          ],
        ),
      ),
    );
  }
}
