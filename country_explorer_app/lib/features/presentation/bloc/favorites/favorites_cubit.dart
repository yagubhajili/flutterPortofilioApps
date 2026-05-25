import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_all_countries.dart';
import '../../../domain/usecases/get_favorites.dart';
import '../../../domain/usecases/toggle_favorite.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final GetAllCountriesUseCase _getAllCountries;
  final GetFavoritesUseCase _getFavorites;
  final ToggleFavoriteUseCase _toggleFavorite;

  FavoritesCubit({
    required GetAllCountriesUseCase getAllCountries,
    required GetFavoritesUseCase getFavorites,
    required ToggleFavoriteUseCase toggleFavorite,
  })  : _getAllCountries = getAllCountries,
        _getFavorites = getFavorites,
        _toggleFavorite = toggleFavorite,
        super(const FavoritesInitial());

  Future<void> load() async {
    emit(const FavoritesLoading());
    try {
      final favCodes = _getFavorites();
      if (favCodes.isEmpty) {
        emit(const FavoritesLoaded([]));
        return;
      }
      final all = await _getAllCountries();
      final favCountries = all
          .where((c) => favCodes.contains(c.cca3))
          .map((c) => c.copyWith(isFavorite: true))
          .toList();
      emit(FavoritesLoaded(favCountries));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  Future<void> toggleFavorite(String cca3) async {
    _toggleFavorite(cca3);
    await load();
  }
}
