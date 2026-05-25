import 'package:equatable/equatable.dart';

abstract class CountryDetailEvent extends Equatable {
  const CountryDetailEvent();
  @override
  List<Object?> get props => [];
}

class LoadCountryDetailEvent extends CountryDetailEvent {
  final String cca3;
  const LoadCountryDetailEvent(this.cca3);
  @override
  List<Object?> get props => [cca3];
}

class ToggleFavoriteDetailEvent extends CountryDetailEvent {
  final String cca3;
  const ToggleFavoriteDetailEvent(this.cca3);
  @override
  List<Object?> get props => [cca3];
}
