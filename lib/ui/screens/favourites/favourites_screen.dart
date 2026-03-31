import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/typography.dart';
import '../../../data/models/food_log_entry.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});
  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  @override
  Widget build(BuildContext context) {
    final box = Hive.box<FoodLogEntry>('food_log');
    final favs = box.values.where((f) => f.isFavourite).toList();

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(title: Text('Favourites', style: AppTypography.heading3)),
      body: favs.isEmpty
          ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Text('💚', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 16),
              Text('No favourites yet', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: 8),
              Text('Save meals from the checker!', style: AppTypography.bodySmall),
            ]))
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.85),
              itemCount: favs.length,
              itemBuilder: (context, i) {
                final f = favs[i];
                final color = f.healthScore > 70 ? AppColors.primary : f.healthScore > 40 ? AppColors.accentOrange : AppColors.error;
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: AppColors.surface2, borderRadius: BorderRadius.circular(16)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: color.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                        child: Text('${f.healthScore}', style: AppTypography.labelLarge.copyWith(color: color, fontSize: 13)),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () { f.isFavourite = false; f.save(); setState(() {}); },
                        child: const Icon(Icons.favorite, color: AppColors.error, size: 20),
                      ),
                    ]),
                    const SizedBox(height: 10),
                    Text(f.mealName, style: AppTypography.labelLarge, maxLines: 2, overflow: TextOverflow.ellipsis),
                    const Spacer(),
                    Text(f.ingredients.take(3).join(', '), style: AppTypography.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                  ]),
                ).animate().fadeIn(delay: Duration(milliseconds: i * 100)).scale(begin: const Offset(0.95, 0.95));
              },
            ),
    );
  }
}
