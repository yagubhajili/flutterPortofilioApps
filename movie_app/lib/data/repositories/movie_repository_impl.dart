import 'package:dartz/dartz.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/cast_member.dart';
import '../../domain/entities/genre.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_detail.dart';
import '../../domain/entities/paginated_result.dart';
import '../../domain/entities/person_detail.dart';
import '../../domain/entities/video.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/remote/tmdb_remote_datasource.dart';

class MovieRepositoryImpl implements MovieRepository {
  final TmdbRemoteDataSource remote;

  MovieRepositoryImpl(this.remote);

  Future<Either<Failure, T>> _call<T>(Future<T> Function() fn) async {
    try {
      return Right(await fn());
    } on NetworkException {
      return const Left(NetworkFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaginatedResult<Movie>>> getTrending({int page = 1}) =>
      _call(() => remote.getTrending(page: page));

  @override
  Future<Either<Failure, PaginatedResult<Movie>>> getPopular({int page = 1}) =>
      _call(() => remote.getPopular(page: page));

  @override
  Future<Either<Failure, PaginatedResult<Movie>>> getTopRated({int page = 1}) =>
      _call(() => remote.getTopRated(page: page));

  @override
  Future<Either<Failure, PaginatedResult<Movie>>> getUpcoming({int page = 1}) =>
      _call(() => remote.getUpcoming(page: page));

  @override
  Future<Either<Failure, MovieDetail>> getMovieDetail(int id) =>
      _call(() => remote.getMovieDetail(id));

  @override
  Future<Either<Failure, List<CastMember>>> getMovieCredits(int id) =>
      _call(() => remote.getMovieCredits(id));

  @override
  Future<Either<Failure, List<Video>>> getMovieVideos(int id) =>
      _call(() => remote.getMovieVideos(id));

  @override
  Future<Either<Failure, PaginatedResult<Movie>>> getSimilarMovies(int id,
          {int page = 1}) =>
      _call(() => remote.getSimilarMovies(id, page: page));

  @override
  Future<Either<Failure, PaginatedResult<Movie>>> searchMovies(String query,
          {int page = 1}) =>
      _call(() => remote.searchMovies(query, page: page));

  @override
  Future<Either<Failure, List<Genre>>> getGenres() =>
      _call(() => remote.getGenres());

  @override
  Future<Either<Failure, PaginatedResult<Movie>>> getMoviesByGenre(int genreId,
          {int page = 1, String? sortBy}) =>
      _call(() => remote.getMoviesByGenre(genreId, page: page, sortBy: sortBy));

  @override
  Future<Either<Failure, PersonDetail>> getPersonDetail(int id) =>
      _call(() => remote.getPersonDetail(id));

  // ── TV ─────────────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, PaginatedResult<Movie>>> getTrendingTv({int page = 1}) =>
      _call(() => remote.getTrendingTv(page: page));

  @override
  Future<Either<Failure, PaginatedResult<Movie>>> getPopularTv({int page = 1}) =>
      _call(() => remote.getPopularTv(page: page));

  @override
  Future<Either<Failure, PaginatedResult<Movie>>> getTopRatedTv({int page = 1}) =>
      _call(() => remote.getTopRatedTv(page: page));

  @override
  Future<Either<Failure, MovieDetail>> getTvDetail(int id) =>
      _call(() => remote.getTvDetail(id));

  @override
  Future<Either<Failure, List<CastMember>>> getTvCredits(int id) =>
      _call(() => remote.getTvCredits(id));

  @override
  Future<Either<Failure, List<Video>>> getTvVideos(int id) =>
      _call(() => remote.getTvVideos(id));

  @override
  Future<Either<Failure, PaginatedResult<Movie>>> getSimilarTv(int id,
          {int page = 1}) =>
      _call(() => remote.getSimilarTv(id, page: page));

  @override
  Future<Either<Failure, PaginatedResult<Movie>>> searchTv(String query,
          {int page = 1}) =>
      _call(() => remote.searchTv(query, page: page));
}
