import 'package:equatable/equatable.dart';
import 'currency_entity.dart';

class CountryEntity extends Equatable {
  final String commonName;
  final String officialName;
  final String? capital;
  final String region;
  final String? subregion;
  final int population;
  final double? area;
  final String flagPng;
  final String? flagSvg;
  final String? flagAlt;
  final String cca2;
  final String cca3;
  final List<String> borders;
  final Map<String, String> languages;
  final List<CurrencyEntity> currencies;
  final List<String> timezones;
  final List<double>? latlng;
  final List<String>? tld;
  final bool isFavorite;

  const CountryEntity({
    required this.commonName,
    required this.officialName,
    this.capital,
    required this.region,
    this.subregion,
    required this.population,
    this.area,
    required this.flagPng,
    this.flagSvg,
    this.flagAlt,
    required this.cca2,
    required this.cca3,
    required this.borders,
    required this.languages,
    required this.currencies,
    required this.timezones,
    this.latlng,
    this.tld,
    this.isFavorite = false,
  });

  CountryEntity copyWith({bool? isFavorite}) => CountryEntity(
        commonName: commonName,
        officialName: officialName,
        capital: capital,
        region: region,
        subregion: subregion,
        population: population,
        area: area,
        flagPng: flagPng,
        flagSvg: flagSvg,
        flagAlt: flagAlt,
        cca2: cca2,
        cca3: cca3,
        borders: borders,
        languages: languages,
        currencies: currencies,
        timezones: timezones,
        latlng: latlng,
        tld: tld,
        isFavorite: isFavorite ?? this.isFavorite,
      );

  @override
  List<Object?> get props => [
        commonName,
        officialName,
        capital,
        region,
        subregion,
        population,
        area,
        flagPng,
        cca2,
        cca3,
        borders,
        languages,
        currencies,
        timezones,
        latlng,
        tld,
        isFavorite,
      ];
}
