import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../domain/entities/country_entity.dart';

class BorderCountryCard extends StatelessWidget {
  final CountryEntity country;
  final VoidCallback onTap;

  const BorderCountryCard({
    super.key,
    required this.country,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.border, width: 0.5),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Expanded(
              child: CachedNetworkImage(
                imageUrl: country.flagPng,
                fit: BoxFit.cover,
                width: double.infinity,
                placeholder: (_, _) => Container(color: colors.surfaceVariant),
                errorWidget: (_, _, _) =>
                    Icon(Icons.flag_outlined, color: colors.textMuted),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              child: Text(
                country.commonName,
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
