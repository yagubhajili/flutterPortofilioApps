import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_country_by_code.dart';
import '../../../domain/usecases/get_countries_by_codes.dart';
import '../../../domain/usecases/toggle_favorite.dart';
import 'country_detail_event.dart';
import 'country_detail_state.dart';

class CountryDetailBloc
    extends Bloc<CountryDetailEvent, CountryDetailState> {
  final GetCountryByCodeUseCase getCountryByCode;
  final GetCountriesByCodesUseCase getCountriesByCodes;
  final ToggleFavoriteUseCase toggleFavorite;

  CountryDetailBloc({
    required this.getCountryByCode,
    required this.getCountriesByCodes,
    required this.toggleFavorite,
  }) : super(const CountryDetailInitial()) {
    on<LoadCountryDetailEvent>(_onLoad);
    on<ToggleFavoriteDetailEvent>(_onToggleFavorite);
  }

  Future<void> _onLoad(
      LoadCountryDetailEvent event, Emitter<CountryDetailState> emit) async {
    emit(const CountryDetailLoading());
    try {
      final country = await getCountryByCode(event.cca3);
      final borderCountries = country.borders.isNotEmpty
          ? await getCountriesByCodes(country.borders)
          : <dynamic>[];
      emit(CountryDetailLoaded(
        country: country,
        borderCountries: borderCountries.cast(),
      ));
    } catch (e) {
      emit(CountryDetailError(e.toString()));
    }
  }

  void _onToggleFavorite(
      ToggleFavoriteDetailEvent event, Emitter<CountryDetailState> emit) {
    final current = state;
    if (current is! CountryDetailLoaded) return;
    toggleFavorite(event.cca3);
    emit(current.copyWith(
      country: current.country
          .copyWith(isFavorite: !current.country.isFavorite),
    ));
  }
}
