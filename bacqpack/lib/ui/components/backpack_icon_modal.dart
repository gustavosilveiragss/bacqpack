import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:bacqpack/utils/session_variables.dart';

class BackpackIconModal extends StatefulWidget {
  @override
  _BackpackIconModalState createState() => _BackpackIconModalState();
}

class _BackpackIconModalState extends State<BackpackIconModal> {
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

    Widget buildIconContainer(String file) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Color(0xff1ac988),
            width: 1.5,
          ),
        ),
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.symmetric(vertical: 10),
        child: SvgPicture.asset(
          file,
          width: 100,
        ),
      );
    }

    for (var key in manifestMap.keys) {
      if (key.contains('svg/backpack_icons')) {
        icons.add(buildIconContainer(key));
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
