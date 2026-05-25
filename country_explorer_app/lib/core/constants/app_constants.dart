abstract class AppConstants {
  static const String baseUrl = 'https://restcountries.com/v3.1';
  static const String allCountriesPath = '/all';
  static const String alphaPath = '/alpha';
  static const String alphaCodesPath = '/alpha?codes=';

  static const String listFields =
      'name,capital,flags,region,subregion,population,area,cca2,cca3';

  static const String detailFields =
      'name,capital,flags,region,subregion,population,area,languages,currencies,'
      'timezones,borders,cca2,cca3,tld,latlng';

  static const String favoritesStorageKey = 'favorites';

  static const Map<String, String> regionNames = {
    'Africa': 'Afrika',
    'Americas': 'Amerika',
    'Asia': 'Asiya',
    'Europe': 'Avropa',
    'Oceania': 'Okeaniya',
    'Antarctic': 'Antarktika',
  };

  static String regionAz(String region) => regionNames[region] ?? region;
}
