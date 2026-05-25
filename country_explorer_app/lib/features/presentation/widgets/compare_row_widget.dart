import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

class CompareRowWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value1;
  final String value2;
  final bool value1Better;

  const CompareRowWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.value1,
    required this.value2,
    this.value1Better = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: _ValueCell(
              value: value1,
              highlight: value1Better,
              alignment: Alignment.centerRight,
            ),
          ),
          Container(
            width: 120,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _ValueCell(
              value: value2,
              highlight: !value1Better,
              alignment: Alignment.centerLeft,
            ),
          ),
        ],
      ),
    );
  }
}

class _ValueCell extends StatelessWidget {
  final String value;
  final bool highlight;
  final Alignment alignment;

  const _ValueCell({
    required this.value,
    required this.highlight,
    required this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: highlight
            ? AppColors.primary.withValues(alpha: 0.15)
            : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
        border: highlight
            ? Border.all(color: AppColors.primary.withValues(alpha: 0.4), width: 0.5)
            : null,
      ),
      child: Align(
        alignment: alignment,
        child: Text(
          value,
          style: TextStyle(
            color: highlight ? AppColors.primaryLight : AppColors.textPrimary,
            fontSize: 13,
            fontWeight: highlight ? FontWeight.w700 : FontWeight.w400,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
