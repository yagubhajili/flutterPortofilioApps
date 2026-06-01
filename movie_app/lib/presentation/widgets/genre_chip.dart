import 'package:flutter/material.dart';
import '../../domain/entities/genre.dart';

class GenreChipList extends StatelessWidget {
  final List<Genre> genres;
  final int? selectedId;
  final void Function(Genre) onSelect;

  const GenreChipList({
    super.key,
    required this.genres,
    required this.onSelect,
    this.selectedId,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: genres.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final genre = genres[i];
          final selected = genre.id == selectedId;
          return GestureDetector(
            onTap: () => onSelect(genre),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFFE50914)
                    : const Color(0xFF252525),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selected
                      ? const Color(0xFFE50914)
                      : const Color(0xFF3A3A3A),
                  width: 1,
                ),
              ),
              child: Text(
                genre.name,
                style: TextStyle(
                  color: selected ? Colors.white : const Color(0xFFCCCCCC),
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
