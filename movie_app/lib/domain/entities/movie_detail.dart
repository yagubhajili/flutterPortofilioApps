import 'package:equatable/equatable.dart';
import 'genre.dart';

class MovieDetail extends Equatable {
  final int id;
  final String title;
  final String? originalTitle;
  final String? tagline;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final int voteCount;
  final String overview;
  final String? releaseDate;
  final int? runtime;
  final List<Genre> genres;
  final String? status;
  final String? homepage;
  final String? imdbId;
  final String mediaType;

  const MovieDetail({
    required this.id,
    required this.title,
    this.originalTitle,
    this.tagline,
    this.posterPath,
    this.backdropPath,
    required this.voteAverage,
    required this.voteCount,
    required this.overview,
    this.releaseDate,
    this.runtime,
    this.genres = const [],
    this.status,
    this.homepage,
    this.imdbId,
    this.mediaType = 'movie',
  });

  String get year => releaseDate != null && releaseDate!.length >= 4
      ? releaseDate!.substring(0, 4)
      : '';

  String get ratingFormatted => voteAverage.toStringAsFixed(1);

  String get runtimeFormatted {
    if (runtime == null || runtime == 0) return '';
    final h = runtime! ~/ 60;
    final m = runtime! % 60;
    return h > 0 ? '${h}s ${m}dq' : '${m}dq';
  }

  String get tmdbUrl => 'https://www.themoviedb.org/movie/$id';

  @override
  List<Object?> get props => [id];
}
