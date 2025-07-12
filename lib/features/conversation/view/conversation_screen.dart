import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: BlocBuilder<ConversationBloc, ConversationState>(
          builder: (context, state) {
            final bloc = context.read<ConversationBloc>();
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.5, color: Colors.black),
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        color: const Color(0xFFAEC6CF),
                      ),
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: GestureDetector(
                                 onTap: () {
                                   if (state.isSpeaking) {
                                     bloc.add(const StopSpeechEvent());
                                   } else {
                                     bloc.add(StartSpeechEvent(
                                       text: state.lastWordsTo ?? "",
                                       localeId: state.languageTo ?? "vn-VN",
                                       isFrom: false
                                     ));
                                   }
                                 },
                                    child: Transform(
                                      alignment: Alignment.center,
                                      transform: Matrix4.rotationY(math.pi),
                                      child: Icon(
                                        state.isSpeaking && !state.isFrom ? Icons.stop :
                                        Icons.volume_up_outlined,
                                        color: const Color(0xFF6D1B7B).withOpacity(0.8),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      bloc.add(const RemoveWordsEvent(isFrom: false));
                                    },
                                    child: Transform(
                                      alignment: Alignment.center,
                                      transform: Matrix4.rotationY(math.pi),
                                      child: Icon(
                                        Icons.clear,
                                        color: const Color(0xFF6D1B7B).withOpacity(0.8),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          MicrophoneButton(
                            iconColor: (!state.isFrom && state.isListening) ? Colors.red : const Color(0xFFAEC6CF),
                            backgroundColor: Colors.white,
                            onPressed: () {
                              if (state.isListening) {
                                bloc.add(const StopListeningEvent(isFrom: false));
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
                  Container(
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
                                isFrom: true
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
                                isFrom: false
                              ));
                            },
                            languageData: state.countries,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.5, color: Colors.black),
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
                              color: Color(0xFFAEC6CF),
                            ),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: MicrophoneButton(
                                soundLevel: (state.isFrom && state.isListening) ? state.soundLevel : 0,
                                iconColor: (state.isFrom && state.isListening) ? Colors.red : Colors.white,
                                backgroundColor: Color(0xFFAEC6CF),
                                onPressed: () {
                                  if (state.isListening) {
                                    bloc.add(const StopListeningEvent(isFrom: true));
                                  } else {
                                    bloc.add(StartListeningEvent(
                                        state.languageFrom ?? "vn-VN",
                                        isFrom: true));
                                  }
                                },
                              ),
                            ),
                          ),
                          Text(state.isListening ? "Listening..." : "Not listening"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: GestureDetector(
                                    onTap: () {
                                      bloc.add(const RemoveWordsEvent(isFrom: true));
                                    },
                                    child: Icon(
                                      Icons.clear,
                                      color: const Color(0xFF6D1B7B).withOpacity(0.8),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      if (state.isSpeaking) {
                                        bloc.add(const StopSpeechEvent());
                                      }
                                      else{
                                        bloc.add(StartSpeechEvent(
                                          isFrom: true,
                                          text: state.lastWordsFrom ?? "",
                                          localeId: state.languageFrom ??
                                              "vn-VN",
                                        ));
                                      }
                                    },
                                    child: Icon(
                                      state.isSpeaking && state.isFrom ? Icons.stop :
                                      Icons.volume_up_outlined,
                                      color: const Color(0xFF6D1B7B).withOpacity(0.8),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}