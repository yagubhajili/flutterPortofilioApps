import 'package:flutter/material.dart';
import '../bloc/country_list/country_list_event.dart';
import '../../../app/theme/app_colors.dart';

class SortBottomSheet extends StatelessWidget {
  final SortType current;
  final ValueChanged<SortType> onSelected;

  const SortBottomSheet({
    super.key,
    required this.current,
    required this.onSelected,
  });

  static const _options = [
    (SortType.alphabeticalAZ, 'A → Z (Əlifba)', Icons.sort_by_alpha),
    (SortType.alphabeticalZA, 'Z → A (Əlifba)', Icons.sort_by_alpha),
    (SortType.populationHighLow, 'Əhali: Çox → Az', Icons.people),
    (SortType.populationLowHigh, 'Əhali: Az → Çox', Icons.people_outline),
    (SortType.areaLargeSmall, 'Ərazi: Böyük → Kiçik', Icons.map),
    (SortType.areaSmallLarge, 'Ərazi: Kiçik → Böyük', Icons.map_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Çeşidlə',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          ...(_options.map((opt) {
            final (type, label, icon) = opt;
            final isSelected = current == type;
            return ListTile(
              onTap: () {
                onSelected(type);
                Navigator.pop(context);
              },
              leading: Icon(
                icon,
                color: isSelected ? AppColors.primary : AppColors.textMuted,
                size: 22,
              ),
              title: Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
              trailing: isSelected
                  ? const Icon(Icons.check_circle,
                      color: AppColors.primary, size: 20)
                  : null,
            );
          })),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }
}
