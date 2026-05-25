import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/country_entity.dart';
import '../../../domain/usecases/get_all_countries.dart';
import '../../../domain/usecases/toggle_favorite.dart';
import '../../../domain/usecases/get_favorites.dart';
import 'country_list_event.dart';
import 'country_list_state.dart';

class CountryListBloc extends Bloc<CountryListEvent, CountryListState> {
  final GetAllCountriesUseCase getAllCountries;
  final ToggleFavoriteUseCase toggleFavorite;
  final GetFavoritesUseCase getFavorites;

  CountryListBloc({
    required this.getAllCountries,
    required this.toggleFavorite,
    required this.getFavorites,
  }) : super(const CountryListInitial()) {
    on<LoadCountriesEvent>(_onLoad);
    on<SearchCountriesEvent>(_onSearch);
    on<FilterByRegionEvent>(_onFilter);
    on<SortCountriesEvent>(_onSort);
    on<ToggleFavoriteListEvent>(_onToggleFavorite);
    on<RandomCountryEvent>(_onRandom);
  }

  Future<void> _onLoad(
      LoadCountriesEvent event, Emitter<CountryListState> emit) async {
    emit(const CountryListLoading());
    try {
      final countries = await getAllCountries();
      final sorted = _applySort(countries, SortType.alphabeticalAZ);
      emit(CountryListLoaded(
        allCountries: sorted,
        displayedCountries: sorted,
      ));
    } catch (e) {
      emit(CountryListError(e.toString()));
    }
  }

  void _onSearch(
      SearchCountriesEvent event, Emitter<CountryListState> emit) {
    final current = state;
    if (current is! CountryListLoaded) return;
    final filtered = _applyFilters(
      current.allCountries,
      query: event.query,
      region: current.selectedRegion,
      sortType: current.sortType,
    );
    emit(current.copyWith(
        displayedCountries: filtered, searchQuery: event.query));
  }

  void _onFilter(
      FilterByRegionEvent event, Emitter<CountryListState> emit) {
    final current = state;
    if (current is! CountryListLoaded) return;
    final filtered = _applyFilters(
      current.allCountries,
      query: current.searchQuery,
      region: event.region,
      sortType: current.sortType,
    );
    emit(current.copyWith(
        displayedCountries: filtered, selectedRegion: event.region));
  }

  void _onSort(SortCountriesEvent event, Emitter<CountryListState> emit) {
    final current = state;
    if (current is! CountryListLoaded) return;
    final filtered = _applyFilters(
      current.allCountries,
      query: current.searchQuery,
      region: current.selectedRegion,
      sortType: event.sortType,
    );
    emit(current.copyWith(
        displayedCountries: filtered, sortType: event.sortType));
  }

  void _onToggleFavorite(
      ToggleFavoriteListEvent event, Emitter<CountryListState> emit) {
    final current = state;
    if (current is! CountryListLoaded) return;
    toggleFavorite(event.cca3);
    final favs = getFavorites();
    final updated = current.allCountries
        .map((c) => c.copyWith(isFavorite: favs.contains(c.cca3)))
        .toList();
    final displayed = _applyFilters(
      updated,
      query: current.searchQuery,
      region: current.selectedRegion,
      sortType: current.sortType,
    );
    emit(current.copyWith(
        allCountries: updated, displayedCountries: displayed));
  }

  void _onRandom(RandomCountryEvent event, Emitter<CountryListState> emit) {
    final current = state;
    if (current is! CountryListLoaded) return;
    if (current.allCountries.isEmpty) return;
    final rnd = Random();
    final country =
        current.allCountries[rnd.nextInt(current.allCountries.length)];
    emit(current.copyWith(randomCountry: country));
  }

  List<CountryEntity> _applyFilters(
    List<CountryEntity> source, {
    required String query,
    required String region,
    required SortType sortType,
  }) {
    var list = source.where((c) {
      final matchRegion = region == 'Hamısı' || c.region == region;
      final q = query.toLowerCase();
      final matchQuery = q.isEmpty ||
          c.commonName.toLowerCase().contains(q) ||
          (c.capital?.toLowerCase().contains(q) ?? false);
      return matchRegion && matchQuery;
    }).toList();
    return _applySort(list, sortType);
  }

  List<CountryEntity> _applySort(
      List<CountryEntity> list, SortType sortType) {
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
