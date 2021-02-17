import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';

import 'package:bacqpack/model/backpack.dart';

final databaseReference = FirebaseDatabase.instance.reference();

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    databaseReference.child("Backpacks").once().then((DataSnapshot snapshot) {
      for (var backpack in snapshot.value) {
        Backpack.fromJson(backpack);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: _buildBody(context),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container();
  }
}
