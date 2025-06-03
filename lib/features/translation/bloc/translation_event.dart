import 'package:translation_app/models/language_model.dart';

abstract class TranslationEvent {}

class LanguageFromChanged extends TranslationEvent {
  final String? language;
  LanguageFromChanged(this.language);
}

class LanguageToChanged extends TranslationEvent {
  final String? language;
  LanguageToChanged(this.language);
}

class SwitchLanguages extends TranslationEvent {
  final String inputText;
  SwitchLanguages(this.inputText);
}
class FetchCountriesRequested extends TranslationEvent {}

class TranslateTextRequested extends TranslationEvent {
  final String text;
  TranslateTextRequested(this.text);
}
