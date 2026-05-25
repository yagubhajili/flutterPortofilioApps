import '../entities/country_entity.dart';
import '../repositories/country_repository.dart';

class GetCountryByCodeUseCase {
  final CountryRepository repository;
  GetCountryByCodeUseCase(this.repository);

  Future<CountryEntity> call(String code) => repository.getCountryByCode(code);
}
