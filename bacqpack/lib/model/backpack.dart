import 'package:bacqpack/model/compartment.dart';

class Backpack {
  String guid;
  String userUid;
  String title;
  String iconId;
  List<Compartment> compartments;

  Backpack({
    this.guid,
    this.userUid,
    this.title,
    this.iconId,
    this.compartments,
  });

  static List<Backpack> fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null || jsonList.isEmpty) {
      return null;
    }

    var backpacks = List<Backpack>();

    for (var i = 0; i < jsonList.length; i++) {
      var backpack = jsonList[i];

      backpacks.add(Backpack.fromJson(backpack));
    }

    return backpacks;
  }

  static Backpack fromJson(dynamic json) {
    if (json == null || json.isEmpty) {
      return null;
    }

    var backpack = Backpack();

    backpack.guid = json['Guid'];
    backpack.userUid = json['UserUid'];
    backpack.title = json['Title'];
    backpack.iconId = json['IconId'];

    backpack.compartments = Compartment.fromJsonList(json['Compartments']);

    return backpack;
  }

  Map<String, dynamic> toJson() {
    List<Map> jsonCompartments = [];

    compartments?.forEach((e) {
      jsonCompartments.add(e.toJson());
    });

    return {
      'Guid': guid,
      'UserUid': userUid,
      'Title': title,
      'IconId': iconId,
      'Compartments': jsonCompartments
    };
  }
}
