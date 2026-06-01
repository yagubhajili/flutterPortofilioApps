import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/network/dio_client.dart';
import '../../data/datasources/local/local_datasource.dart';
import '../../data/datasources/remote/tmdb_remote_datasource.dart';
import '../../data/repositories/movie_repository_impl.dart';
import '../../data/repositories/watchlist_repository_impl.dart';
import '../../domain/repositories/movie_repository.dart';
import '../../domain/repositories/watchlist_repository.dart';
import '../../domain/usecases/get_genres.dart';
import '../../domain/usecases/get_movie_detail.dart';
import '../../domain/usecases/get_person_detail.dart';
import '../../domain/usecases/get_popular_movies.dart';
import '../../domain/usecases/get_top_rated_movies.dart';
import '../../domain/usecases/get_trending_movies.dart';
import '../../domain/usecases/get_tv_detail.dart';
import '../../domain/usecases/get_upcoming_movies.dart';
import '../../domain/usecases/search_movies.dart';
import '../../domain/usecases/watchlist_usecases.dart';
import '../../presentation/home/cubit/home_cubit.dart';
import '../../presentation/movie_detail/cubit/detail_cubit.dart';
import '../../presentation/person/cubit/person_cubit.dart';
import '../../presentation/search/cubit/search_cubit.dart';
import '../../presentation/watchlist/cubit/watchlist_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ── External ────────────────────────────────────────────────────────────
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => prefs);

  final dioClient = DioClient();
  sl.registerLazySingleton(() => dioClient.dio);

  // ── Data Sources ────────────────────────────────────────────────────────
  sl.registerLazySingleton<TmdbRemoteDataSource>(
    () => TmdbRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<LocalDataSource>(
    () => LocalDataSourceImpl(sl()),
  );

  // ── Repositories ────────────────────────────────────────────────────────
  sl.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<WatchlistRepository>(
    () => WatchlistRepositoryImpl(sl()),
  );

  // ── Use Cases ───────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => GetTrendingMovies(sl()));
  sl.registerLazySingleton(() => GetPopularMovies(sl()));
  sl.registerLazySingleton(() => GetTopRatedMovies(sl()));
  sl.registerLazySingleton(() => GetUpcomingMovies(sl()));
  sl.registerLazySingleton(() => GetMovieDetail(sl()));
  sl.registerLazySingleton(() => GetMovieCredits(sl()));
  sl.registerLazySingleton(() => GetMovieVideos(sl()));
  sl.registerLazySingleton(() => GetSimilarMovies(sl()));
  sl.registerLazySingleton(() => SearchMovies(sl()));
  sl.registerLazySingleton(() => SearchTv(sl()));
  sl.registerLazySingleton(() => GetGenres(sl()));
  sl.registerLazySingleton(() => GetMoviesByGenre(sl()));
  sl.registerLazySingleton(() => GetPersonDetail(sl()));
  sl.registerLazySingleton(() => GetTrendingTv(sl()));
  sl.registerLazySingleton(() => GetPopularTv(sl()));
  sl.registerLazySingleton(() => GetTopRatedTv(sl()));
  sl.registerLazySingleton(() => GetTvDetail(sl()));
  sl.registerLazySingleton(() => GetTvCredits(sl()));
  sl.registerLazySingleton(() => GetTvVideos(sl()));
  sl.registerLazySingleton(() => GetSimilarTv(sl()));
  sl.registerLazySingleton(() => GetFavorites(sl()));
  sl.registerLazySingleton(() => GetWatchlist(sl()));
  sl.registerLazySingleton(() => ToggleFavorite(sl()));
  sl.registerLazySingleton(() => ToggleWatchlist(sl()));
  sl.registerLazySingleton(() => CheckFavorite(sl()));
  sl.registerLazySingleton(() => CheckWatchlist(sl()));

  // ── Cubits ──────────────────────────────────────────────────────────────
  sl.registerFactory(() => HomeCubit(
        getTrending: sl(),
        getPopular: sl(),
        getTopRated: sl(),
        getUpcoming: sl(),
      ));

  sl.registerFactory(() => DetailCubit(
        getMovieDetail: sl(),
        getMovieCredits: sl(),
        getMovieVideos: sl(),
        getSimilarMovies: sl(),
        getTvDetail: sl(),
        getTvCredits: sl(),
        getTvVideos: sl(),
        getSimilarTv: sl(),
      ));

  sl.registerFactory(() => SearchCubit(
        searchMovies: sl(),
        searchTv: sl(),
        getMoviesByGenre: sl(),
        getGenres: sl(),
      ));

  // Singleton so favorites/watchlist state persists across navigation
  sl.registerLazySingleton(() => WatchlistCubit(
        getFavorites: sl(),
        getWatchlist: sl(),
        toggleFavorite: sl(),
        toggleWatchlist: sl(),
        checkFavorite: sl(),
        checkWatchlist: sl(),
      )..load());

  sl.registerFactory(() => PersonCubit(sl()));
}
