import 'package:flutter/material.dart';

import 'package:splashscreen/splashscreen.dart' as Splash;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_database/firebase_database.dart';

import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    FirebaseDatabase.instance.setPersistenceEnabled(true);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Splash.SplashScreen(
          seconds: 3,
          navigateAfterSeconds: HomePage(),
          loaderColor: Colors.white,
        ),
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.center,
          child: SvgPicture.asset(
            'assets/svg/logo.svg',
            width: MediaQuery.of(context).size.width,
          ),
        )
      ],
    );
  }
}
