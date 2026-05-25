import '../entities/country_entity.dart';
import '../repositories/country_repository.dart';

class GetCountriesByCodesUseCase {
  final CountryRepository repository;
  GetCountriesByCodesUseCase(this.repository);

  Future<List<CountryEntity>> call(List<String> codes) =>
      repository.getCountriesByCodes(codes);
}
