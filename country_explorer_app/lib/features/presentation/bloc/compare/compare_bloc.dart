import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_all_countries.dart';
import 'compare_event.dart';
import 'compare_state.dart';

class CompareBloc extends Bloc<CompareEvent, CompareState> {
  final GetAllCountriesUseCase getAllCountries;

  CompareBloc({required this.getAllCountries})
      : super(const CompareInitial()) {
    on<LoadCompareCountriesEvent>(_onLoad);
    on<SelectCountry1Event>(_onSelect1);
    on<SelectCountry2Event>(_onSelect2);
    on<ClearCompareEvent>(_onClear);
    on<ShowComparisonEvent>(_onShow);
  }

  Future<void> _onLoad(
      LoadCompareCountriesEvent event, Emitter<CompareState> emit) async {
    final current = state;
    if (current is CompareReady && current.allCountries.isNotEmpty) return;
    emit(const CompareLoading());
    try {
      final countries = await getAllCountries();
      countries.sort((a, b) => a.commonName.compareTo(b.commonName));
      emit(CompareReady(allCountries: countries));
    } catch (e) {
      emit(CompareError(e.toString()));
    }
  }

  void _onSelect1(SelectCountry1Event event, Emitter<CompareState> emit) {
    final current = state;
    if (current is! CompareReady) return;
    emit(current.copyWith(country1: event.country, showComparison: false));
  }

  void _onSelect2(SelectCountry2Event event, Emitter<CompareState> emit) {
    final current = state;
    if (current is! CompareReady) return;
    emit(current.copyWith(country2: event.country, showComparison: false));
  }

  void _onClear(ClearCompareEvent event, Emitter<CompareState> emit) {
    final current = state;
    if (current is! CompareReady) return;
    emit(current.copyWith(
      clearCountry1: true,
      clearCountry2: true,
      showComparison: false,
    ));
  }

  void _onShow(ShowComparisonEvent event, Emitter<CompareState> emit) {
    final current = state;
    if (current is! CompareReady) return;
    emit(current.copyWith(showComparison: true));
  }
}
