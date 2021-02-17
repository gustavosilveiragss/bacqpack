class Item {
  String guid;
  String title;

  Item({
    this.guid, 
    this.title
  });

  static List<Item> fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null || jsonList.isEmpty) {
      return null;
    }

    var items = List<Item>();

    for (var i = 0; i < jsonList.length; i++) {
      var item = jsonList[i];

      items.add(Item.fromJson(item));
    }

    return items;
  }

  static Item fromJson(dynamic json) {
    if (json == null || json.isEmpty) {
      return null;
    }

    var item = Item();

    item.guid = json['Guid'];
    item.title = json['Title'];

    return item;
  }
}
