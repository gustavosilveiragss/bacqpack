import 'package:bacqpack/model/backpack.dart';
import 'package:bacqpack/utils/session_variables.dart';

import 'package:firebase_database/firebase_database.dart';

class BackpackService {
  static void newBackpack(Backpack backpack, Function callback) async {
    var databaseReference = FirebaseDatabase.instance.reference();

    // has to be from this user
    backpack.userUid = SessionVariables.userUid;

    var backpacks =
        (await databaseReference.child("Backpacks").orderByChild("UserUid").equalTo(backpack.userUid).once())
            .value;

    // this list do be fixed so yeah

    var tempBackpacks = List.from(backpacks);

    // now you can add
    tempBackpacks.add(backpack.toJson());

    databaseReference
        .child("Backpacks")
        .orderByChild("UserUid")
        .equalTo(backpack.userUid)
        .reference()
        .set(tempBackpacks);

    callback();
  }

  static void deleteBackpack(Backpack backpack, Function callback) async {
    var databaseReference = FirebaseDatabase.instance.reference();

    var backpacks =
        (await databaseReference.child("Backpacks").orderByChild("UserUid").equalTo(backpack.userUid).once())
            .value;

    // this list do be fixed so yeah

    var tempBackpacks = List.from(backpacks);

    // now ye be granted the permission to remove
    tempBackpacks.removeWhere((e) => e["Guid"] == backpack.guid);

    databaseReference
        .child("Backpacks")
        .orderByChild("UserUid")
        .equalTo(backpack.userUid)
        .reference()
        .set(tempBackpacks);

    callback();
  }

  static void updateBackpack(Backpack backpack, Function callback) async {
    var databaseReference = FirebaseDatabase.instance.reference();

    var backpacks =
        (await databaseReference.child("Backpacks").orderByChild("UserUid").equalTo(backpack.userUid).once())
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
        .equalTo(backpack.userUid)
        .reference()
        .set(backpacks);

    callback();
  }
}
