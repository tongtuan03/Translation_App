import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'app.dart';
import 'screens/login_screen.dart'; // Để chỉ định trang đăng nhập
import 'firebase_options.dart'; // Firebase configuration options

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Khởi tạo Firebase với FirebaseOptions
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}


