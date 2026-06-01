import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';

class RegionFilterChips extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelected;

  static const _allKey = 'Hamısı';

  static const regions = [
    _allKey,
    'Africa',
    'Americas',
    'Antarctic',
    'Asia',
    'Europe',
    'Oceania',
  ];

  static String _label(String region) {
    if (region == _allKey) return _allKey;
    return AppConstants.regionNames[region] ?? region;
  }

  const RegionFilterChips({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: regions.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final region = regions[i];
          final label = _label(region);
          final isSelected = selected == region;
          return GestureDetector(
            onTap: () => onSelected(region),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : colors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.primary : colors.border,
                  width: isSelected ? 1.5 : 0.5,
                ),
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : colors.textSecondary,
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
