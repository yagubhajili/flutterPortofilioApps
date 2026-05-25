import '../repositories/country_repository.dart';

class ToggleFavoriteUseCase {
  final CountryRepository repository;
  ToggleFavoriteUseCase(this.repository);

  void call(String cca3) => repository.toggleFavorite(cca3);
}
