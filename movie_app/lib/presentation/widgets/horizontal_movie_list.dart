import 'package:flutter/material.dart';
import '../../core/widgets/shimmer_box.dart';
import '../../domain/entities/movie.dart';
import 'movie_card.dart';

class HorizontalMovieList extends StatelessWidget {
  final List<Movie>? movies;
  final bool isLoading;
  final void Function(Movie)? onMovieTap;
  final double cardWidth;
  final double cardHeight;

  const HorizontalMovieList({
    super.key,
    this.movies,
    this.isLoading = false,
    this.onMovieTap,
    this.cardWidth = 130,
    this.cardHeight = 200,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) return _Shimmer(cardWidth: cardWidth, cardHeight: cardHeight);
    final list = movies ?? [];
    if (list.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: cardHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: list.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, i) => MovieCard(
          movie: list[i],
          width: cardWidth,
          height: cardHeight,
          onTap: () => onMovieTap?.call(list[i]),
        ),
      ),
    );
  }
}

class _Shimmer extends StatelessWidget {
  final double cardWidth;
  final double cardHeight;
  const _Shimmer({required this.cardWidth, required this.cardHeight});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: cardHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 6,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, _) =>
            ShimmerBox(width: cardWidth, height: cardHeight, borderRadius: 12),
      ),
    );
  }
}
