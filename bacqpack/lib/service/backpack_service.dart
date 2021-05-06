import 'package:bacqpack/model/backpack.dart';
import 'package:bacqpack/utils/session_variables.dart';

import 'package:firebase_database/firebase_database.dart';

class BackpackService {
  static void newBackpack(Backpack backpack, Function callback) async {
    var databaseReference = FirebaseDatabase.instance.reference();

    // has to be from this user
    backpack.userUid = SessionVariables.userUid;

    var snapshot = await databaseReference.child("Backpacks").once();

    var backpacks = List.of(snapshot.value);

    backpacks.add(backpack.toJson());

    databaseReference.child("Backpacks").set(backpacks);

    callback();
  }

  static void deleteBackpack(Backpack backpack, Function callback) async {
    var databaseReference = FirebaseDatabase.instance.reference();

    var snapshot = await databaseReference.child("Backpacks").once();

    var backpacks = List.of(snapshot.value);

    backpacks.removeWhere((e) => e["Guid"] == backpack.guid);

    databaseReference.child("Backpacks").set(backpacks);

    callback();
  }

  static void updateBackpack(Backpack backpack, Function callback) async {
    var databaseReference = FirebaseDatabase.instance.reference();

    // has to be from this user
    backpack.userUid = SessionVariables.userUid;

    var backpacks = (await databaseReference
            .child("Backpacks")
            .orderByChild("UserUid")
            .equalTo(SessionVariables.userUid)
            .once())
        .value;

    for (var i = 0; i < backpacks.length; i++) {
      if (backpacks[i]["Guid"] != backpack.guid) {
        continue;
      }

      backpacks[i] = backpack.toJson();
    }

    databaseReference
        .child("Backpacks")
        .orderByChild("UserUid")
        .equalTo(SessionVariables.userUid)
        .reference()
        .set(backpacks);

    callback();
  }
}
