import 'package:dartz/dartz.dart';
import '../entities/cast_member.dart';
import '../entities/genre.dart';
import '../entities/movie.dart';
import '../entities/movie_detail.dart';
import '../entities/paginated_result.dart';
import '../entities/person_detail.dart';
import '../entities/video.dart';
import '../../core/error/failures.dart';

abstract class MovieRepository {
  Future<Either<Failure, PaginatedResult<Movie>>> getTrending({int page = 1});
  Future<Either<Failure, PaginatedResult<Movie>>> getPopular({int page = 1});
  Future<Either<Failure, PaginatedResult<Movie>>> getTopRated({int page = 1});
  Future<Either<Failure, PaginatedResult<Movie>>> getUpcoming({int page = 1});
  Future<Either<Failure, MovieDetail>> getMovieDetail(int id);
  Future<Either<Failure, List<CastMember>>> getMovieCredits(int id);
  Future<Either<Failure, List<Video>>> getMovieVideos(int id);
  Future<Either<Failure, PaginatedResult<Movie>>> getSimilarMovies(int id, {int page = 1});
  Future<Either<Failure, PaginatedResult<Movie>>> searchMovies(String query, {int page = 1});
  Future<Either<Failure, List<Genre>>> getGenres();
  Future<Either<Failure, PaginatedResult<Movie>>> getMoviesByGenre(int genreId, {int page = 1, String? sortBy});
  Future<Either<Failure, PersonDetail>> getPersonDetail(int id);

  // TV
  Future<Either<Failure, PaginatedResult<Movie>>> getTrendingTv({int page = 1});
  Future<Either<Failure, PaginatedResult<Movie>>> getPopularTv({int page = 1});
  Future<Either<Failure, PaginatedResult<Movie>>> getTopRatedTv({int page = 1});
  Future<Either<Failure, MovieDetail>> getTvDetail(int id);
  Future<Either<Failure, List<CastMember>>> getTvCredits(int id);
  Future<Either<Failure, List<Video>>> getTvVideos(int id);
  Future<Either<Failure, PaginatedResult<Movie>>> getSimilarTv(int id, {int page = 1});
  Future<Either<Failure, PaginatedResult<Movie>>> searchTv(String query, {int page = 1});
}
