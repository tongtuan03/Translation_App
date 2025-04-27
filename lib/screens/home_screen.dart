import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:translation_app/screens/welcome_screen.dart';
import 'package:translation_app/share_preferences/login_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title: Text("Home"),),
      body: ElevatedButton(onPressed: ()=>{
        LoginPreference.clearLogin(),
        Navigator.pushNamed(context, '/welcome'),
      }, child: Text("Logout"))
    );
  }
}
