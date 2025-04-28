import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget{
  const MyDrawer({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyDrawerState();
  }
}
class _MyDrawerState extends State<MyDrawer>{
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                ),
                SizedBox(height: 10),
                Text(
                  'User Name',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                Text(
                  'user@example.com',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          ListTile(


            leading: const Icon(Icons.home),
            title: const Text('Home'),
            subtitle: const Text("Đi đến Home"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              // Đóng Drawer khi nhấn và điều hướng
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.contact_mail),
            title: const Text('Contact'),
            onTap: () {
              // Đóng Drawer khi nhấn và điều hướng
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              // Đóng Drawer khi nhấn và điều hướng
              Navigator.pop(context);
            },
          ),
        ],
      ),

    );

  }
}
