import '../entities/country_entity.dart';

abstract class CountryRepository {
  Future<List<CountryEntity>> getAllCountries();
  Future<CountryEntity> getCountryByCode(String code);
  Future<List<CountryEntity>> getCountriesByCodes(List<String> codes);
  List<String> getFavorites();
  void toggleFavorite(String cca3);
  bool isFavorite(String cca3);
}
