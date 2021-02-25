import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:bacqpack/utils/session_variables.dart';
import 'package:bacqpack/model/backpack.dart';
import 'package:bacqpack/service/backpack_service.dart';

class BackpackIconModal extends StatefulWidget {
  final Backpack backpack;

  BackpackIconModal(this.backpack);

  @override
  _BackpackIconModalState createState() => _BackpackIconModalState();
}

class _BackpackIconModalState extends State<BackpackIconModal> {
  Backpack backpack;

  @override
  void initState() {
    super.initState();

    backpack = widget.backpack;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(20),
        color: Colors.white,
        child: loadIcons(),
      ),
    );
  }

  Widget loadIcons() {
    List<Widget> icons = [];

    var manifestMap = json.decode(SessionVariables.manifestContent);

    Widget buildIcon(String file) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: MaterialButton(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onPressed: () {
            backpack.iconId = file
                .replaceAll("assets/svg/backpack_icons/", "")
                .replaceAll(".svg", "");

            BackpackService.updateBackpack(
              backpack,
              () {
                Navigator.pop(context);
              },
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Color(0xff1ac988),
                width: 1.5,
              ),
            ),
            padding: EdgeInsets.all(5),
            child: SvgPicture.asset(
              file,
              width: 100,
            ),
          ),
        ),
      );
    }

    for (var key in manifestMap.keys) {
      if (key.contains('svg/backpack_icons')) {
        icons.add(buildIcon(key));
      }
    }

    return SingleChildScrollView(
      child: Wrap(
        direction: Axis.horizontal,
        spacing: 10,
        children: icons,
      ),
    );
  }
}
