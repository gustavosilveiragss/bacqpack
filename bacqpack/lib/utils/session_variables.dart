import 'package:shared_preferences/shared_preferences.dart';

class SessionVariables {
  static var userUid;

  static void initializeSession() {
    SharedPreferences.getInstance().then((prefs) {
      userUid = prefs.getString("UserUid");
    });
  }
}
