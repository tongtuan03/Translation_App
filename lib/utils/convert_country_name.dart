import '../data/services/firebase_services/country_service.dart';
import '../models/language_model.dart';

Future<String> languageCodeToName(String code) async {
  CountryService countryService = CountryService();
  List<Language> languages = await countryService.fetchAllCountries();

  final language = languages.firstWhere(
        (lang) => lang.languageId == code,
    orElse: () => Language(languageId: code, languageName: code),
  );
  return language.languageName;
}