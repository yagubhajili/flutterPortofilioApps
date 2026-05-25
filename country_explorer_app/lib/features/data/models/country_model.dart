import '../../domain/entities/country_entity.dart';
import '../../domain/entities/currency_entity.dart';

class CountryModel extends CountryEntity {
  const CountryModel({
    required super.commonName,
    required super.officialName,
    super.capital,
    required super.region,
    super.subregion,
    required super.population,
    super.area,
    required super.flagPng,
    super.flagSvg,
    super.flagAlt,
    required super.cca2,
    required super.cca3,
    required super.borders,
    required super.languages,
    required super.currencies,
    required super.timezones,
    super.latlng,
    super.tld,
    super.isFavorite,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    final nameJson = json['name'] as Map<String, dynamic>? ?? {};
    final commonName = nameJson['common'] as String? ?? '';
    final officialName = nameJson['official'] as String? ?? commonName;

    final capitalList = json['capital'] as List<dynamic>?;
    final capital =
        capitalList != null && capitalList.isNotEmpty ? capitalList.first as String : null;

    final flagsJson = json['flags'] as Map<String, dynamic>? ?? {};
    final flagPng = flagsJson['png'] as String? ?? '';
    final flagSvg = flagsJson['svg'] as String?;
    final flagAlt = flagsJson['alt'] as String?;

    final currenciesJson = json['currencies'] as Map<String, dynamic>?;
    final currencies = <CurrencyEntity>[];
    if (currenciesJson != null) {
      currenciesJson.forEach((code, value) {
        final m = value as Map<String, dynamic>;
        currencies.add(CurrencyEntity(
          code: code,
          name: m['name'] as String? ?? '',
          symbol: m['symbol'] as String?,
        ));
      });
    }

    final languagesJson = json['languages'] as Map<String, dynamic>?;
    final languages = <String, String>{};
    if (languagesJson != null) {
      languagesJson.forEach((k, v) => languages[k] = v as String);
    }

    final timezonesList = json['timezones'] as List<dynamic>?;
    final timezones = timezonesList?.map((e) => e as String).toList() ?? [];

    final bordersList = json['borders'] as List<dynamic>?;
    final borders = bordersList?.map((e) => e as String).toList() ?? [];

    final latlngList = json['latlng'] as List<dynamic>?;
    final latlng = latlngList?.map((e) => (e as num).toDouble()).toList();

    final tldList = json['tld'] as List<dynamic>?;
    final tld = tldList?.map((e) => e as String).toList();

    return CountryModel(
      commonName: commonName,
      officialName: officialName,
      capital: capital,
      region: json['region'] as String? ?? '',
      subregion: json['subregion'] as String?,
      population: (json['population'] as num?)?.toInt() ?? 0,
      area: (json['area'] as num?)?.toDouble(),
      flagPng: flagPng,
      flagSvg: flagSvg,
      flagAlt: flagAlt,
      cca2: json['cca2'] as String? ?? '',
      cca3: json['cca3'] as String? ?? '',
      borders: borders,
      languages: languages,
      currencies: currencies,
      timezones: timezones,
      latlng: latlng,
      tld: tld,
    );
  }
}
