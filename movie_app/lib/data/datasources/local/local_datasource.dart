import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/error/exceptions.dart';
import '../../models/movie_model.dart';

abstract class LocalDataSource {
  List<MovieModel> getFavorites();
  List<MovieModel> getWatchlist();
  Future<void> saveFavorites(List<MovieModel> movies);
  Future<void> saveWatchlist(List<MovieModel> movies);
}

class LocalDataSourceImpl implements LocalDataSource {
  final SharedPreferences prefs;

  static const _favKey = 'favorites';
  static const _watchKey = 'watchlist';

  LocalDataSourceImpl(this.prefs);

  @override
  List<MovieModel> getFavorites() => _load(_favKey);

  @override
  List<MovieModel> getWatchlist() => _load(_watchKey);

  @override
  Future<void> saveFavorites(List<MovieModel> movies) => _save(_favKey, movies);

  @override
  Future<void> saveWatchlist(List<MovieModel> movies) => _save(_watchKey, movies);

  List<MovieModel> _load(String key) {
    try {
      final raw = prefs.getString(key);
      if (raw == null) return [];
      return (jsonDecode(raw) as List)
          .map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      throw const CacheException();
    }
  }

  Future<void> _save(String key, List<MovieModel> movies) async {
    try {
      await prefs.setString(
          key, jsonEncode(movies.map((m) => m.toJson()).toList()));
    } catch (_) {
      throw const CacheException('Saxlama xətası');
    }
  }
}
