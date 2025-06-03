import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translation_app/data/services/gemini_service.dart';
import '../../../data/services/firebase_services/country_service.dart';
import '../../../data/services/text_to_speech_service.dart';
import 'conversation_event.dart';
import 'conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final SpeechToText _speech = SpeechToText();
  final GeminiService _geminiService=GeminiService();
  final TextToSpeechService _ttsService = TextToSpeechService();
  ConversationBloc() : super(const ConversationState()) {
    on<InitSpeechEvent>(_onInitSpeech);
    on<StartListeningEvent>(_onStartListening);
    on<StopListeningEvent>(_onStopListening);
    on<LanguageChangedEvent>(_onLanguageChanged);
    on<SwitchLanguagesEvent>(_onSwitchLanguages);
    on<SpeechResultEvent>(_onSpeechResult);
    on<UpdateSoundLevelEvent>(_onUpdateSoundLevel);
    on<FetchCountriesRequested>(_onFetchCountriesRequested);

    add(FetchCountriesRequested());
    add(InitSpeechEvent());
  }

  Future<void> _onInitSpeech(
      InitSpeechEvent event, Emitter<ConversationState> emit) async {
    bool hasSpeech = await _speech.initialize();
    emit(state.copyWith(hasSpeech: hasSpeech));
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
    emit(state.copyWith(isListening: true,isFrom: event.isFrom));
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
    _speech.stop();
    emit(state.copyWith(isListening: false));
    await  _ttsService.setLanguage(state.isFrom? state.languageTo!:state.languageFrom!);
    await _ttsService.setSpeechRate(1);
    await _ttsService.speak(state.isFrom?state.lastWordsTo:state.lastWordsFrom);
  }

  void _onLanguageChanged(
      LanguageChangedEvent event, Emitter<ConversationState> emit) {
    emit(state.copyWith(
        languageFrom: event.fromLang, languageTo: event.toLang));
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

  Future<void> _onSpeechResult(
      SpeechResultEvent event, Emitter<ConversationState> emit) async {
    if(event.result==""){
      return;
    }
      final inputText=event.result;
      final outputText=await _geminiService.translateText(text: inputText, fromLang:event.isFrom? state.languageFrom!:state.languageTo!, toLang:event.isFrom? state.languageTo!:state.languageFrom!);
      emit(state.copyWith(lastWordsFrom: inputText,lastWordsTo: outputText));

  }

  Future<void> _onFetchCountriesRequested(
      FetchCountriesRequested event, Emitter<ConversationState> emit) async {
    try {
      CountryService countryService = CountryService();
      final countries = await countryService.fetchAllCountries();
      print(countries);
      emit(state.copyWith(countries: countries));
    } catch (e) {
      print('Error fetching countries: $e');
    }
  }
}
