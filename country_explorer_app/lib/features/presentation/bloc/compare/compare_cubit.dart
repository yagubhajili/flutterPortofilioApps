import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/country_entity.dart';
import '../../../domain/usecases/get_all_countries.dart';
import 'compare_state.dart';

class CompareCubit extends Cubit<CompareState> {
  final GetAllCountriesUseCase _getAllCountries;

  CompareCubit({required GetAllCountriesUseCase getAllCountries})
      : _getAllCountries = getAllCountries,
        super(const CompareInitial());

  Future<void> load() async {
    final current = state;
    if (current is CompareReady && current.allCountries.isNotEmpty) return;
    emit(const CompareLoading());
    try {
      final countries = await _getAllCountries();
      countries.sort((a, b) => a.commonName.compareTo(b.commonName));
      emit(CompareReady(allCountries: countries));
    } catch (e) {
      emit(CompareError(e.toString()));
    }
  }

  void selectCountry1(CountryEntity country) {
    final current = state;
    if (current is! CompareReady) return;
    emit(current.copyWith(country1: country, showComparison: false));
  }

  void selectCountry2(CountryEntity country) {
    final current = state;
    if (current is! CompareReady) return;
    emit(current.copyWith(country2: country, showComparison: false));
  }

  void clear() {
    final current = state;
    if (current is! CompareReady) return;
    emit(current.copyWith(
      clearCountry1: true,
      clearCountry2: true,
      showComparison: false,
    ));
  }

  void showComparison() {
    final current = state;
    if (current is! CompareReady) return;
    emit(current.copyWith(showComparison: true));
  }
}
