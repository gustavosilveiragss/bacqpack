import 'package:bacqpack/model/item.dart';

class Compartment {
  String guid;
  String title;
  List<Item> items;

  Compartment({this.guid, this.title, this.items});

  static List<Compartment> fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null || jsonList.isEmpty) {
      return null;
    }

    var compartments = List<Compartment>();

    for (var i = 0; i < jsonList.length; i++) {
      var compartment = jsonList[i];

      compartments.add(Compartment.fromJson(compartment));
    }

    return compartments;
  }

  static Compartment fromJson(dynamic json) {
    if (json == null || json.isEmpty) {
      return null;
    }

    var compartment = Compartment();

    compartment.guid = json['Guid'];
    compartment.title = json['Title'];

    compartment.items = Item.fromJsonList(json['Items']);

    return compartment;
  }
}
