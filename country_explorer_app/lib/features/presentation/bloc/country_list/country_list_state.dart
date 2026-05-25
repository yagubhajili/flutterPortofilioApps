import 'package:equatable/equatable.dart';
import '../../../domain/entities/country_entity.dart';
import 'country_list_event.dart';

abstract class CountryListState extends Equatable {
  const CountryListState();
  @override
  List<Object?> get props => [];
}

class CountryListInitial extends CountryListState {
  const CountryListInitial();
}

class CountryListLoading extends CountryListState {
  const CountryListLoading();
}

class CountryListLoaded extends CountryListState {
  final List<CountryEntity> allCountries;
  final List<CountryEntity> displayedCountries;
  final String searchQuery;
  final String selectedRegion;
  final SortType sortType;
  final CountryEntity? randomCountry;

  const CountryListLoaded({
    required this.allCountries,
    required this.displayedCountries,
    this.searchQuery = '',
    this.selectedRegion = 'Hamısı',
    this.sortType = SortType.alphabeticalAZ,
    this.randomCountry,
  });

  CountryListLoaded copyWith({
    List<CountryEntity>? allCountries,
    List<CountryEntity>? displayedCountries,
    String? searchQuery,
    String? selectedRegion,
    SortType? sortType,
    CountryEntity? randomCountry,
  }) =>
      CountryListLoaded(
        allCountries: allCountries ?? this.allCountries,
        displayedCountries: displayedCountries ?? this.displayedCountries,
        searchQuery: searchQuery ?? this.searchQuery,
        selectedRegion: selectedRegion ?? this.selectedRegion,
        sortType: sortType ?? this.sortType,
        randomCountry: randomCountry ?? this.randomCountry,
      );

  @override
  List<Object?> get props =>
      [allCountries, displayedCountries, searchQuery, selectedRegion, sortType, randomCountry];
}

class CountryListError extends CountryListState {
  final String message;
  const CountryListError(this.message);
  @override
  List<Object?> get props => [message];
}
