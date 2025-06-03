import '../../../models/language_model.dart';

class TranslationState {
  final String? languageFrom;
  final String? languageTo;
  final String inputText;
  final String translatedText;
  final bool isLoading;
  final List<Language> languages;

  TranslationState(
      {this.languageFrom,
      this.languageTo,
      this.inputText = '',
      this.translatedText = '',
      this.isLoading = false,
      this.languages = const []});

  TranslationState copyWith(
      {String? languageFrom,
      String? languageTo,
      String? inputText,
      String? translatedText,
      bool? isLoading,
      List<Language>? languages}) {
    return TranslationState(
        languageFrom: languageFrom ?? this.languageFrom,
        languageTo: languageTo ?? this.languageTo,
        inputText: inputText ?? this.inputText,
        translatedText: translatedText ?? this.translatedText,
        isLoading: isLoading ?? this.isLoading,
        languages: languages ?? this.languages);
  }
}
