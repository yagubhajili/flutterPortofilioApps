import 'package:equatable/equatable.dart';

enum SortType {
  alphabeticalAZ,
  alphabeticalZA,
  populationHighLow,
  populationLowHigh,
  areaLargeSmall,
  areaSmallLarge,
}

abstract class CountryListEvent extends Equatable {
  const CountryListEvent();
  @override
  List<Object?> get props => [];
}

class LoadCountriesEvent extends CountryListEvent {
  const LoadCountriesEvent();
}

class SearchCountriesEvent extends CountryListEvent {
  final String query;
  const SearchCountriesEvent(this.query);
  @override
  List<Object?> get props => [query];
}

class FilterByRegionEvent extends CountryListEvent {
  final String region;
  const FilterByRegionEvent(this.region);
  @override
  List<Object?> get props => [region];
}

class SortCountriesEvent extends CountryListEvent {
  final SortType sortType;
  const SortCountriesEvent(this.sortType);
  @override
  List<Object?> get props => [sortType];
}

class ToggleFavoriteListEvent extends CountryListEvent {
  final String cca3;
  const ToggleFavoriteListEvent(this.cca3);
  @override
  List<Object?> get props => [cca3];
}

class RandomCountryEvent extends CountryListEvent {
  const RandomCountryEvent();
}
