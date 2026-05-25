import '../repositories/country_repository.dart';

class GetFavoritesUseCase {
  final CountryRepository repository;
  GetFavoritesUseCase(this.repository);

  List<String> call() => repository.getFavorites();
}
