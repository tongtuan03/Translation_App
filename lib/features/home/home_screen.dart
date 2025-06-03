import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translation_app/blocs/navigationbar/navigation_cubit.dart';
import 'package:translation_app/features/conversation/conversation_screen.dart';
import 'package:translation_app/features/home/widgets/bottom_navigation.dart';
import 'package:translation_app/features/home/widgets/drawer.dart';
import 'package:translation_app/features/translation/text_to_speech.dart';
import 'package:translation_app/features/translation/view/translation_screen.dart';

import '../chatbot/view/gemini_chatbot.dart';
import '../conversation/speech_to_text.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<Widget> _pages = [
    const MySpeechToText(),
    const ConversationScreen(),
    const TranslationScreen(),
    const MyTextToSpeech(),
    const GeminiChatbotView(),
  ];

  final List<String> _titles = [
    'Speech to Text',
    'Text Translation',
    'Text to Speech',
    'Text to Speech',
    'AI Chatbot',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<NavigationCubit, int>(
          builder: (context, selectedIndex) {
            return Text(_titles[selectedIndex]);
          },
        ),
        backgroundColor: Colors.blue,
      ),
      body: BlocBuilder<NavigationCubit, int>(
        builder: (context, selectedIndex) {
          return _pages[selectedIndex];
        },
      ),
      bottomNavigationBar: const MyNavigationBar(),
      drawer: const MyDrawer(),
    );
  }
}
