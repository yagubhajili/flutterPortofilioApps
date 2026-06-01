import 'package:dartz/dartz.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/watchlist_repository.dart';
import '../datasources/local/local_datasource.dart';
import '../models/movie_model.dart';

class WatchlistRepositoryImpl implements WatchlistRepository {
  final LocalDataSource local;

  late List<MovieModel> _favorites;
  late List<MovieModel> _watchlist;

  WatchlistRepositoryImpl(this.local) {
    _favorites = local.getFavorites();
    _watchlist = local.getWatchlist();
  }

  Future<Either<Failure, T>> _wrapLocal<T>(T Function() fn) async {
    try {
      return Right(fn());
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getFavorites() =>
      _wrapLocal(() => _favorites);

  @override
  Future<Either<Failure, List<Movie>>> getWatchlist() =>
      _wrapLocal(() => _watchlist);

  @override
  bool isFavorite(int movieId) =>
      _favorites.any((m) => m.id == movieId);

  @override
  bool isInWatchlist(int movieId) =>
      _watchlist.any((m) => m.id == movieId);

  @override
  Future<Either<Failure, Unit>> addToFavorites(Movie movie) async {
    try {
      if (!isFavorite(movie.id)) {
        _favorites = [..._favorites, _toModel(movie)];
        await local.saveFavorites(_favorites);
      }
      return const Right(unit);
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> removeFromFavorites(int movieId) async {
    try {
      _favorites = _favorites.where((m) => m.id != movieId).toList();
      await local.saveFavorites(_favorites);
      return const Right(unit);
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addToWatchlist(Movie movie) async {
    try {
      if (!isInWatchlist(movie.id)) {
        _watchlist = [..._watchlist, _toModel(movie)];
        await local.saveWatchlist(_watchlist);
      }
      return const Right(unit);
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> removeFromWatchlist(int movieId) async {
    try {
      _watchlist = _watchlist.where((m) => m.id != movieId).toList();
      await local.saveWatchlist(_watchlist);
      return const Right(unit);
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  MovieModel _toModel(Movie m) => MovieModel(
        id: m.id,
        title: m.title,
        posterPath: m.posterPath,
        backdropPath: m.backdropPath,
        voteAverage: m.voteAverage,
        overview: m.overview,
        releaseDate: m.releaseDate,
        genreIds: m.genreIds,
        isAdult: m.isAdult,
        mediaType: m.mediaType,
      );
}
