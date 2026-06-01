import 'package:dartz/dartz.dart';
import '../entities/movie.dart';
import '../repositories/watchlist_repository.dart';
import '../../core/error/failures.dart';

class GetFavorites {
  final WatchlistRepository repository;
  GetFavorites(this.repository);
  Future<Either<Failure, List<Movie>>> call() => repository.getFavorites();
}

class GetWatchlist {
  final WatchlistRepository repository;
  GetWatchlist(this.repository);
  Future<Either<Failure, List<Movie>>> call() => repository.getWatchlist();
}

class ToggleFavorite {
  final WatchlistRepository repository;
  ToggleFavorite(this.repository);
  Future<Either<Failure, Unit>> call(Movie movie) {
    if (repository.isFavorite(movie.id)) {
      return repository.removeFromFavorites(movie.id);
    }
    return repository.addToFavorites(movie);
  }
}

class ToggleWatchlist {
  final WatchlistRepository repository;
  ToggleWatchlist(this.repository);
  Future<Either<Failure, Unit>> call(Movie movie) {
    if (repository.isInWatchlist(movie.id)) {
      return repository.removeFromWatchlist(movie.id);
    }
    return repository.addToWatchlist(movie);
  }
}

class CheckFavorite {
  final WatchlistRepository repository;
  CheckFavorite(this.repository);
  bool call(int movieId) => repository.isFavorite(movieId);
}

class CheckWatchlist {
  final WatchlistRepository repository;
  CheckWatchlist(this.repository);
  bool call(int movieId) => repository.isInWatchlist(movieId);
}
