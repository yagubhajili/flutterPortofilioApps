import 'package:equatable/equatable.dart';
import '../../../domain/entities/country_entity.dart';

abstract class CompareEvent extends Equatable {
  const CompareEvent();
  @override
  List<Object?> get props => [];
}

class SelectCountry1Event extends CompareEvent {
  final CountryEntity country;
  const SelectCountry1Event(this.country);
  @override
  List<Object?> get props => [country];
}

class SelectCountry2Event extends CompareEvent {
  final CountryEntity country;
  const SelectCountry2Event(this.country);
  @override
  List<Object?> get props => [country];
}

class LoadCompareCountriesEvent extends CompareEvent {
  const LoadCompareCountriesEvent();
}

class ClearCompareEvent extends CompareEvent {
  const ClearCompareEvent();
}

class ShowComparisonEvent extends CompareEvent {
  const ShowComparisonEvent();
}
