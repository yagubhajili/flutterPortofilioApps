import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/country_entity.dart';
import '../../../domain/usecases/get_all_countries.dart';
import '../../../domain/usecases/toggle_favorite.dart';
import '../../../domain/usecases/get_favorites.dart';
import 'country_list_state.dart';

class CountryListCubit extends Cubit<CountryListState> {
  final GetAllCountriesUseCase _getAllCountries;
  final ToggleFavoriteUseCase _toggleFavorite;
  final GetFavoritesUseCase _getFavorites;

  CountryListCubit({
    required GetAllCountriesUseCase getAllCountries,
    required ToggleFavoriteUseCase toggleFavorite,
    required GetFavoritesUseCase getFavorites,
  })  : _getAllCountries = getAllCountries,
        _toggleFavorite = toggleFavorite,
        _getFavorites = getFavorites,
        super(const CountryListInitial());

  Future<void> load() async {
    emit(const CountryListLoading());
    try {
      final countries = await _getAllCountries();
      final sorted = _applySort(countries, SortType.alphabeticalAZ);
      emit(CountryListLoaded(
        allCountries: sorted,
        displayedCountries: sorted,
      ));
    } catch (e) {
      emit(CountryListError(e.toString()));
    }
  }

  void search(String query) {
    final current = state;
    if (current is! CountryListLoaded) return;
    final filtered = _applyFilters(
      current.allCountries,
      query: query,
      region: current.selectedRegion,
      sortType: current.sortType,
    );
    emit(current.copyWith(displayedCountries: filtered, searchQuery: query));
  }

  void filterByRegion(String region) {
    final current = state;
    if (current is! CountryListLoaded) return;
    final filtered = _applyFilters(
      current.allCountries,
      query: current.searchQuery,
      region: region,
      sortType: current.sortType,
    );
    emit(current.copyWith(displayedCountries: filtered, selectedRegion: region));
  }

  void sort(SortType sortType) {
    final current = state;
    if (current is! CountryListLoaded) return;
    final filtered = _applyFilters(
      current.allCountries,
      query: current.searchQuery,
      region: current.selectedRegion,
      sortType: sortType,
    );
    emit(current.copyWith(displayedCountries: filtered, sortType: sortType));
  }

  void toggleFavorite(String cca3) {
    final current = state;
    if (current is! CountryListLoaded) return;
    _toggleFavorite(cca3);
    final favs = _getFavorites();
    final updated = current.allCountries
        .map((c) => c.copyWith(isFavorite: favs.contains(c.cca3)))
        .toList();
    final displayed = _applyFilters(
      updated,
      query: current.searchQuery,
      region: current.selectedRegion,
      sortType: current.sortType,
    );
    emit(current.copyWith(allCountries: updated, displayedCountries: displayed));
  }

  void random() {
    final current = state;
    if (current is! CountryListLoaded) return;
    if (current.allCountries.isEmpty) return;
    final rnd = Random();
    final country = current.allCountries[rnd.nextInt(current.allCountries.length)];
    emit(current.copyWith(randomCountry: country));
  }

  void clearRandom() {
    final current = state;
    if (current is! CountryListLoaded || current.randomCountry == null) return;
    emit(CountryListLoaded(
      allCountries: current.allCountries,
      displayedCountries: current.displayedCountries,
      searchQuery: current.searchQuery,
      selectedRegion: current.selectedRegion,
      sortType: current.sortType,
    ));
  }

  List<CountryEntity> _applyFilters(
    List<CountryEntity> source, {
    required String query,
    required String region,
    required SortType sortType,
  }) {
    final list = source.where((c) {
      final matchRegion = region == 'Hamısı' || c.region == region;
      final q = query.toLowerCase();
      final matchQuery = q.isEmpty ||
          c.commonName.toLowerCase().contains(q) ||
          (c.capital?.toLowerCase().contains(q) ?? false);
      return matchRegion && matchQuery;
    }).toList();
    return _applySort(list, sortType);
  }

  List<CountryEntity> _applySort(List<CountryEntity> list, SortType sortType) {
    final sorted = List<CountryEntity>.from(list);
    switch (sortType) {
      case SortType.alphabeticalAZ:
        sorted.sort((a, b) => a.commonName.compareTo(b.commonName));
      case SortType.alphabeticalZA:
        sorted.sort((a, b) => b.commonName.compareTo(a.commonName));
      case SortType.populationHighLow:
        sorted.sort((a, b) => b.population.compareTo(a.population));
      case SortType.populationLowHigh:
        sorted.sort((a, b) => a.population.compareTo(b.population));
      case SortType.areaLargeSmall:
        sorted.sort((a, b) => (b.area ?? 0).compareTo(a.area ?? 0));
      case SortType.areaSmallLarge:
        sorted.sort((a, b) => (a.area ?? 0).compareTo(b.area ?? 0));
    }
    return sorted;
  }
}
