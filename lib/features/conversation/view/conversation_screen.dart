import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translation_app/features/conversation/bloc/conversation_bloc.dart';
import 'package:translation_app/features/conversation/bloc/conversation_event.dart';
import 'package:translation_app/features/conversation/bloc/conversation_state.dart';
import 'package:translation_app/features/conversation/widget/micro_button.dart';
import 'package:translation_app/features/conversation/widget/translated_text_view.dart';
import 'package:translation_app/widgets/language_dropdown.dart';
import 'dart:math' as math;

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
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          onTap: () {
                            bloc.add(StartSpeechEvent(
                              text: state.lastWordsTo ?? "",
                              localeId: state.languageTo  ?? "vn-VN",
                            ));
                          },
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(math.pi), // lật theo trục Y
                            child: Icon(
                              Icons.volume_up_outlined,
                              color: const Color(0xFF6D1B7B).withOpacity(0.8),
                            ),
                          ),
                        ),
                      ),
                    ),

                    MicrophoneButton(
                      iconColor: (!state.isFrom && state.isListening) ? Colors.red : Colors.green,
                      backgroundColor: Colors.white,
                      onPressed: () {
                        if (state.isListening) {
                          bloc.add(StopListeningEvent());
                        } else {
                          bloc.add(StartListeningEvent(
                              state.languageTo ?? "vn-VN",
                              isFrom: false));
                        }
                      },
                      isFlip: true,
                      soundLevel: (!state.isFrom && state.isListening) ? state.soundLevel : 0,
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
                    Padding(
                      padding: const EdgeInsets.all(10.0), // cách đều 4 phía 10
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                          onTap: () {
                            bloc.add(StartSpeechEvent(
                              text: state.lastWordsFrom ?? "",
                              localeId: state.languageFrom  ?? "vn-VN",
                            ));
                          },
                          child: Icon(
                            Icons.volume_up_outlined,
                            color: const Color(0xFF6D1B7B).withOpacity(0.8),
                          ),
                        ),
                      ),
                    ),
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
