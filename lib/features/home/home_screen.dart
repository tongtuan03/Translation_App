import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translation_app/features/home/widgets/bottom_navigation.dart';
import 'package:translation_app/features/home/widgets/drawer.dart';
import '../../blocs/navigationbar/navigation_cubit.dart';
import '../chatbot/gemini_chatbot.dart';
import '../conversation/speech_to_text.dart';
import '../translation/text_to_speech.dart';
import '../translation/view/translation_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<Widget> _pages = [
    const MySpeechToText(),
    const TranslationScreen(),
    const MyTextToSpeech(),
    const GeminiChatbot(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Translation App'),backgroundColor: Colors.blue,),
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

