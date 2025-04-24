import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_bloc.dart';
import 'login_screen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: MaterialApp(
        title: 'Flutter Firebase Auth with BLoC',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginScreen(),
      ),
    );
  }
}
