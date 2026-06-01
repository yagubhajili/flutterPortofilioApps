import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/error/exceptions.dart';
import '../../models/cast_model.dart';
import '../../models/genre_model.dart';
import '../../models/movie_detail_model.dart';
import '../../models/movie_model.dart';
import '../../models/paginated_model.dart';
import '../../models/person_detail_model.dart';
import '../../models/video_model.dart';

abstract class TmdbRemoteDataSource {
  Future<PaginatedModel<MovieModel>> getTrending({int page = 1});
  Future<PaginatedModel<MovieModel>> getPopular({int page = 1});
  Future<PaginatedModel<MovieModel>> getTopRated({int page = 1});
  Future<PaginatedModel<MovieModel>> getUpcoming({int page = 1});
  Future<MovieDetailModel> getMovieDetail(int id);
  Future<List<CastModel>> getMovieCredits(int id);
  Future<List<VideoModel>> getMovieVideos(int id);
  Future<PaginatedModel<MovieModel>> getSimilarMovies(int id, {int page = 1});
  Future<PaginatedModel<MovieModel>> searchMovies(String query, {int page = 1});
  Future<List<GenreModel>> getGenres();
  Future<PaginatedModel<MovieModel>> getMoviesByGenre(int genreId, {int page = 1, String? sortBy});
  Future<PersonDetailModel> getPersonDetail(int id);

  Future<PaginatedModel<MovieModel>> getTrendingTv({int page = 1});
  Future<PaginatedModel<MovieModel>> getPopularTv({int page = 1});
  Future<PaginatedModel<MovieModel>> getTopRatedTv({int page = 1});
  Future<MovieDetailModel> getTvDetail(int id);
  Future<List<CastModel>> getTvCredits(int id);
  Future<List<VideoModel>> getTvVideos(int id);
  Future<PaginatedModel<MovieModel>> getSimilarTv(int id, {int page = 1});
  Future<PaginatedModel<MovieModel>> searchTv(String query, {int page = 1});
}

class TmdbRemoteDataSourceImpl implements TmdbRemoteDataSource {
  final Dio _dio;

  TmdbRemoteDataSourceImpl(this._dio);

  Future<Map<String, dynamic>> _get(String path,
      {Map<String, dynamic>? params}) async {
    try {
      final response = await _dio.get(path,
          queryParameters: {'language': 'az-AZ', ...?params});
      if (response.statusCode == 200) return response.data as Map<String, dynamic>;
      throw ServerException('HTTP ${response.statusCode}');
    } on DioException catch (e) {
      if (e.error is ServerException) rethrow;
      if (e.error is NetworkException) throw const NetworkException();
      throw ServerException(e.message ?? 'Bilinməyən xəta');
    }
  }

  @override
  Future<PaginatedModel<MovieModel>> getTrending({int page = 1}) async {
    final data = await _get(ApiConstants.trending, params: {'page': page});
    return PaginatedModel.fromJson(
        data, (j) => MovieModel.fromJson(j, mediaType: 'movie'));
  }

  @override
  Future<PaginatedModel<MovieModel>> getPopular({int page = 1}) async {
    final data = await _get(ApiConstants.popular, params: {'page': page});
    return PaginatedModel.fromJson(
        data, (j) => MovieModel.fromJson(j, mediaType: 'movie'));
  }

  @override
  Future<PaginatedModel<MovieModel>> getTopRated({int page = 1}) async {
    final data = await _get(ApiConstants.topRated, params: {'page': page});
    return PaginatedModel.fromJson(
        data, (j) => MovieModel.fromJson(j, mediaType: 'movie'));
  }

  @override
  Future<PaginatedModel<MovieModel>> getUpcoming({int page = 1}) async {
    final data = await _get(ApiConstants.upcoming, params: {'page': page});
    return PaginatedModel.fromJson(
        data, (j) => MovieModel.fromJson(j, mediaType: 'movie'));
  }

  @override
  Future<MovieDetailModel> getMovieDetail(int id) async {
    final data = await _get('${ApiConstants.movieDetail}/$id');
    return MovieDetailModel.fromJson(data, mediaType: 'movie');
  }

  @override
  Future<List<CastModel>> getMovieCredits(int id) async {
    final data = await _get('${ApiConstants.movieDetail}/$id/credits');
    return (data['cast'] as List<dynamic>? ?? [])
        .take(20)
        .map((e) => CastModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<VideoModel>> getMovieVideos(int id) async {
    final data = await _get('${ApiConstants.movieDetail}/$id/videos',
        params: {'language': 'en-US'});
    final results = data['results'] as List<dynamic>? ?? [];
    return results
        .map((e) => VideoModel.fromJson(e as Map<String, dynamic>))
        .where((v) => v.isYoutube)
        .toList();
  }

  @override
  Future<PaginatedModel<MovieModel>> getSimilarMovies(int id,
      {int page = 1}) async {
    final data = await _get('${ApiConstants.movieDetail}/$id/similar',
        params: {'page': page});
    return PaginatedModel.fromJson(
        data, (j) => MovieModel.fromJson(j, mediaType: 'movie'));
  }

  @override
  Future<PaginatedModel<MovieModel>> searchMovies(String query,
      {int page = 1}) async {
    final data = await _get(ApiConstants.searchMovie,
        params: {'query': query, 'page': page, 'include_adult': false});
    return PaginatedModel.fromJson(
        data, (j) => MovieModel.fromJson(j, mediaType: 'movie'));
  }

  @override
  Future<List<GenreModel>> getGenres() async {
    final data = await _get(ApiConstants.movieGenres);
    return (data['genres'] as List<dynamic>? ?? [])
        .map((e) => GenreModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<PaginatedModel<MovieModel>> getMoviesByGenre(int genreId,
      {int page = 1, String? sortBy}) async {
    final data = await _get(ApiConstants.discoverMovie, params: {
      'with_genres': genreId,
      'page': page,
      'sort_by': sortBy ?? 'popularity.desc',
    });
    return PaginatedModel.fromJson(
        data, (j) => MovieModel.fromJson(j, mediaType: 'movie'));
  }

  @override
  Future<PersonDetailModel> getPersonDetail(int id) async {
    final data = await _get('${ApiConstants.person}/$id',
        params: {'append_to_response': 'movie_credits'});
    return PersonDetailModel.fromJson(data);
  }

  // ── TV ────────────────────────────────────────────────────────────────────

  @override
  Future<PaginatedModel<MovieModel>> getTrendingTv({int page = 1}) async {
    final data =
        await _get(ApiConstants.trendingTv, params: {'page': page});
    return PaginatedModel.fromJson(
        data, (j) => MovieModel.fromJson(j, mediaType: 'tv'));
  }

  @override
  Future<PaginatedModel<MovieModel>> getPopularTv({int page = 1}) async {
    final data =
        await _get(ApiConstants.popularTv, params: {'page': page});
    return PaginatedModel.fromJson(
        data, (j) => MovieModel.fromJson(j, mediaType: 'tv'));
  }

  @override
  Future<PaginatedModel<MovieModel>> getTopRatedTv({int page = 1}) async {
    final data =
        await _get(ApiConstants.topRatedTv, params: {'page': page});
    return PaginatedModel.fromJson(
        data, (j) => MovieModel.fromJson(j, mediaType: 'tv'));
  }

  @override
  Future<MovieDetailModel> getTvDetail(int id) async {
    final data = await _get('${ApiConstants.tvDetail}/$id');
    return MovieDetailModel.fromJson(data, mediaType: 'tv');
  }

  @override
  Future<List<CastModel>> getTvCredits(int id) async {
    final data =
        await _get('${ApiConstants.tvDetail}/$id/credits');
    return (data['cast'] as List<dynamic>? ?? [])
        .take(20)
        .map((e) => CastModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<VideoModel>> getTvVideos(int id) async {
    final data = await _get('${ApiConstants.tvDetail}/$id/videos',
        params: {'language': 'en-US'});
    final results = data['results'] as List<dynamic>? ?? [];
    return results
        .map((e) => VideoModel.fromJson(e as Map<String, dynamic>))
        .where((v) => v.isYoutube)
        .toList();
  }

  @override
  Future<PaginatedModel<MovieModel>> getSimilarTv(int id,
      {int page = 1}) async {
    final data = await _get('${ApiConstants.tvDetail}/$id/similar',
        params: {'page': page});
    return PaginatedModel.fromJson(
        data, (j) => MovieModel.fromJson(j, mediaType: 'tv'));
  }

  @override
  Future<PaginatedModel<MovieModel>> searchTv(String query,
      {int page = 1}) async {
    final data = await _get(ApiConstants.searchTv,
        params: {'query': query, 'page': page});
    return PaginatedModel.fromJson(
        data, (j) => MovieModel.fromJson(j, mediaType: 'tv'));
  }
}
