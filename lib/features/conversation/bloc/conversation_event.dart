import 'package:equatable/equatable.dart';
import 'package:translation_app/models/language_model.dart';

abstract class ConversationEvent extends Equatable {
  const ConversationEvent();

  @override
  List<Object?> get props => [];
}

class InitSpeechEvent extends ConversationEvent {}

class StartListeningEvent extends ConversationEvent {
  final String? localeId;
  final bool isFrom;

  const StartListeningEvent(this.localeId, {required this.isFrom});

  @override
  List<Object?> get props => [localeId, isFrom];
}

class StopListeningEvent extends ConversationEvent {
  final bool isFrom;
  const StopListeningEvent({required this.isFrom});
}
class StartSpeechEvent extends ConversationEvent {
  final String localeId;
  final String text;
  final bool isFrom;
  const StartSpeechEvent({required this.localeId,required this.text,required this.isFrom});

  @override
  List<Object?> get props => [localeId, text];
}
class StopSpeechEvent extends ConversationEvent {
  const StopSpeechEvent();
  @override
  List<Object?> get props => [];
}

class LanguageChangedEvent extends ConversationEvent {
  final String? fromLang;
  final String? toLang;
  final bool isFrom;

  const LanguageChangedEvent({required this.fromLang, required this.toLang,required this.isFrom});

  @override
  List<Object?> get props => [fromLang, toLang];
}
class FetchCountriesRequested extends ConversationEvent {}
class SwitchLanguagesEvent extends ConversationEvent {}

class SpeechResultEvent extends ConversationEvent {
  final String result;
  final bool isFrom;
  const SpeechResultEvent(this.result, this.isFrom);
  @override
  List<Object?> get props => [result, isFrom];
}
class UpdateSoundLevelEvent extends ConversationEvent {
  final double level;
  const UpdateSoundLevelEvent(this.level);
}
class RemoveWordsEvent extends ConversationEvent {
  final bool isFrom;
  const RemoveWordsEvent({required this.isFrom});

  @override
  List<Object?> get props => [isFrom];
}
