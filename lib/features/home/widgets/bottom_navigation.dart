import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../blocs/navigationbar/navigation_cubit.dart';

class MyNavigationBar extends StatelessWidget {
  const MyNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, int>(
      builder: (context, selectedIndex) {
        return NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) {
            context.read<NavigationCubit>().changeTab(index);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(FontAwesomeIcons.message),
              selectedIcon: Icon(FontAwesomeIcons.message),
              label: 'Speech to Text',
            ),
            NavigationDestination(
              icon: Icon(FontAwesomeIcons.message),
              selectedIcon: Icon(FontAwesomeIcons.message),
              label: 'Conversation',
            ),
            NavigationDestination(
              icon: Icon(Icons.translate_outlined),
              selectedIcon: Icon(Icons.translate),
              label: 'Translation',
            ),
            NavigationDestination(
              icon: Icon(Icons.volume_up_sharp),
              selectedIcon: Icon(Icons.volume_up_sharp),
              label: 'Text To Speech',
            ),
            NavigationDestination(
              icon: Icon(FontAwesomeIcons.robot),
              selectedIcon: Icon(FontAwesomeIcons.robot),
              label: 'Chatbot',
            ),
          ],
        );
      },
    );
  }
}
