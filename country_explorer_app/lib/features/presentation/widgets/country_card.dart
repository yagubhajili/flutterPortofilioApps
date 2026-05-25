import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/number_formatter.dart';
import '../../domain/entities/country_entity.dart';

class CountryCard extends StatelessWidget {
  final CountryEntity country;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  const CountryCard({
    super.key,
    required this.country,
    required this.onTap,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final regionColor = AppColors.regionColor(country.region);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.border, width: 0.5),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FlagImage(
              flagUrl: country.flagPng,
              regionColor: regionColor,
              region: AppConstants.regionAz(country.region),
              isFavorite: country.isFavorite,
              onFavoriteTap: onFavoriteTap,
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    country.commonName,
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  _InfoRow(
                    icon: Icons.location_city_outlined,
                    label: 'Paytaxt',
                    value: country.capital ?? '—',
                  ),
                  const SizedBox(height: 4),
                  _InfoRow(
                    icon: Icons.people_outline,
                    label: 'Əhali',
                    value: NumberFormatter.formatPopulation(country.population),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FlagImage extends StatelessWidget {
  final String flagUrl;
  final Color regionColor;
  final String region;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;

  const _FlagImage({
    required this.flagUrl,
    required this.regionColor,
    required this.region,
    required this.isFavorite,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: CachedNetworkImage(
            imageUrl: flagUrl,
            fit: BoxFit.cover,
            placeholder: (_, _) => Container(color: colors.surfaceVariant),
            errorWidget: (_, _, _) => Container(
              color: colors.surfaceVariant,
              child: Icon(Icons.flag_outlined, color: colors.textMuted, size: 40),
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: regionColor.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              region,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        Positioned(
          top: 6,
          left: 8,
          child: GestureDetector(
            onTap: onFavoriteTap,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.redAccent : Colors.white,
                size: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Row(
      children: [
        Icon(icon, size: 14, color: colors.textMuted),
        const SizedBox(width: 5),
        Text(
          '$label: ',
          style: TextStyle(color: colors.textSecondary, fontSize: 12),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
                color: colors.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
