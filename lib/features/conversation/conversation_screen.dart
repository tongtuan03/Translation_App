import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translation_app/features/conversation/bloc/conversation_bloc.dart';
import 'package:translation_app/features/conversation/bloc/conversation_event.dart';
import 'package:translation_app/features/conversation/bloc/conversation_state.dart';
import 'package:translation_app/features/conversation/widget/micro_button.dart';
import 'package:translation_app/features/conversation/widget/translated_text_view.dart';
import 'package:translation_app/widgets/language_dropdown.dart';

class ConversationScreen extends StatelessWidget {
  const ConversationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConversationBloc, ConversationState>(
      builder: (context, state) {
        final bloc = context.read<ConversationBloc>();
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 4,
              child: Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5,color: Colors.black),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: Colors.green,
                ),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MicrophoneButton(
                      iconColor: (!state.isFrom && state.isListening) ? Colors.red : Colors.green,
                      backgroundColor: Colors.white,
                      onPressed: () {
                        if (state.isListening) {
                          bloc.add(StopListeningEvent());
                        } else {
                          bloc.add(StartListeningEvent(
                              state.languageTo
                                  ??"vn-VN",
                              isFrom: false));
                        }
                      },
                      isFlip: true,
                      soundLevel: (!state.isFrom && state.isListening)? state.soundLevel:0,
                    ),
                    TranslatedTextView(
                      translatedText: state.lastWordsTo,
                      isFlip: true,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: LanguageDropdown(
                        languageData: state.countries,
                        selectedLanguages: state.languageFrom,
                        onLanguageChanged: (lang) {
                          bloc.add(LanguageChangedEvent(
                            fromLang: lang ?? state.languageFrom,
                            toLang: state.languageTo,
                          ));
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.swap_horiz_rounded),
                      onPressed: () => bloc.add(SwitchLanguagesEvent()),
                    ),
                    Expanded(
                      child: LanguageDropdown(
                        selectedLanguages: state.languageTo,
                        onLanguageChanged: (lang) {
                          bloc.add(LanguageChangedEvent(
                            fromLang: state.languageFrom,
                            toLang: lang ?? state.languageTo,
                          ));
                        },
                        languageData: state.countries,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5,color: Colors.black),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                ),

                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TranslatedTextView(translatedText: state.lastWordsFrom),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: MicrophoneButton(
                          soundLevel:  (state.isFrom && state.isListening) ?state.soundLevel:0,
                          iconColor:(state.isFrom && state.isListening) ? Colors.red : Colors.white,
                          backgroundColor: Colors.green,
                          onPressed: () {
                            if (state.isListening) {
                              bloc.add(StopListeningEvent());
                            } else {
                              bloc.add(StartListeningEvent(
                                  state.languageFrom??"vn-VN",
                                  isFrom: true));
                            }
                          },
                        ),
                      ),
                    ),
                    Text(state.isListening ? "Listening..." : "Not listening"),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
