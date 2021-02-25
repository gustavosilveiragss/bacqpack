import 'package:bacqpack/model/backpack.dart';

import 'package:firebase_database/firebase_database.dart';

class BackpackService {
  static void newBackpack(Backpack backpack, Function callback) async {
    var databaseReference = FirebaseDatabase.instance.reference();

    var snapshot = await databaseReference.child("Backpacks").once();

    var backpacks = List.of(snapshot.value);

    backpacks.add(backpack.toJson());

    await databaseReference.child("Backpacks").set(backpacks);

    callback();
  }

  static void updateBackpack(Backpack backpack, Function callback) async {
    var databaseReference = FirebaseDatabase.instance.reference();

    var backpacks = (await databaseReference.child("Backpacks").once()).value;

    for (var i = 0; i < backpacks.length; i++) {
      if (backpacks[i]["Guid"] != backpack.guid) {
        continue;
      }

      backpacks[i] = backpack.toJson();
    }

    await databaseReference.child("Backpacks").set(backpacks);

    callback();
  }
}
