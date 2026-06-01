import 'package:dartz/dartz.dart';
import '../entities/movie.dart';
import '../entities/paginated_result.dart';
import '../repositories/movie_repository.dart';
import '../../core/error/failures.dart';

class GetTopRatedMovies {
  final MovieRepository repository;
  GetTopRatedMovies(this.repository);
  Future<Either<Failure, PaginatedResult<Movie>>> call({int page = 1}) =>
      repository.getTopRated(page: page);
}
