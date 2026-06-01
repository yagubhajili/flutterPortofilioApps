import 'package:dartz/dartz.dart';
import '../entities/cast_member.dart';
import '../entities/movie.dart';
import '../entities/movie_detail.dart';
import '../entities/paginated_result.dart';
import '../entities/video.dart';
import '../repositories/movie_repository.dart';
import '../../core/error/failures.dart';

class GetMovieDetail {
  final MovieRepository repository;
  GetMovieDetail(this.repository);
  Future<Either<Failure, MovieDetail>> call(int id) => repository.getMovieDetail(id);
}

class GetMovieCredits {
  final MovieRepository repository;
  GetMovieCredits(this.repository);
  Future<Either<Failure, List<CastMember>>> call(int id) => repository.getMovieCredits(id);
}

class GetMovieVideos {
  final MovieRepository repository;
  GetMovieVideos(this.repository);
  Future<Either<Failure, List<Video>>> call(int id) => repository.getMovieVideos(id);
}

class GetSimilarMovies {
  final MovieRepository repository;
  GetSimilarMovies(this.repository);
  Future<Either<Failure, PaginatedResult<Movie>>> call(int id, {int page = 1}) =>
      repository.getSimilarMovies(id, page: page);
}
