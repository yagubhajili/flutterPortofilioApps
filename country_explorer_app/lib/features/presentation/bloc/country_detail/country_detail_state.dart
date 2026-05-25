import 'package:equatable/equatable.dart';
import '../../../domain/entities/country_entity.dart';

abstract class CountryDetailState extends Equatable {
  const CountryDetailState();
  @override
  List<Object?> get props => [];
}

class CountryDetailInitial extends CountryDetailState {
  const CountryDetailInitial();
}

class CountryDetailLoading extends CountryDetailState {
  const CountryDetailLoading();
}

class CountryDetailLoaded extends CountryDetailState {
  final CountryEntity country;
  final List<CountryEntity> borderCountries;

  const CountryDetailLoaded({
    required this.country,
    required this.borderCountries,
  });

  CountryDetailLoaded copyWith({
    CountryEntity? country,
    List<CountryEntity>? borderCountries,
  }) =>
      CountryDetailLoaded(
        country: country ?? this.country,
        borderCountries: borderCountries ?? this.borderCountries,
      );

  @override
  List<Object?> get props => [country, borderCountries];
}

class CountryDetailError extends CountryDetailState {
  final String message;
  const CountryDetailError(this.message);
  @override
  List<Object?> get props => [message];
}
