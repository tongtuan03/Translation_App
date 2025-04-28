import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translation_app/screens/home/widgets/bottom_navigation.dart';
import 'package:translation_app/screens/home/widgets/drawer.dart';
import 'package:translation_app/screens/translation/text_to_speech.dart';
import 'package:translation_app/screens/welcome/welcome_screen.dart';
import 'package:translation_app/share_preferences/login_preferences.dart';

import '../../blocs/navigation/navigation_bloc.dart';
import '../../blocs/navigation/navigation_state.dart';
import '../conversation/speech_to_text.dart';

class HomeScreen extends StatelessWidget {
  final List<Widget> _pages = [
    const MySpeechToText(),
    const MyTextToSpeech(),
    Center(child: Text('Profile Page')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Translation App')),
      body: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          return _pages[state.index];
        },
      ),
      bottomNavigationBar: const MyNavigationBar(),
      drawer: const MyDrawer(),
    );
  }
}

