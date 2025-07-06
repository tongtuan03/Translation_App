import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/services/firebase_services/auth_service.dart';
import '../../../data/services/firebase_services/country_service.dart';
import '../../../data/services/firebase_services/translate_service.dart';
import '../../../data/services/gemini_service.dart';
import '../../../utils/convert_country_name.dart';
import 'translation_event.dart';
import 'translation_state.dart';

class TranslationBloc extends Bloc<TranslationEvent, TranslationState> {
  final GeminiService _geminiService = GeminiService();
  final TranslateHistoryService _historyService = TranslateHistoryService();
  final AuthService _authService = AuthService();

  TranslationBloc() : super(TranslationState()) {
    on<SwitchLanguages>((event, emit) {
      emit(state.copyWith(
          languageFrom: state.languageTo,
          languageTo: state.languageFrom,
          translatedText: state.inputText,
          inputText: state.translatedText));
    });
    on<LanguageFromChanged>(_onLanguageFromChanged);
    on<LanguageToChanged>(_onLanguageToChanged);
    on<TranslateTextRequested>(_onTranslateTextRequested);

    on<FetchCountriesRequested>(_onFetchCountriesRequested);

    add(FetchCountriesRequested());
  }

  Future<void> _onLanguageFromChanged(
      LanguageFromChanged event, Emitter<TranslationState> emit) async {
    final inputText = state.inputText;
    final outputText = inputText == ""
        ? ""
        : await _geminiService.translateText(
            text: inputText ?? "",
            fromLang: state.languageFrom!,
            toLang: event.language!);
    emit(state.copyWith(languageFrom: event.language, inputText: outputText));
  }

  Future<void> _onLanguageToChanged(
      LanguageToChanged event, Emitter<TranslationState> emit) async {
    final inputText = state.translatedText;
    final outputText = inputText == ""
        ? ""
        : await _geminiService.translateText(
            text: inputText ?? "",
            fromLang: state.languageFrom!,
            toLang: event.language!);
    emit(
        state.copyWith(languageTo: event.language, translatedText: outputText));
  }

  Future<void> _onTranslateTextRequested(
      TranslateTextRequested event, Emitter<TranslationState> emit) async {
    if (event.text.isEmpty ||
        state.languageFrom == null ||
        state.languageTo == null) {
      return;
    }
    emit(state.copyWith(isLoading: true));

    try {
      final result = await _geminiService.translateText(
        text: event.text,
        fromLang: state.languageFrom!,
        toLang: state.languageTo!,
      );

      emit(state.copyWith(translatedText: result,inputText: event.text, isLoading: false));
      final curUser = await _authService.getCurrentUser();
      if (curUser != null) {
        final fromLangName = await languageCodeToName(state.languageFrom!);
        final toLangName = await languageCodeToName(state.languageTo!);

        await _historyService.addHistory(
          originalText: event.text,
          translatedText: result,
          fromLang: fromLangName,
          toLang: toLangName,
          userId: curUser.uid,
        );
      }
    } catch (e, stack) {
      print('Translation or Firestore error: $e');
      print('Stack trace: $stack');
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onFetchCountriesRequested(
      FetchCountriesRequested event, Emitter<TranslationState> emit) async {
    try {
      CountryService countryService = CountryService();
      final languages = await countryService.fetchAllCountries();
      emit(state.copyWith(languages: languages));
    } catch (e) {
      print('Error fetching countries: $e');
    }
  }
}
