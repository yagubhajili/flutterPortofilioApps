import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_all_countries.dart';
import '../../../domain/usecases/get_favorites.dart';
import '../../../domain/usecases/toggle_favorite.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final GetAllCountriesUseCase getAllCountries;
  final GetFavoritesUseCase getFavorites;
  final ToggleFavoriteUseCase toggleFavorite;

  FavoritesBloc({
    required this.getAllCountries,
    required this.getFavorites,
    required this.toggleFavorite,
  }) : super(const FavoritesInitial()) {
    on<LoadFavoritesEvent>(_onLoad);
    on<ToggleFavoriteEvent>(_onToggle);
  }

  Future<void> _onLoad(
      LoadFavoritesEvent event, Emitter<FavoritesState> emit) async {
    emit(const FavoritesLoading());
    try {
      final favCodes = getFavorites();
      if (favCodes.isEmpty) {
        emit(const FavoritesLoaded([]));
        return;
      }
      final all = await getAllCountries();
      final favCountries = all
          .where((c) => favCodes.contains(c.cca3))
          .map((c) => c.copyWith(isFavorite: true))
          .toList();
      emit(FavoritesLoaded(favCountries));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  void _onToggle(
      ToggleFavoriteEvent event, Emitter<FavoritesState> emit) {
    toggleFavorite(event.cca3);
    add(const LoadFavoritesEvent());
  }
}
