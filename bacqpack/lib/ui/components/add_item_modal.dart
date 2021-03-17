import 'package:bacqpack/model/backpack.dart';
import 'package:bacqpack/model/compartment.dart';
import 'package:bacqpack/model/item.dart';
import 'package:bacqpack/service/backpack_service.dart';
import 'package:bacqpack/utils/helper.dart';
import 'package:bacqpack/utils/session_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';

class AddItemModal extends StatefulWidget {
  final Item item;
  final Backpack backpack;

  AddItemModal(this.backpack, {this.item});

  @override
  _AddItemModalState createState() => _AddItemModalState();
}

class _AddItemModalState extends State<AddItemModal> {
  Item item;
  Backpack backpack;
  Compartment compartment;

  @override
  void initState() {
    super.initState();

    backpack = widget.backpack;
    item = widget.item ?? Item();

    if (item.compartmentGuid != null && item.compartmentGuid != "") {
      compartment = backpack.compartments.singleWhere((e) => e.guid == item.compartmentGuid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Builder(
          builder: (context) {
            SessionVariables.lastPageContext = context;

            return Container(
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    child: Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 300,
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    item.guid != null && item.guid != "" ? "Edit Item" : "Add Item",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        TextFormField(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xff4f95fc),
                                                width: 1,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xff4f95fc),
                                                width: 1,
                                              ),
                                            ),
                                            labelText: 'Item title',
                                          ),
                                          initialValue: item.title ?? "",
                                          onChanged: (v) {
                                            item.title = v;
                                          },
                                        ),
                                        DropdownButton<String>(
                                          hint: Text(
                                            "Pick the item's compartment",
                                          ),
                                          isExpanded: true,
                                          value: compartment?.title,
                                          items: backpack.compartments.map((Compartment c) {
                                            return DropdownMenuItem<String>(
                                              value: c.title,
                                              child: Text(
                                                c.title,
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (c) {
                                            setState(() {
                                              for (var i = 0; i < backpack.compartments.length; i++) {
                                                if (backpack.compartments[i].title.toLowerCase() !=
                                                    c.toLowerCase()) {
                                                  if (item.guid != null && item.guid != "") {
                                                    backpack.compartments[i].items
                                                        .removeWhere((e) => e.guid == item.guid);
                                                  }

                                                  continue;
                                                }

                                                compartment = backpack.compartments[i];
                                                item.compartmentGuid = compartment.guid;

                                                if (compartment.items == null) {
                                                  compartment.items = <Item>[];
                                                }

                                                compartment.items.add(item);
                                              }
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      item.guid != null && item.guid != ""
                                          ? MaterialButton(
                                              onPressed: () {
                                                for (var i = 0; i < backpack.compartments.length; i++) {
                                                  if (backpack.compartments[i].guid != compartment.guid) {
                                                    continue;
                                                  }

                                                  backpack.compartments[i].items
                                                      .removeWhere((e) => e.guid == item.guid);
                                                }

                                                BackpackService.updateBackpack(backpack, () {});

                                                Navigator.pop(context);
                                              },
                                              padding: EdgeInsets.symmetric(horizontal: 5),
                                              minWidth: 0,
                                              child: Text(
                                                "Remove",
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            )
                                          : Container(),
                                      MaterialButton(
                                        onPressed: () {
                                          SessionVariables.lastPageContext = context;

                                          if (item.title == null || item.title == "") {
                                            Helper.showError("Add the item's title");

                                            return;
                                          }

                                          if (item.compartmentGuid == null || item.compartmentGuid == "") {
                                            Helper.showError("Add the item's compartment");

                                            return;
                                          }

                                          if (compartment.items == null) {
                                            compartment.items = <Item>[];
                                          }

                                          if (item.guid == null || item.guid == "") {
                                            // new item

                                            item.guid = Guid.newGuid.toString();
                                          } else {
                                            // edit item

                                            for (var i = 0; i < compartment.items.length; i++) {
                                              if (compartment.items[i].guid != item.guid) {
                                                continue;
                                              }

                                              compartment.items[i] = item;
                                            }
                                          }

                                          for (var i = 0; i < backpack.compartments.length; i++) {
                                            if (backpack.compartments[i].guid != compartment.guid) {
                                              continue;
                                            }

                                            backpack.compartments[i] = compartment;
                                          }

                                          BackpackService.updateBackpack(backpack, () {});

                                          Navigator.pop(context);
                                        },
                                        padding: EdgeInsets.symmetric(horizontal: 5),
                                        minWidth: 0,
                                        child: Text(
                                          item.guid != null && item.guid != "" ? "Edit" : "Add",
                                          style: TextStyle(
                                            color: Color(0xff00e34e),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
