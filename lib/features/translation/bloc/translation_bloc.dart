import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../data/services/firebase_services/country_service.dart';
import '../../../data/services/gemini_service.dart';
import 'translation_event.dart';
import 'translation_state.dart';

class TranslationBloc extends Bloc<TranslationEvent, TranslationState> {
  final GeminiService _geminiService=GeminiService();
  TranslationBloc() : super(TranslationState()) {

    on<LanguageFromChanged>((event, emit) {
      emit(state.copyWith(languageFrom: event.language));
    });

    on<LanguageToChanged>((event, emit) {
      emit(state.copyWith(languageTo: event.language));
    });

    on<SwitchLanguages>((event, emit) {
      emit(state.copyWith(
        languageFrom: state.languageTo,
        languageTo: state.languageFrom,
        translatedText:event.inputText,
        inputText: state.translatedText
      ));
    });

    on<TranslateTextRequested>(_onTranslateTextRequested);

    on<FetchCountriesRequested>(_onFetchCountriesRequested);

    add(FetchCountriesRequested());
  }

  Future<void> _onTranslateTextRequested(
      TranslateTextRequested event, Emitter<TranslationState> emit) async {
    if (event.text.isEmpty || state.languageFrom == null || state.languageTo == null) {
      return;
    }
    emit(state.copyWith(isLoading: true));
    try {
      final result = await _geminiService.translateText(text: event.text, fromLang: state.languageFrom!, toLang: state.languageTo!);
      emit(state.copyWith(translatedText: result, isLoading: false));
    } catch (_) {
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
