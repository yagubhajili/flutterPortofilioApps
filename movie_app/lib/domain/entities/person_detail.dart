import 'package:equatable/equatable.dart';
import 'movie.dart';

class PersonDetail extends Equatable {
  final int id;
  final String name;
  final String? biography;
  final String? birthday;
  final String? deathday;
  final String? placeOfBirth;
  final String? profilePath;
  final String? homepage;
  final String knownForDepartment;
  final double popularity;
  final List<Movie> movieCredits;

  const PersonDetail({
    required this.id,
    required this.name,
    this.biography,
    this.birthday,
    this.deathday,
    this.placeOfBirth,
    this.profilePath,
    this.homepage,
    this.knownForDepartment = '',
    this.popularity = 0,
    this.movieCredits = const [],
  });

  String get age {
    if (birthday == null) return '';
    try {
      final birth = DateTime.parse(birthday!);
      final end = deathday != null ? DateTime.parse(deathday!) : DateTime.now();
      return '${end.year - birth.year} yaş';
    } catch (_) {
      return '';
    }
  }

  @override
  List<Object?> get props => [id];
}
