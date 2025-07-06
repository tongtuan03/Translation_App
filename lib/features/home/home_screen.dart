import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translation_app/blocs/navigationbar/navigation_cubit.dart';
import 'package:translation_app/features/conversation/view/conversation_screen.dart';
import 'package:translation_app/features/home/widgets/bottom_navigation.dart';
import 'package:translation_app/features/home/widgets/drawer.dart';
import 'package:translation_app/features/translation/text_to_speech.dart';
import 'package:translation_app/features/translation/view/translation_screen.dart';

import '../chatbot/view/gemini_chatbot.dart';
import '../conversation/speech_to_text.dart';
import '../history/view/history_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<Widget> _pages = [
    const ConversationScreen(),
    const TranslationScreen(),
    const HistoryScreen(),
    const GeminiChatbotView(),
  ];

  final List<String> _titles = [
    'Conversation',
    'Translation',
    'History',
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
        backgroundColor: const Color(0xFF497D98),
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
