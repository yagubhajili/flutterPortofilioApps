import 'package:equatable/equatable.dart';
import '../../../domain/entities/movie.dart';

class WatchlistState extends Equatable {
  final List<Movie> favorites;
  final List<Movie> watchlist;

  const WatchlistState({
    this.favorites = const [],
    this.watchlist = const [],
  });

  bool isFavorite(int id) => favorites.any((m) => m.id == id);
  bool isInWatchlist(int id) => watchlist.any((m) => m.id == id);

  WatchlistState copyWith({List<Movie>? favorites, List<Movie>? watchlist}) =>
      WatchlistState(
        favorites: favorites ?? this.favorites,
        watchlist: watchlist ?? this.watchlist,
      );

  @override
  List<Object?> get props => [favorites, watchlist];
}
