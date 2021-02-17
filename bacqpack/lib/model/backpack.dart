import 'package:bacqpack/model/compartment.dart';

class Backpack {
  String guid;
  String userUid;
  String title;
  String base64Image;
  List<Compartment> compartments;

  Backpack({
    this.guid,
    this.title,
    this.base64Image,
    this.compartments
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
    backpack.base64Image = json['Base64Image'];

    backpack.compartments = Compartment.fromJsonList(json['Compartments']);

    return backpack;
  }
}
