import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';

import 'package:bacqpack/model/backpack.dart';
import 'package:bacqpack/utils/session_variables.dart';

final databaseReference = FirebaseDatabase.instance.reference();

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Backpack> backpacks = [];

  bool loading;

  @override
  void initState() {
    super.initState();

    loadBackpacks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: buildBody(context),
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return Container();
  }

  Widget buildBackpackList() {
    if (loading) {
      return Container();
    }
  }

  void loadBackpacks() async {
    var tempBackpacks = [];

    var snapshot = await databaseReference.child("Backpacks").once();

    for (var backpack in snapshot.value) {
      if (backpack["UserUid"] != SessionVariables.userUid) {
        continue;
      }

      tempBackpacks.add(Backpack.fromJson(backpack));
    }

    setState(() {
      backpacks = tempBackpacks;
      loading = false;
    });
  }
}
