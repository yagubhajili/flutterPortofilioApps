import 'package:dartz/dartz.dart';
import '../entities/movie.dart';
import '../entities/paginated_result.dart';
import '../repositories/movie_repository.dart';
import '../../core/error/failures.dart';

class SearchMovies {
  final MovieRepository repository;
  SearchMovies(this.repository);
  Future<Either<Failure, PaginatedResult<Movie>>> call(String query, {int page = 1}) =>
      repository.searchMovies(query, page: page);
}

class SearchTv {
  final MovieRepository repository;
  SearchTv(this.repository);
  Future<Either<Failure, PaginatedResult<Movie>>> call(String query, {int page = 1}) =>
      repository.searchTv(query, page: page);
}
