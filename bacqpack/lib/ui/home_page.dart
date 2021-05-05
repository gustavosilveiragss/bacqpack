import 'package:bacqpack/utils/helper.dart';
import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:popup_menu/popup_menu.dart';

import 'package:bacqpack/model/backpack.dart';
import 'package:bacqpack/utils/session_variables.dart';
import 'package:bacqpack/ui/backpack_manager.dart';
import 'package:bacqpack/service/backpack_service.dart';

final databaseReference = FirebaseDatabase.instance.reference();

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List<Backpack> backpacks = [];

  var tabs = <Tab>[
    Tab(
      child: Text(
        'Backpacks',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    ),
    Tab(
      child: Text(
        'Checklists',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    ),
  ];

  int currentTab = 0;

  TabController tabController;

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: tabs.length, vsync: this);

    tabController.addListener(() {
      setState(() {
        currentTab = tabController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        SessionVariables.lastPageContext = context;

        return DefaultTabController(
          length: 2,
          child: SafeArea(child: buildBody(context)),
        );
      }),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        overlayOpacity: 0.3,
        backgroundColor: Color(0xff1ac988),
        children: [
          SpeedDialChild(
            child: SvgPicture.asset(
              "assets/svg/backpack_add.svg",
              height: 28,
            ),
            label: "Add backpack",
            backgroundColor: Color(0xff34afc2),
            labelBackgroundColor: Colors.white,
            onTap: () {
              var backpack = Backpack(
                guid: Guid.newGuid.toString(),
                userUid: SessionVariables.userUid,
                title: "New backpack",
                iconId: "backpack_1",
              );

              BackpackService.newBackpack(backpack, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BackpackManager(backpack),
                  ),
                );
              });
            },
          ),
          SpeedDialChild(
            child: SvgPicture.asset(
              "assets/svg/checklist_add.svg",
              height: 28,
            ),
            label: "Add checklist",
            backgroundColor: Color(0xff00e34e),
            labelBackgroundColor: Colors.white,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return StreamBuilder(
      stream: databaseReference
          .child("Backpacks")
          .orderByChild("UserUid")
          .equalTo(SessionVariables.userUid)
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

        var backpackMaps = snapshot.data.snapshot.value;

        backpacks = [];

        for (var b in backpackMaps) {
          backpacks.add(Backpack.fromJson(b));
        }

        return Column(
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
            TabBar(
              onTap: (index) {},
              indicatorColor: Color(0xff1ac988),
              controller: tabController,
              tabs: tabs,
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  buildBackpackList(),
                  Container(),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Widget buildBackpackList() {
    List<Widget> backpacksWidgets = [];

    for (var backpack in backpacks) {
      var backpackWidget = renderBackpackCard(backpack);

      backpacksWidgets.add(backpackWidget);
    }

    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 30),
      children: backpacksWidgets,
    );
  }

  Widget renderBackpackCard(Backpack backpack) {
    double _height = 150;
    double _width = MediaQuery.of(context).size.width;

    var itemCount = 0;

    backpack.compartments?.forEach((e) {
      itemCount += e.items?.length ?? 0;
    });

    PopupMenu.context = context;

    void showPopup(Offset offset) {
      PopupMenu menu = PopupMenu(
        maxColumn: 1,
        items: [
          MenuItem(
            title: 'Delete',
            image: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ],
        onClickMenu: (MenuItemProvider item) {
          BackpackService.deleteBackpack(backpack, () {
            Helper.showError("${backpack.title} deleted", floating: false);
          });
        },
      );
      menu.show(rect: Rect.fromPoints(offset, offset));
    }

    return GestureDetector(
      onLongPressEnd: (LongPressEndDetails details) {
        showPopup(details.globalPosition);
      },
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BackpackManager(backpack),
          ),
        );
      },
      child: Container(
        height: _height,
        width: _width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Color(0xff1ac988),
            width: 1.5,
          ),
          color: Colors.white,
        ),
        margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/svg/backpack_icons/${backpack.iconId}.svg',
              height: 120,
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    backpack.title,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      '${backpack.compartments?.length ?? 0} compartments',
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Text(
                    '$itemCount items',
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
