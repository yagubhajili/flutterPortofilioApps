import '../../domain/entities/movie.dart';

class MovieModel extends Movie {
  const MovieModel({
    required super.id,
    required super.title,
    super.posterPath,
    super.backdropPath,
    required super.voteAverage,
    required super.overview,
    super.releaseDate,
    super.genreIds,
    super.isAdult,
    super.mediaType,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json, {String mediaType = 'movie'}) {
    final type = json['media_type'] as String? ?? mediaType;
    return MovieModel(
      id: json['id'] as int,
      title: (json['title'] ?? json['name'] ?? '') as String,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      voteAverage: (json['vote_average'] as num? ?? 0).toDouble(),
      overview: (json['overview'] ?? '') as String,
      releaseDate: (json['release_date'] ?? json['first_air_date']) as String?,
      genreIds: (json['genre_ids'] as List<dynamic>?)?.cast<int>() ?? [],
      isAdult: json['adult'] as bool? ?? false,
      mediaType: type,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'poster_path': posterPath,
        'backdrop_path': backdropPath,
        'vote_average': voteAverage,
        'overview': overview,
        'release_date': releaseDate,
        'genre_ids': genreIds,
        'adult': isAdult,
        'media_type': mediaType,
      };
}
