import 'package:bacqpack/model/backpack.dart';

import 'package:firebase_database/firebase_database.dart';

class BackpackService {
  static void newBackpack(Backpack backpack, Function callback) async {
    var databaseReference = FirebaseDatabase.instance.reference();

    var snapshot = await databaseReference.child("Backpacks").once();

    var backpacks = List.of(snapshot.value);

    backpacks.add(backpack.toJson());

    databaseReference.child("Backpacks").set(backpacks);

    callback();
  }
}
