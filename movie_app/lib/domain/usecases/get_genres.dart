import 'package:dartz/dartz.dart';
import '../entities/genre.dart';
import '../entities/movie.dart';
import '../entities/paginated_result.dart';
import '../repositories/movie_repository.dart';
import '../../core/error/failures.dart';

class GetGenres {
  final MovieRepository repository;
  GetGenres(this.repository);
  Future<Either<Failure, List<Genre>>> call() => repository.getGenres();
}

class GetMoviesByGenre {
  final MovieRepository repository;
  GetMoviesByGenre(this.repository);
  Future<Either<Failure, PaginatedResult<Movie>>> call(
    int genreId, {
    int page = 1,
    String? sortBy,
  }) =>
      repository.getMoviesByGenre(genreId, page: page, sortBy: sortBy);
}
