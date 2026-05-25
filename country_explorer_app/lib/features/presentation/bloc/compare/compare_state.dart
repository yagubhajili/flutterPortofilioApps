import 'package:equatable/equatable.dart';
import '../../../domain/entities/country_entity.dart';

abstract class CompareState extends Equatable {
  const CompareState();
  @override
  List<Object?> get props => [];
}

class CompareInitial extends CompareState {
  final List<CountryEntity> allCountries;
  const CompareInitial({this.allCountries = const []});
  @override
  List<Object?> get props => [allCountries];
}

class CompareLoading extends CompareState {
  const CompareLoading();
}

class CompareReady extends CompareState {
  final List<CountryEntity> allCountries;
  final CountryEntity? country1;
  final CountryEntity? country2;
  final bool showComparison;

  const CompareReady({
    required this.allCountries,
    this.country1,
    this.country2,
    this.showComparison = false,
  });

  CompareReady copyWith({
    List<CountryEntity>? allCountries,
    CountryEntity? country1,
    CountryEntity? country2,
    bool? showComparison,
    bool clearCountry1 = false,
    bool clearCountry2 = false,
  }) =>
      CompareReady(
        allCountries: allCountries ?? this.allCountries,
        country1: clearCountry1 ? null : country1 ?? this.country1,
        country2: clearCountry2 ? null : country2 ?? this.country2,
        showComparison: showComparison ?? this.showComparison,
      );

  @override
  List<Object?> get props =>
      [allCountries, country1, country2, showComparison];
}

class CompareError extends CompareState {
  final String message;
  const CompareError(this.message);
  @override
  List<Object?> get props => [message];
}
