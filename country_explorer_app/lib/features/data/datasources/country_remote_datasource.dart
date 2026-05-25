import 'package:dio/dio.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/exceptions/app_exceptions.dart';
import '../models/country_model.dart';

abstract class CountryRemoteDataSource {
  Future<List<CountryModel>> getAllCountries();
  Future<CountryModel> getCountryByCode(String code);
  Future<List<CountryModel>> getCountriesByCodes(List<String> codes);
}

class CountryRemoteDataSourceImpl implements CountryRemoteDataSource {
  final Dio dio;

  CountryRemoteDataSourceImpl(this.dio);

  @override
  Future<List<CountryModel>> getAllCountries() async {
    try {
      final response = await dio.get(
        '${AppConstants.baseUrl}${AppConstants.allCountriesPath}',
        queryParameters: {'fields': AppConstants.listFields},
      );
      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;
        return data
            .map((json) => CountryModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      throw ServerException('Server ${response.statusCode} xətası.');
    } on DioException catch (e) {
      throw NetworkException(e.message ?? 'Şəbəkə xətası baş verdi.');
    }
  }

  @override
  Future<CountryModel> getCountryByCode(String code) async {
    try {
      final response = await dio.get(
        '${AppConstants.baseUrl}${AppConstants.alphaPath}/$code',
        queryParameters: {'fields': AppConstants.detailFields},
      );
      if (response.statusCode == 200) {
        final data = response.data;
        final json = data is List ? data.first : data;
        return CountryModel.fromJson(json as Map<String, dynamic>);
      }
      throw ServerException('Server ${response.statusCode} xətası.');
    } on DioException catch (e) {
      throw NetworkException(e.message ?? 'Şəbəkə xətası baş verdi.');
    }
  }

  @override
  Future<List<CountryModel>> getCountriesByCodes(List<String> codes) async {
    if (codes.isEmpty) return [];
    try {
      final response = await dio.get(
        '${AppConstants.baseUrl}${AppConstants.alphaPath}',
        queryParameters: {
          'codes': codes.join(','),
          'fields': AppConstants.listFields,
        },
      );
      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;
        return data
            .map((json) => CountryModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      throw ServerException('Server ${response.statusCode} xətası.');
    } on DioException catch (e) {
      throw NetworkException(e.message ?? 'Şəbəkə xətası baş verdi.');
    }
  }
}
