import 'package:flutter/material.dart';
import '../../../data/services/firebase_services/auth_service.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<StatefulWidget> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final AuthService _authService = AuthService();

  Future<Map<String, String?>> _getUserInfo() async {
    final user = await _authService.getCurrentUser();
    final username = await _authService.getUsername(user?.uid);
    return {
      'email': user?.email,
      'username': username,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          FutureBuilder<Map<String, String?>>(
            future: _getUserInfo(),
            builder: (context, snapshot) {
              final username = snapshot.data?['username'] ?? 'User Name';
              final email = snapshot.data?['email'] ?? 'user@example.com';
              return DrawerHeader(
                decoration: const BoxDecoration(color: Color(0xFFAEC6CF)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      username,
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Text(
                      email,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              await _authService.signOut();
              if (mounted) {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/signin', (route) => false);
              }
            },
          ),
        ],
      ),
    );
  }
}