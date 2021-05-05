import 'package:bacqpack/model/backpack.dart';
import 'package:bacqpack/model/task.dart';

class Checklist {
  String guid;
  String title; // required
  Backpack backpack; // required
  List<Task> tasks; // required

  Checklist({
    this.guid,
    this.title,
    this.backpack,
    this.tasks,
  });

  static List<Checklist> fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null || jsonList.isEmpty) {
      return null;
    }

    var checklists = List<Checklist>();

    for (var i = 0; i < jsonList.length; i++) {
      var checklist = jsonList[i];

      checklists.add(Checklist.fromJson(checklist));
    }

    return checklists;
  }

  static Checklist fromJson(dynamic json) {
    if (json == null || json.isEmpty) {
      return null;
    }

    var checklist = Checklist();

    checklist.guid = json['Guid'];
    checklist.title = json['Title'];

    checklist.backpack = Backpack.fromJson(json['Backpack']);
    checklist.tasks = Task.fromJsonList(json['Tasks']);

    return checklist;
  }

  Map<String, dynamic> toJson() {
    List<Map> jsonItems = [];

    tasks?.forEach((e) {
      jsonItems.add(e.toJson());
    });

    return {
      'Guid': guid,
      'Title': title,
      'Backpack': backpack.toJson(),
      'Tasks': jsonItems,
    };
  }
}
