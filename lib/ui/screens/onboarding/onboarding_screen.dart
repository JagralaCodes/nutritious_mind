import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/typography.dart';
import '../../../core/router/app_router.dart';
import '../../../data/models/user_profile.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _cityController = TextEditingController();
  String _selectedDietary = '';
  String _selectedGoal = '';

  final _dietaryOptions = [
    {'label': 'Vegetarian', 'icon': Icons.eco},
    {'label': 'Non-Veg', 'icon': Icons.restaurant},
    {'label': 'Vegan', 'icon': Icons.grass},
    {'label': 'Jain', 'icon': Icons.spa},
  ];

  final _goalOptions = [
    {'label': 'Lose Weight', 'icon': Icons.trending_down},
    {'label': 'Maintain Weight', 'icon': Icons.balance},
    {'label': 'Gain Muscle', 'icon': Icons.fitness_center},
    {'label': 'Eat Healthy', 'icon': Icons.favorite},
  ];

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(duration: 400.ms, curve: Curves.easeInOut);
    } else {
      _saveAndProceed();
    }
  }

  Future<void> _saveAndProceed() async {
    final box = Hive.box<UserProfile>('user_profile');
    final profile = UserProfile(
      name: _nameController.text.trim(),
      age: int.tryParse(_ageController.text) ?? 25,
      city: _cityController.text.trim().isEmpty ? 'India' : _cityController.text.trim(),
      dietary: _selectedDietary.isEmpty ? 'Vegetarian' : _selectedDietary,
      healthGoal: _selectedGoal.isEmpty ? 'Eat Healthy' : _selectedGoal,
      onboardingDone: true,
    );
    await box.put('profile', profile);
    Get.offAllNamed(AppRoutes.home);
  }

  bool get _canProceed {
    switch (_currentPage) {
      case 0:
        return _nameController.text.trim().isNotEmpty;
      case 1:
        return _selectedDietary.isNotEmpty;
      case 2:
        return _selectedGoal.isNotEmpty;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Progress dots
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) => Container(
                  width: i == _currentPage ? 32 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: i == _currentPage ? AppColors.primary : AppColors.surface3,
                    borderRadius: BorderRadius.circular(4),
                  ),
                )),
              ),
            ),
            // Pages
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _currentPage = i),
                children: [_buildNamePage(), _buildDietaryPage(), _buildGoalPage()],
              ),
            ),
            // Button
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: _canProceed ? _nextPage : null,
                child: Text(_currentPage == 2 ? 'Get Started' : 'Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNamePage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text("What's your name?", style: AppTypography.heading1)
              .animate().fadeIn(duration: 400.ms).slideY(begin: 0.3),
          const SizedBox(height: 8),
          Text('Let Meera know who she\'s talking to', style: AppTypography.bodySmall)
              .animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 32),
          TextField(
            controller: _nameController,
            style: AppTypography.bodyLarge,
            decoration: const InputDecoration(hintText: 'Your name'),
            onChanged: (_) => setState(() {}),
          ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),
          const SizedBox(height: 16),
          TextField(
            controller: _ageController,
            style: AppTypography.bodyLarge,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: 'Age'),
            onChanged: (_) => setState(() {}),
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
          const SizedBox(height: 16),
          TextField(
            controller: _cityController,
            style: AppTypography.bodyLarge,
            decoration: const InputDecoration(hintText: 'City (optional)'),
          ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2),
        ],
      ),
    );
  }

  Widget _buildDietaryPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text('Dietary Preference', style: AppTypography.heading1)
              .animate().fadeIn(duration: 400.ms).slideY(begin: 0.3),
          const SizedBox(height: 8),
          Text('This helps Meera suggest the right foods', style: AppTypography.bodySmall)
              .animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 32),
          ...List.generate(_dietaryOptions.length, (i) {
            final opt = _dietaryOptions[i];
            final selected = _selectedDietary == opt['label'];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () => setState(() => _selectedDietary = opt['label'] as String),
                child: AnimatedContainer(
                  duration: 200.ms,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primary.withValues(alpha: 0.15) : AppColors.surface2,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: selected ? AppColors.primary : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(opt['icon'] as IconData, color: selected ? AppColors.primary : AppColors.textSecondary),
                      const SizedBox(width: 16),
                      Text(opt['label'] as String, style: AppTypography.bodyLarge.copyWith(
                        color: selected ? AppColors.primary : Colors.white,
                      )),
                      const Spacer(),
                      if (selected) const Icon(Icons.check_circle, color: AppColors.primary, size: 22),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: (200 + i * 100).ms).slideX(begin: 0.1),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildGoalPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text('Your Health Goal', style: AppTypography.heading1)
              .animate().fadeIn(duration: 400.ms).slideY(begin: 0.3),
          const SizedBox(height: 8),
          Text('Meera will tailor advice to your goal', style: AppTypography.bodySmall)
              .animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 32),
          ...List.generate(_goalOptions.length, (i) {
            final opt = _goalOptions[i];
            final selected = _selectedGoal == opt['label'];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () => setState(() => _selectedGoal = opt['label'] as String),
                child: AnimatedContainer(
                  duration: 200.ms,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primary.withValues(alpha: 0.15) : AppColors.surface2,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: selected ? AppColors.primary : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(opt['icon'] as IconData, color: selected ? AppColors.primary : AppColors.textSecondary),
                      const SizedBox(width: 16),
                      Text(opt['label'] as String, style: AppTypography.bodyLarge.copyWith(
                        color: selected ? AppColors.primary : Colors.white,
                      )),
                      const Spacer(),
                      if (selected) const Icon(Icons.check_circle, color: AppColors.primary, size: 22),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: (200 + i * 100).ms).slideX(begin: 0.1),
            );
          }),
        ],
      ),
    );
  }
}
