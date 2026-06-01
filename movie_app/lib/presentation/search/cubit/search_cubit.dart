import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/genre.dart';
import '../../../domain/usecases/get_genres.dart';
import '../../../domain/usecases/search_movies.dart';
import '../../search/cubit/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchMovies searchMovies;
  final SearchTv searchTv;
  final GetMoviesByGenre getMoviesByGenre;
  final GetGenres getGenres;

  List<Genre> _genres = [];
  bool _isTv = false;

  SearchCubit({
    required this.searchMovies,
    required this.searchTv,
    required this.getMoviesByGenre,
    required this.getGenres,
  }) : super(const SearchInitial());

  Future<void> loadGenres() async {
    final result = await getGenres();
    result.fold(
      (_) {},
      (genres) {
        _genres = genres;
        if (state is SearchInitial) emit(SearchInitial(genres: genres));
      },
    );
  }

  void setTvMode(bool isTv) {
    _isTv = isTv;
  }

  Future<void> search(String query) async {
    final q = query.trim();
    if (q.isEmpty) {
      emit(SearchInitial(genres: _genres));
      return;
    }
    emit(SearchLoading());
    final result = _isTv
        ? await searchTv(q)
        : await searchMovies(q);
    result.fold(
      (f) => emit(SearchError(f.message)),
      (page) {
        if (page.items.isEmpty) {
          emit(SearchEmpty(q));
        } else {
          emit(SearchLoaded(
            results: page.items,
            query: q,
            currentPage: page.currentPage,
            totalPages: page.totalPages,
          ));
        }
      },
    );
  }

  Future<void> loadMore() async {
    if (state is! SearchLoaded) return;
    final current = state as SearchLoaded;
    if (!current.hasMore || current.isLoadingMore) return;

    emit(current.copyWith(isLoadingMore: true));
    final result = _isTv
        ? await searchTv(current.query, page: current.currentPage + 1)
        : await searchMovies(current.query, page: current.currentPage + 1);

    result.fold(
      (f) => emit(current.copyWith(isLoadingMore: false)),
      (page) => emit(current.copyWith(
        results: [...current.results, ...page.items],
        currentPage: page.currentPage,
        isLoadingMore: false,
      )),
    );
  }

  Future<void> filterByGenre(int genreId, {String? sortBy}) async {
    emit(SearchLoading());
    final result = await getMoviesByGenre(genreId, sortBy: sortBy);
    result.fold(
      (f) => emit(SearchError(f.message)),
      (page) => emit(SearchLoaded(
        results: page.items,
        query: '',
        currentPage: page.currentPage,
        totalPages: page.totalPages,
      )),
    );
  }

  void clear() => emit(SearchInitial(genres: _genres));
}
