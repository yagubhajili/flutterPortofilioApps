import 'package:dartz/dartz.dart';
import '../entities/cast_member.dart';
import '../entities/movie.dart';
import '../entities/movie_detail.dart';
import '../entities/paginated_result.dart';
import '../entities/video.dart';
import '../repositories/movie_repository.dart';
import '../../core/error/failures.dart';

class GetTrendingTv {
  final MovieRepository repository;
  GetTrendingTv(this.repository);
  Future<Either<Failure, PaginatedResult<Movie>>> call({int page = 1}) =>
      repository.getTrendingTv(page: page);
}

class GetPopularTv {
  final MovieRepository repository;
  GetPopularTv(this.repository);
  Future<Either<Failure, PaginatedResult<Movie>>> call({int page = 1}) =>
      repository.getPopularTv(page: page);
}

class GetTopRatedTv {
  final MovieRepository repository;
  GetTopRatedTv(this.repository);
  Future<Either<Failure, PaginatedResult<Movie>>> call({int page = 1}) =>
      repository.getTopRatedTv(page: page);
}

class GetTvDetail {
  final MovieRepository repository;
  GetTvDetail(this.repository);
  Future<Either<Failure, MovieDetail>> call(int id) => repository.getTvDetail(id);
}

class GetTvCredits {
  final MovieRepository repository;
  GetTvCredits(this.repository);
  Future<Either<Failure, List<CastMember>>> call(int id) => repository.getTvCredits(id);
}

class GetTvVideos {
  final MovieRepository repository;
  GetTvVideos(this.repository);
  Future<Either<Failure, List<Video>>> call(int id) => repository.getTvVideos(id);
}

class GetSimilarTv {
  final MovieRepository repository;
  GetSimilarTv(this.repository);
  Future<Either<Failure, PaginatedResult<Movie>>> call(int id, {int page = 1}) =>
      repository.getSimilarTv(id, page: page);
}
