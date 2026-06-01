import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import '../../features/data/datasources/country_local_datasource.dart';
import '../../features/data/datasources/country_remote_datasource.dart';
import '../../features/data/repositories/country_repository_impl.dart';
import '../../features/domain/repositories/country_repository.dart';
import '../../features/domain/usecases/get_all_countries.dart';
import '../../features/domain/usecases/get_countries_by_codes.dart';
import '../../features/domain/usecases/get_country_by_code.dart';
import '../../features/domain/usecases/get_favorites.dart';
import '../../features/domain/usecases/toggle_favorite.dart';
import '../../features/presentation/bloc/compare/compare_cubit.dart';
import '../../features/presentation/bloc/country_detail/country_detail_cubit.dart';
import '../../features/presentation/bloc/country_list/country_list_cubit.dart';
import '../../features/presentation/bloc/favorites/favorites_cubit.dart';
import '../theme/theme_notifier.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Theme
  sl.registerLazySingleton(() => ThemeNotifier());

  // External
  sl.registerLazySingleton<GetStorage>(() => GetStorage());
  sl.registerLazySingleton<Dio>(() {
    final dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ));
    return dio;
  });

  // Data sources
  sl.registerLazySingleton<CountryLocalDataSource>(
    () => CountryLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<CountryRemoteDataSource>(
    () => CountryRemoteDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<CountryRepository>(
    () => CountryRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllCountriesUseCase(sl()));
  sl.registerLazySingleton(() => GetCountryByCodeUseCase(sl()));
  sl.registerLazySingleton(() => GetCountriesByCodesUseCase(sl()));
  sl.registerLazySingleton(() => ToggleFavoriteUseCase(sl()));
  sl.registerLazySingleton(() => GetFavoritesUseCase(sl()));

  // Cubits (factory — new instance per creation)
  sl.registerFactory(
    () => CountryListCubit(
      getAllCountries: sl(),
      toggleFavorite: sl(),
      getFavorites: sl(),
    ),
  );
  sl.registerFactory(
    () => CountryDetailCubit(
      getCountryByCode: sl(),
      getCountriesByCodes: sl(),
      toggleFavorite: sl(),
    ),
  );
  sl.registerFactory(
    () => FavoritesCubit(
      getAllCountries: sl(),
      getFavorites: sl(),
      toggleFavorite: sl(),
    ),
  );
  sl.registerFactory(
    () => CompareCubit(getAllCountries: sl()),
  );
}
