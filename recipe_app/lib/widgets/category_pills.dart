import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/meal.dart';

class CategoryPills extends StatelessWidget {
  final List<MealCategory> categories;
  final String selectedCategory;
  final Function(String) onSelectCategory;

  const CategoryPills({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelectCategory,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length + 1, // +1 for "Hamısı" (All)
        itemBuilder: (context, index) {
          final isAll = index == 0;
          final categoryName = isAll ? 'Hamısı' : categories[index - 1].strCategory;
          final isSelected = selectedCategory == categoryName;
          final thumbnailUrl = isAll ? null : categories[index - 1].strCategoryThumb;

          return GestureDetector(
            onTap: () => onSelectCategory(categoryName),
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFFF7E21) : const Color(0xFF1F1915),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected ? const Color(0xFFFF7E21) : const Color(0xFF2C241E),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (thumbnailUrl != null) ...[
                    CachedNetworkImage(
                      imageUrl: thumbnailUrl,
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                      errorWidget: (context, url, error) => const Icon(Icons.restaurant, size: 16, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                  ] else if (isAll) ...[
                    Icon(
                      Icons.grid_view,
                      size: 16,
                      color: isSelected ? Colors.white : const Color(0xFFFF7E21),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    categoryName,
                    style: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFFF7F4F2),
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
