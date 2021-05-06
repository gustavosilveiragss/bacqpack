import 'package:bacqpack/model/backpack.dart';
import 'package:bacqpack/model/checklist.dart';
import 'package:bacqpack/model/item.dart';
import 'package:bacqpack/model/task.dart';
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

    tasks.add(Task(
        guid: Guid.newGuid.value,
        title: "task",
        description: "description",
        checklistGuid: a,
        items: <Item>[]));

    var checklist = Checklist(guid: a, title: "test", backpack: backpack, tasks: tasks);

    return checklist;
  }

  static void newChecklist(Checklist checklist, Function callback) async {
    var databaseReference = FirebaseDatabase.instance.reference();

    // TODO: GET USER ONLY
    var snapshot = await databaseReference.child("Checklists").once();

    var backpacks = List.of(snapshot.value);

    backpacks.add(checklist.toJson());

    databaseReference.child("Checklists").set(backpacks);

    callback();
  }
}
