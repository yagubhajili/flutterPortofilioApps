import '../../domain/entities/movie_detail.dart';
import 'genre_model.dart';

class MovieDetailModel extends MovieDetail {
  const MovieDetailModel({
    required super.id,
    required super.title,
    super.originalTitle,
    super.tagline,
    super.posterPath,
    super.backdropPath,
    required super.voteAverage,
    required super.voteCount,
    required super.overview,
    super.releaseDate,
    super.runtime,
    super.genres,
    super.status,
    super.homepage,
    super.imdbId,
    super.mediaType,
  });

  factory MovieDetailModel.fromJson(Map<String, dynamic> json,
      {String mediaType = 'movie'}) {
    final isMovie = mediaType != 'tv';
    return MovieDetailModel(
      id: json['id'] as int,
      title: (json['title'] ?? json['name'] ?? '') as String,
      originalTitle:
          (json['original_title'] ?? json['original_name']) as String?,
      tagline: json['tagline'] as String?,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      voteAverage: (json['vote_average'] as num? ?? 0).toDouble(),
      voteCount: json['vote_count'] as int? ?? 0,
      overview: (json['overview'] ?? '') as String,
      releaseDate:
          (json['release_date'] ?? json['first_air_date']) as String?,
      runtime: isMovie
          ? json['runtime'] as int?
          : (json['episode_run_time'] as List?)?.isNotEmpty == true
              ? (json['episode_run_time'] as List).first as int
              : null,
      genres: (json['genres'] as List<dynamic>? ?? [])
          .map((g) => GenreModel.fromJson(g as Map<String, dynamic>))
          .toList(),
      status: json['status'] as String?,
      homepage: json['homepage'] as String?,
      imdbId: json['imdb_id'] as String?,
      mediaType: mediaType,
    );
  }
}
