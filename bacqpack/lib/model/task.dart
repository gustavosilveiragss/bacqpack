import 'package:bacqpack/model/item.dart';

class Task {
  String guid;
  String title; // required
  String description; // required
  String checklistGuid; // required
  List<Item> items; // optional

  Task({
    this.guid,
    this.title,
    this.description,
    this.checklistGuid,
    this.items,
  });

  static List<Task> fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null || jsonList.isEmpty) {
      return null;
    }

    var tasks = List<Task>();

    for (var i = 0; i < jsonList.length; i++) {
      var task = jsonList[i];

      tasks.add(Task.fromJson(task));
    }

    return tasks;
  }

  static Task fromJson(dynamic json) {
    if (json == null || json.isEmpty) {
      return null;
    }

    var task = Task();

    task.guid = json['Guid'];
    task.title = json['Title'];
    task.description = json['Description'];
    task.checklistGuid = json['ChecklistGuid'];

    task.items = Item.fromJsonList(json['Items']);

    return task;
  }

  Map<String, dynamic> toJson() {
    List<Map> jsonItems = [];

    items?.forEach((e) {
      jsonItems.add(e.toJson());
    });

    return {
      'Guid': guid,
      'Title': title,
      'Description': description,
      'ChecklistGuid': checklistGuid,
      'Items': items,
    };
  }
}
