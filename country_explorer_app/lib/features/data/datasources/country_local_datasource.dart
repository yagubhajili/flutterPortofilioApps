import 'package:get_storage/get_storage.dart';
import '../../../core/constants/app_constants.dart';

abstract class CountryLocalDataSource {
  List<String> getFavorites();
  void toggleFavorite(String cca3);
  bool isFavorite(String cca3);
}

class CountryLocalDataSourceImpl implements CountryLocalDataSource {
  final GetStorage _box;

  CountryLocalDataSourceImpl(this._box);

  @override
  List<String> getFavorites() {
    final raw = _box.read<List<dynamic>>(AppConstants.favoritesStorageKey);
    return raw?.map((e) => e as String).toList() ?? [];
  }

  @override
  void toggleFavorite(String cca3) {
    final favs = getFavorites();
    if (favs.contains(cca3)) {
      favs.remove(cca3);
    } else {
      favs.add(cca3);
    }
    _box.write(AppConstants.favoritesStorageKey, favs);
  }

  @override
  bool isFavorite(String cca3) => getFavorites().contains(cca3);
}
