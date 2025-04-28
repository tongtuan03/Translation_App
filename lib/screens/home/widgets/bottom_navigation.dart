import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/navigation/navigation_bloc.dart';
import '../../../blocs/navigation/navigation_event.dart';
import '../../../blocs/navigation/navigation_state.dart';

class MyNavigationBar extends StatelessWidget {
  const MyNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return NavigationBar(
          selectedIndex: state.index,
          onDestinationSelected: (index) {
            context.read<NavigationBloc>().add(NavigationTabChanged(index));
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.messenger_outline),
              selectedIcon: Icon(Icons.messenger_outline),
              label: 'Conversation',
            ),
            NavigationDestination(
              icon: Icon(Icons.translate_outlined),
              selectedIcon: Icon(Icons.translate),
              label: 'Translation',
            ),
            NavigationDestination(
              icon: Icon(Icons.menu_outlined),
              selectedIcon: Icon(Icons.menu),
              label: 'Menu',
            ),
          ],
        );
      },
    );
  }
}
