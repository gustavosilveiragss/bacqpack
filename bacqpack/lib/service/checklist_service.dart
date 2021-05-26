import 'package:bacqpack/model/backpack.dart';
import 'package:bacqpack/model/checklist.dart';
import 'package:bacqpack/model/item.dart';
import 'package:bacqpack/model/task.dart';
import 'package:bacqpack/utils/session_variables.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_guid/flutter_guid.dart';

class ChecklistService {
  static Future<Checklist> buildChecklist() async {
    // DELETE THIS

    var databaseReference = FirebaseDatabase.instance.reference();

    var b = (await databaseReference
            .child("Backpacks")
            .orderByChild("Guid")
            .equalTo("591fb3cb-67db-4e6a-962d-7621ff8a7cea")
            .once())
        .value;

    var backpack;

    for (var e in b) {
      if (e != null) {
        backpack = Backpack.fromJson(e);
      }
    }

    var tasks = List<Task>();

    var a = Guid.newGuid.value;

    tasks.add(
      Task(
        guid: Guid.newGuid.value,
        title: "task",
        description: "description",
        checklistGuid: a,
        items: <Item>[],
      ),
    );

    var checklist = Checklist(
      guid: a,
      userUid: SessionVariables.userUid,
      title: "test",
      backpack: backpack,
      tasks: tasks,
    );

    return checklist;
  }

  static void newChecklist(Checklist checklist, Function callback) async {
    var databaseReference = FirebaseDatabase.instance.reference();

    // has to be from this user
    checklist.userUid = SessionVariables.userUid;

    var checklists = (await databaseReference
            .child("Checklists")
            .orderByChild("UserUid")
            .equalTo(checklist.userUid)
            .once())
        .value;

    // this list do be fixed so yeah

    var tempChecklists = List.from(checklists);

    // now you can add
    tempChecklists.add(checklist.toJson());

    databaseReference
        .child("Checklists")
        .orderByChild("UserUid")
        .equalTo(checklist.userUid)
        .reference()
        .set(tempChecklists);

    callback();
  }
}
