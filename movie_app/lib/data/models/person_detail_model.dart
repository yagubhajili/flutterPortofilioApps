import '../../domain/entities/person_detail.dart';
import 'movie_model.dart';

class PersonDetailModel extends PersonDetail {
  const PersonDetailModel({
    required super.id,
    required super.name,
    super.biography,
    super.birthday,
    super.deathday,
    super.placeOfBirth,
    super.profilePath,
    super.homepage,
    super.knownForDepartment,
    super.popularity,
    super.movieCredits,
  });

  factory PersonDetailModel.fromJson(Map<String, dynamic> json) {
    final credits = json['movie_credits'] as Map<String, dynamic>?;
    final castList = (credits?['cast'] as List<dynamic>? ?? [])
        .map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
        .where((m) => m.posterPath != null && m.title.isNotEmpty)
        .toList()
      ..sort((a, b) => (b.voteAverage).compareTo(a.voteAverage));

    return PersonDetailModel(
      id: json['id'] as int,
      name: json['name'] as String,
      biography: json['biography'] as String?,
      birthday: json['birthday'] as String?,
      deathday: json['deathday'] as String?,
      placeOfBirth: json['place_of_birth'] as String?,
      profilePath: json['profile_path'] as String?,
      homepage: json['homepage'] as String?,
      knownForDepartment: json['known_for_department'] as String? ?? '',
      popularity: (json['popularity'] as num? ?? 0).toDouble(),
      movieCredits: castList,
    );
  }
}
