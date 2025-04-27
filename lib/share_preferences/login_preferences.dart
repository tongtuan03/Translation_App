import 'package:shared_preferences/shared_preferences.dart';

enum StateLogin {
  loggedIn,
  loggedOut,
}

class LoginPreference {
  static const _loginKey = 'login_state';
  static Future<void> setLogin(StateLogin state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_loginKey, state.index);
  }


  static Future<StateLogin> getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt(_loginKey);

    if (index != null) {
      return StateLogin.values[index];
    } else {
      return StateLogin.loggedOut;
    }
  }

  static Future<void> clearLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loginKey);
  }
}
