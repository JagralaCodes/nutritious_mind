import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/typography.dart';
import '../../../data/services/gemini_service.dart';
import '../../../data/services/context_service.dart';
import '../../../data/models/food_log_entry.dart';

class CheckerScreen extends StatefulWidget {
  const CheckerScreen({super.key});
  @override
  State<CheckerScreen> createState() => _CheckerScreenState();
}

class _CheckerScreenState extends State<CheckerScreen> {
  final _controller = TextEditingController();
  final List<String> _ingredients = [];
  bool _isAnalyzing = false;
  int? _score;
  String? _analysis;

  void _addIngredient() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() => _ingredients.add(text));
    _controller.clear();
  }

  void _analyze() async {
    setState(() => _isAnalyzing = true);
    try {
      final prompt = ContextService.buildCheckerPrompt();
      final result = await GeminiService().analyzeIngredients(_ingredients, prompt);
      final scoreMatch = RegExp(r'SCORE:(\d+)').firstMatch(result);
      setState(() {
        _score = scoreMatch != null ? int.parse(scoreMatch.group(1)!) : 65;
        _analysis = result.replaceFirst(RegExp(r'SCORE:\d+\n?'), '').trim();
        _isAnalyzing = false;
      });
      // Save to food log
      final box = Hive.box<FoodLogEntry>('food_log');
      box.add(FoodLogEntry(
        id: const Uuid().v4(),
        mealName: _ingredients.join(' + '),
        ingredients: List.from(_ingredients),
        healthScore: _score!,
        aiAnalysis: _analysis!,
      ));
    } catch (e) {
      setState(() {
        _isAnalyzing = false;
        _analysis = 'Could not analyze. Check your internet connection.';
        _score = null;
      });
    }
  }

  void _reset() => setState(() { _ingredients.clear(); _score = null; _analysis = null; });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(title: Text('DIY Meal Checker', style: AppTypography.heading3)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_score == null) ...[
              Text('What are you cooking?', style: AppTypography.heading2).animate().fadeIn(),
              const SizedBox(height: 8),
              Text('Add your ingredients and I\'ll analyze', style: AppTypography.bodySmall),
              const SizedBox(height: 20),
              Row(children: [
                Expanded(child: TextField(
                  controller: _controller,
                  style: AppTypography.bodyMedium,
                  decoration: const InputDecoration(hintText: 'e.g. dal, rice, ghee'),
                  onSubmitted: (_) => _addIngredient(),
                )),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _addIngredient,
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.add, color: Colors.white, size: 20),
                  ),
                ),
              ]),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8, runSpacing: 8,
                children: _ingredients.map((ing) => Chip(
                  label: Text(ing, style: AppTypography.bodySmall.copyWith(color: Colors.white)),
                  backgroundColor: AppColors.surface3,
                  deleteIconColor: AppColors.textSecondary,
                  onDeleted: () => setState(() => _ingredients.remove(ing)),
                )).toList(),
              ),
              const SizedBox(height: 24),
              if (_isAnalyzing)
                const Center(child: CircularProgressIndicator(color: AppColors.primary))
              else
                ElevatedButton(
                  onPressed: _ingredients.length >= 2 ? _analyze : null,
                  child: const Text('Analyze Meal'),
                ),
            ] else ...[
              // Result
              Center(
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: _score! / 100),
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, _) {
                    final s = (value * 100).round();
                    final color = s > 70 ? AppColors.primary : s > 40 ? AppColors.accentOrange : AppColors.error;
                    return SizedBox(
                      width: 140, height: 140,
                      child: Stack(alignment: Alignment.center, children: [
                        CircularProgressIndicator(value: value, strokeWidth: 8, backgroundColor: AppColors.surface3, valueColor: AlwaysStoppedAnimation(color)),
                        Column(mainAxisSize: MainAxisSize.min, children: [
                          Text('$s', style: AppTypography.monoLarge.copyWith(color: color)),
                          Text('/ 100', style: AppTypography.bodySmall),
                        ]),
                      ]),
                    );
                  },
                ),
              ).animate().fadeIn().scale(begin: const Offset(0.8, 0.8)),
              const SizedBox(height: 8),
              Center(child: Wrap(
                spacing: 6,
                children: _ingredients.map((i) => Chip(
                  label: Text(i, style: const TextStyle(fontSize: 11, color: Colors.white)),
                  backgroundColor: AppColors.surface3,
                  visualDensity: VisualDensity.compact,
                )).toList(),
              )),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColors.surface2, borderRadius: BorderRadius.circular(16)),
                child: Text(_analysis ?? '', style: AppTypography.bodyMedium.copyWith(height: 1.5)),
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _reset, child: const Text('Check Another Meal')),
            ],
          ],
        ),
      ),
    );
  }
}
