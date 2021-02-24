import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionVariables {
  static String userUid;

  static String manifestContent;

  static void initializeSession(BuildContext context) {
    SharedPreferences.getInstance().then((prefs) {
      userUid = prefs.getString("UserUid");
    });

    DefaultAssetBundle.of(context)
        .loadString('AssetManifest.json')
        .then((value) {
      manifestContent = value;
    });
  }
}
