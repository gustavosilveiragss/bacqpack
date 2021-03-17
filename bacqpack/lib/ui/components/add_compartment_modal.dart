import 'package:bacqpack/model/backpack.dart';
import 'package:bacqpack/model/compartment.dart';
import 'package:bacqpack/service/backpack_service.dart';
import 'package:bacqpack/utils/helper.dart';
import 'package:bacqpack/utils/session_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';

class AddCompartmentModal extends StatefulWidget {
  final Compartment compartment;
  final Backpack backpack;

  AddCompartmentModal(this.backpack, {this.compartment});

  @override
  _AddCompartmentModalState createState() => _AddCompartmentModalState();
}

class _AddCompartmentModalState extends State<AddCompartmentModal> {
  Compartment compartment;
  Backpack backpack;

  @override
  void initState() {
    super.initState();

    backpack = widget.backpack;
    compartment = widget.compartment ?? Compartment();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Builder(
          builder: (context) {
            SessionVariables.lastPageContext = context;

            return Stack(
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
                              children: [
                                Text(
                                  compartment.guid != null && compartment.guid != ""
                                      ? "Edit Compartment"
                                      : "Add Compartment",
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
                                          labelText: 'Compartment title',
                                        ),
                                        initialValue: compartment.title ?? "",
                                        onChanged: (v) {
                                          compartment.title = v;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    compartment.guid != null && compartment.guid != ""
                                        ? MaterialButton(
                                            onPressed: () {
                                              for (var i = 0; i < backpack.compartments.length; i++) {
                                                if (backpack.compartments[i].guid != compartment.guid) {
                                                  continue;
                                                }

                                                backpack.compartments.removeAt(i);
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
                                        if (compartment.title == null || compartment.title == "") {
                                          Helper.showError("Add the compartment's title");

                                          return;
                                        }

                                        if (compartment.guid == null || compartment.guid == "") {
                                          // new compartment

                                          compartment.guid = Guid.newGuid.toString();

                                          if (backpack.compartments == null) {
                                            backpack.compartments = <Compartment>[];
                                          }

                                          backpack.compartments.add(compartment);
                                        } else {
                                          // edit compartment

                                          for (var i = 0; i < backpack.compartments.length; i++) {
                                            if (backpack.compartments[i].guid != compartment.guid) {
                                              continue;
                                            }

                                            backpack.compartments[i] = compartment;
                                          }
                                        }

                                        BackpackService.updateBackpack(backpack, () {});

                                        Navigator.pop(context);
                                      },
                                      padding: EdgeInsets.symmetric(horizontal: 5),
                                      minWidth: 0,
                                      child: Text(
                                        compartment.guid != null && compartment.guid != "" ? "Edit" : "Add",
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
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
