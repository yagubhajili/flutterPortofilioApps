import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/movie.dart';
import '../../../domain/usecases/watchlist_usecases.dart';
import 'watchlist_state.dart';

class WatchlistCubit extends Cubit<WatchlistState> {
  final GetFavorites getFavorites;
  final GetWatchlist getWatchlist;
  final ToggleFavorite toggleFavorite;
  final ToggleWatchlist toggleWatchlist;
  final CheckFavorite checkFavorite;
  final CheckWatchlist checkWatchlist;

  WatchlistCubit({
    required this.getFavorites,
    required this.getWatchlist,
    required this.toggleFavorite,
    required this.toggleWatchlist,
    required this.checkFavorite,
    required this.checkWatchlist,
  }) : super(const WatchlistState());

  Future<void> load() async {
    final favResult = await getFavorites();
    final watchResult = await getWatchlist();
    emit(WatchlistState(
      favorites: favResult.getOrElse(() => []),
      watchlist: watchResult.getOrElse(() => []),
    ));
  }

  Future<void> onToggleFavorite(Movie movie) async {
    await toggleFavorite(movie);
    final favResult = await getFavorites();
    emit(state.copyWith(favorites: favResult.getOrElse(() => state.favorites)));
  }

  Future<void> onToggleWatchlist(Movie movie) async {
    await toggleWatchlist(movie);
    final watchResult = await getWatchlist();
    emit(state.copyWith(watchlist: watchResult.getOrElse(() => state.watchlist)));
  }

  bool get isFavoriteCheck => false;
  bool movieIsFavorite(int id) => checkFavorite(id);
  bool movieIsInWatchlist(int id) => checkWatchlist(id);
}
