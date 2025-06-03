import 'package:equatable/equatable.dart';

import '../../../models/language_model.dart';

class ConversationState extends Equatable {
  final bool hasSpeech;
  final bool isListening;
  final String lastWordsFrom;
  final String lastWordsTo;
  final String? languageFrom;
  final String? languageTo;
  final List<Language> countries;
  final double soundLevel;
  final bool isFrom;

  const ConversationState({
    this.hasSpeech = false,
    this.isListening = false,
    this.lastWordsFrom = '',
    this.lastWordsTo = '',
    this.languageFrom,
    this.languageTo,
    this.countries = const [],
    this.soundLevel = 0.0,
    this.isFrom = true,
  });

  ConversationState copyWith({
    bool? hasSpeech,
    bool? isListening,
    String? lastWordsFrom,
    String? lastWordsTo,
    String? languageFrom,
    String? languageTo,
    List<Language>? countries,
    double? soundLevel,
    bool? isFrom,
  }) {
    return ConversationState(
      hasSpeech: hasSpeech ?? this.hasSpeech,
      isListening: isListening ?? this.isListening,
      lastWordsFrom: lastWordsFrom ?? this.lastWordsFrom,
      lastWordsTo: lastWordsTo ?? this.lastWordsTo,
      languageFrom: languageFrom ?? this.languageFrom,
      languageTo: languageTo ?? this.languageTo,
      countries: countries ?? this.countries,
      soundLevel: soundLevel ?? this.soundLevel,
      isFrom: isFrom ?? this.isFrom,
    );
  }

  @override
  List<Object?> get props => [
        hasSpeech,
        isListening,
        lastWordsFrom,
        lastWordsTo,
        languageFrom,
        languageTo,
        countries,
        soundLevel,
        isFrom,
      ];
}
