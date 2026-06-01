import 'package:flutter/material.dart';
import '../../core/constants/api_constants.dart';
import '../../core/widgets/app_image.dart';
import '../../domain/entities/cast_member.dart';

class CastCard extends StatelessWidget {
  final CastMember member;
  final VoidCallback? onTap;

  const CastCard({super.key, required this.member, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 80,
        child: Column(
          children: [
            ClipOval(
              child: AppImage(
                path: member.profilePath,
                baseUrl: ApiConstants.profileW185,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              member.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFFF5F5F5),
                fontSize: 11,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
            if (member.character != null && member.character!.isNotEmpty)
              Text(
                member.character!,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF9E9E9E),
                  fontSize: 10,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
