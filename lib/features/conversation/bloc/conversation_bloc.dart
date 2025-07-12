import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translation_app/data/services/gemini_service.dart';
import '../../../data/services/firebase_services/auth_service.dart';
import '../../../data/services/firebase_services/country_service.dart';
import '../../../data/services/firebase_services/translate_service.dart';
import '../../../data/services/text_to_speech_service.dart';
import '../../../utils/convert_country_name.dart';
import 'conversation_event.dart';
import 'conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final SpeechToText _speech = SpeechToText();
  final GeminiService _geminiService = GeminiService();
  final TextToSpeechService _ttsService = TextToSpeechService();
  final TranslateHistoryService _historyService = TranslateHistoryService();
  final AuthService _authService = AuthService();

  ConversationBloc() : super(const ConversationState()) {
    on<InitSpeechEvent>(_onInitSpeech);
    on<StartSpeechEvent>(_onStartSpeech);
    on<StopSpeechEvent>(_onStopSpeech);
    on<StartListeningEvent>(_onStartListening);
    on<StopListeningEvent>(_onStopListening);
    on<LanguageChangedEvent>(_onLanguageChanged);
    on<SwitchLanguagesEvent>(_onSwitchLanguages);
    on<SpeechResultEvent>(_onSpeechResult);
    on<UpdateSoundLevelEvent>(_onUpdateSoundLevel);
    on<FetchCountriesRequested>(_onFetchCountriesRequested);
    on<RemoveWordsEvent>(_onRemoverWords);

    add(FetchCountriesRequested());
    add(InitSpeechEvent());
  }

  Future<void> _onInitSpeech(
      InitSpeechEvent event, Emitter<ConversationState> emit) async {
    bool hasSpeech = await _speech.initialize();
    emit(state.copyWith(hasSpeech: hasSpeech));
  }

  Future<void> _onStartSpeech(
      StartSpeechEvent event, Emitter<ConversationState> emit) async {
    _ttsService.setLanguage(event.localeId);
    _ttsService.setSpeechRate(0.8);
    emit(state.copyWith(isSpeaking: true, isFrom: event.isFrom));
    try {
      await _ttsService.speak(event.text);
    } finally {
      // emit(state.copyWith(isSpeaking: false,isFrom: event.isFrom));
    }
  }
  Future<void> _onStopSpeech(
      StopSpeechEvent event, Emitter<ConversationState> emit) async {
    await _ttsService.stop();
    emit(state.copyWith(isSpeaking: false));
  }


  void _onStartListening(
      StartListeningEvent event, Emitter<ConversationState> emit) {
    _speech.listen(
      localeId: event.localeId,
      onSoundLevelChange: soundLevelListener,
      onResult: (result) {
        add(SpeechResultEvent(result.recognizedWords, event.isFrom));
      },
    );
    emit(state.copyWith(isListening: true, isFrom: event.isFrom));
  }

  void soundLevelListener(double level) {
    add(UpdateSoundLevelEvent(level));
  }

  void _onUpdateSoundLevel(
      UpdateSoundLevelEvent event, Emitter<ConversationState> emit) {
    emit(state.copyWith(soundLevel: event.level));
  }

  Future<void> _onStopListening(
      StopListeningEvent event, Emitter<ConversationState> emit) async {
    final curUser = await _authService.getCurrentUser();
    _speech.stop();
    emit(state.copyWith(isListening: false));

    final inputText = event.isFrom ? state.lastWordsFrom : state.lastWordsTo;
    if (inputText == "") {
      return;
    }
    final outputText = await _geminiService.translateText(
        text: inputText ?? "",
        fromLang: event.isFrom ? state.languageFrom! : state.languageTo!,
        toLang: event.isFrom ? state.languageTo! : state.languageFrom!);
    // const outputText = "Do clothes help to build your personal brand?";
    if (event.isFrom == true) {
      emit(state.copyWith(lastWordsTo: outputText));
    } else {
      emit(state.copyWith(lastWordsFrom: outputText));
    }

    await _ttsService
        .setLanguage(state.isFrom ? state.languageTo! : state.languageFrom!);
    await _ttsService.setSpeechRate(0.8);
    await _ttsService
        .speak(state.isFrom ? state.lastWordsTo : state.lastWordsFrom);
    if (curUser != null) {
      final fromLangName = await languageCodeToName(
          state.isFrom ? state.languageFrom! : state.languageTo!);
      final toLangName = await languageCodeToName(
          state.isFrom ? state.languageTo! : state.languageFrom!);
      _historyService.addHistory(
          originalText: !state.isFrom ? state.lastWordsTo : state.lastWordsFrom,
          translatedText:
              state.isFrom ? state.lastWordsTo : state.lastWordsFrom,
          fromLang: fromLangName,
          toLang: toLangName,
          userId: curUser.uid);
    }
  }

  Future<void> _onLanguageChanged(
      LanguageChangedEvent event, Emitter<ConversationState> emit) async {
    final inputText = event.isFrom ? state.lastWordsFrom : state.lastWordsTo;
    emit(state.copyWith(
        languageFrom: event.fromLang,
        languageTo: event.toLang));
    final outputText = inputText != ""
        ? await _geminiService.translateText(
            text: inputText ?? "",
            fromLang: event.isFrom ? state.languageFrom! : state.languageTo!,
            toLang: event.isFrom ? event.fromLang! : event.toLang!)
        : "";
    if (event.isFrom) {
      emit(state.copyWith(
          lastWordsFrom: outputText));
    } else {
      emit(state.copyWith(
          lastWordsTo: outputText));
    }
  }

  void _onSwitchLanguages(
      SwitchLanguagesEvent event, Emitter<ConversationState> emit) {
    emit(state.copyWith(
      languageFrom: state.languageTo,
      languageTo: state.languageFrom,
      lastWordsFrom: state.lastWordsTo,
      lastWordsTo: state.lastWordsFrom,
    ));
  }

  void _onRemoverWords(
      RemoveWordsEvent event, Emitter<ConversationState> emit) {
    if (event.isFrom) {
      emit(state.copyWith(lastWordsFrom: ""));
    } else {
      emit(state.copyWith(lastWordsTo: ""));
    }
  }

  Future<void> _onSpeechResult(
      SpeechResultEvent event, Emitter<ConversationState> emit) async {
    if (event.result == "") {
      return;
    }

    final inputText = event.result;
    if (event.isFrom) {
      emit(state.copyWith(lastWordsFrom: inputText));
    } else {
      emit(state.copyWith(lastWordsTo: inputText));
    }
  }

  Future<void> _onFetchCountriesRequested(
      FetchCountriesRequested event, Emitter<ConversationState> emit) async {
    try {
      CountryService countryService = CountryService();
      final countries = await countryService.fetchAllCountries();
      emit(state.copyWith(countries: countries));
    } catch (e) {
      print('Error fetching countries: $e');
    }
  }
}
