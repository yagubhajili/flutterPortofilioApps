import 'package:dartz/dartz.dart';
import '../entities/movie.dart';
import '../../core/error/failures.dart';

abstract class WatchlistRepository {
  Future<Either<Failure, List<Movie>>> getFavorites();
  Future<Either<Failure, List<Movie>>> getWatchlist();
  Future<Either<Failure, Unit>> addToFavorites(Movie movie);
  Future<Either<Failure, Unit>> removeFromFavorites(int movieId);
  Future<Either<Failure, Unit>> addToWatchlist(Movie movie);
  Future<Either<Failure, Unit>> removeFromWatchlist(int movieId);
  bool isFavorite(int movieId);
  bool isInWatchlist(int movieId);
}
