import 'package:flutter/material.dart';

import 'package:bacqpack/model/backpack.dart';
import 'package:bacqpack/ui/components/backpack_icon_modal.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BackpackManager extends StatefulWidget {
  final Backpack backpack;

  BackpackManager(this.backpack);

  @override
  _BackpackManagerState createState() => _BackpackManagerState();
}

class _BackpackManagerState extends State<BackpackManager> {
  Backpack backpack;

  final databaseReference = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();

    backpack = widget.backpack;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: buildBody(context)),
    );
  }

  Widget buildBody(BuildContext context) {
    return StreamBuilder(
      stream: databaseReference
          .child("Backpacks")
          .orderByChild("Guid")
          .equalTo(backpack.guid)
          .onValue,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        backpack = Backpack.fromJson(snapshot.data.snapshot.value[0]);

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              SvgPicture.asset(
                'assets/svg/logo.svg',
                width: MediaQuery.of(context).size.width / 2,
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Row(
                    children: [
                      buildIcon(),
                    ],
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget buildIcon() {
    return MaterialButton(
      onPressed: () {
        showDialog(context: context, child: BackpackIconModal(backpack));
      },
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Color(0xff1ac988),
                width: 1.5,
              ),
            ),
            padding: EdgeInsets.all(5),
            child: SvgPicture.asset(
              'assets/svg/backpack_icons/${backpack.iconId}.svg',
              width: MediaQuery.of(context).size.width / 3,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.6),
              ),
              padding: EdgeInsets.all(2),
              child: Icon(Icons.edit),
            ),
          )
        ],
      ),
    );
  }
}
