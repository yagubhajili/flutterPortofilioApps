import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_country_by_code.dart';
import '../../../domain/usecases/get_countries_by_codes.dart';
import '../../../domain/usecases/toggle_favorite.dart';
import 'country_detail_state.dart';

class CountryDetailCubit extends Cubit<CountryDetailState> {
  final GetCountryByCodeUseCase _getCountryByCode;
  final GetCountriesByCodesUseCase _getCountriesByCodes;
  final ToggleFavoriteUseCase _toggleFavorite;

  CountryDetailCubit({
    required GetCountryByCodeUseCase getCountryByCode,
    required GetCountriesByCodesUseCase getCountriesByCodes,
    required ToggleFavoriteUseCase toggleFavorite,
  })  : _getCountryByCode = getCountryByCode,
        _getCountriesByCodes = getCountriesByCodes,
        _toggleFavorite = toggleFavorite,
        super(const CountryDetailInitial());

  Future<void> load(String cca3) async {
    emit(const CountryDetailLoading());
    try {
      final country = await _getCountryByCode(cca3);
      final borderCountries = country.borders.isNotEmpty
          ? await _getCountriesByCodes(country.borders)
          : <dynamic>[];
      emit(CountryDetailLoaded(
        country: country,
        borderCountries: borderCountries.cast(),
      ));
    } catch (e) {
      emit(CountryDetailError(e.toString()));
    }
  }

  void toggleFavorite(String cca3) {
    final current = state;
    if (current is! CountryDetailLoaded) return;
    _toggleFavorite(cca3);
    emit(current.copyWith(
      country: current.country.copyWith(isFavorite: !current.country.isFavorite),
    ));
  }
}
