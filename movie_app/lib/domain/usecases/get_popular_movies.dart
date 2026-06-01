import 'package:dartz/dartz.dart';
import '../entities/movie.dart';
import '../entities/paginated_result.dart';
import '../repositories/movie_repository.dart';
import '../../core/error/failures.dart';

class GetPopularMovies {
  final MovieRepository repository;
  GetPopularMovies(this.repository);
  Future<Either<Failure, PaginatedResult<Movie>>> call({int page = 1}) =>
      repository.getPopular(page: page);
}
