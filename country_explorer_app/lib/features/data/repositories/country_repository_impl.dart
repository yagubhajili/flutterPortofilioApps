import '../../domain/entities/country_entity.dart';
import '../../domain/repositories/country_repository.dart';
import '../datasources/country_local_datasource.dart';
import '../datasources/country_remote_datasource.dart';

class CountryRepositoryImpl implements CountryRepository {
  final CountryRemoteDataSource remoteDataSource;
  final CountryLocalDataSource localDataSource;

  CountryRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<CountryEntity>> getAllCountries() async {
    final models = await remoteDataSource.getAllCountries();
    final favs = localDataSource.getFavorites();
    return models
        .map((m) => m.copyWith(isFavorite: favs.contains(m.cca3)))
        .toList();
  }

  @override
  Future<CountryEntity> getCountryByCode(String code) async {
    final model = await remoteDataSource.getCountryByCode(code);
    return model.copyWith(
        isFavorite: localDataSource.isFavorite(model.cca3));
  }

  @override
  Future<List<CountryEntity>> getCountriesByCodes(List<String> codes) async {
    final models = await remoteDataSource.getCountriesByCodes(codes);
    final favs = localDataSource.getFavorites();
    return models
        .map((m) => m.copyWith(isFavorite: favs.contains(m.cca3)))
        .toList();
  }

  @override
  List<String> getFavorites() => localDataSource.getFavorites();

  @override
  void toggleFavorite(String cca3) => localDataSource.toggleFavorite(cca3);

  @override
  bool isFavorite(String cca3) => localDataSource.isFavorite(cca3);
}
