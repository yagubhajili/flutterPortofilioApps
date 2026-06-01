import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  final int id;
  final String title;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final String overview;
  final String? releaseDate;
  final List<int> genreIds;
  final bool isAdult;
  final String mediaType; // 'movie' or 'tv'

  const Movie({
    required this.id,
    required this.title,
    this.posterPath,
    this.backdropPath,
    required this.voteAverage,
    required this.overview,
    this.releaseDate,
    this.genreIds = const [],
    this.isAdult = false,
    this.mediaType = 'movie',
  });

  String get year => releaseDate != null && releaseDate!.length >= 4
      ? releaseDate!.substring(0, 4)
      : '';

  String get ratingFormatted => voteAverage.toStringAsFixed(1);

  @override
  List<Object?> get props => [id];
}
