import 'package:flutter/material.dart';

import 'package:bacqpack/model/backpack.dart';

class BackpackManager extends StatefulWidget {
  final Backpack backpack;

  BackpackManager({this.backpack});

  @override
  _BackpackManagerState createState() => _BackpackManagerState();
}

class _BackpackManagerState extends State<BackpackManager> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: buildBody(context)),
    );
  }

  Widget buildBody(BuildContext context) {}
}
