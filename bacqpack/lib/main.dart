import 'package:flutter/material.dart';

import 'ui/splash_screen.dart';

void main() => runApp(Bacqpack());

class Bacqpack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      title: 'bacqpack', 
      home: SplashScreen()
    );
  }
}
