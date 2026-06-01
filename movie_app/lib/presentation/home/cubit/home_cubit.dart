import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_popular_movies.dart';
import '../../../domain/usecases/get_top_rated_movies.dart';
import '../../../domain/usecases/get_trending_movies.dart';
import '../../../domain/usecases/get_upcoming_movies.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetTrendingMovies getTrending;
  final GetPopularMovies getPopular;
  final GetTopRatedMovies getTopRated;
  final GetUpcomingMovies getUpcoming;

  HomeCubit({
    required this.getTrending,
    required this.getPopular,
    required this.getTopRated,
    required this.getUpcoming,
  }) : super(HomeInitial());

  Future<void> load() async {
    emit(HomeLoading());
    final results = await Future.wait([
      getTrending(),
      getPopular(),
      getTopRated(),
      getUpcoming(),
    ]);

    final trendingResult = results[0];
    final popularResult = results[1];
    final topRatedResult = results[2];
    final upcomingResult = results[3];

    String? error;
    trendingResult.fold((f) => error = f.message, (_) {});
    if (error != null) {
      emit(HomeError(error!));
      return;
    }

    emit(HomeLoaded(
      trending: trendingResult.getOrElse(() => throw Exception()).items,
      popular: popularResult.getOrElse(() => throw Exception()).items,
      topRated: topRatedResult.getOrElse(() => throw Exception()).items,
      upcoming: upcomingResult.getOrElse(() => throw Exception()).items,
    ));
  }
}
