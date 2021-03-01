import 'package:bacqpack/model/item.dart';
import 'package:bacqpack/service/backpack_service.dart';
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
      body: DefaultTabController(
        length: 2,
        child: SafeArea(child: buildBody(context)),
      ),
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

        for (var e in snapshot.data.snapshot.value) {
          if (e != null) {
            backpack = Backpack.fromJson(e);
          }
        }

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildIcon(),
                  buildTitle(),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              buildTabs()
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

  Widget buildTitle() {
    return Expanded(
      child: Container(
          padding: EdgeInsets.only(left: 10),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Title",
                ),
                initialValue: backpack.title,
                onChanged: (v) {
                  backpack.title = v;

                  BackpackService.updateBackpack(backpack, () {});
                },
              ),
            ],
          )),
    );
  }

  Widget buildTabs() {
    return Expanded(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xff1ac988),
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                TabBar(
                  onTap: (index) {},
                  indicatorColor: Color(0xff1ac988),
                  tabs: [
                    Tab(
                      child: Text(
                        'Compartments',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Items',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      buildCompartmentsView(),
                      buildItemsView(),
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned(
            bottom: 5,
            right: 5,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff34afc2),
                borderRadius: BorderRadius.circular(90),
              ),
              padding: EdgeInsets.all(15),
              child: Icon(Icons.add),
            ),
          )
        ],
      ),
    );
  }

  Widget buildCompartmentsView() {
    if (backpack.compartments == null || backpack.compartments.isEmpty) {
      return buildEmptyView("compartments");
    }

    var compartments = <Widget>[];

    for (var compartment in backpack.compartments) {
      var itemCount = compartment.items?.length ?? 0;

      var widget = Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: MaterialButton(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onPressed: () {},
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Color(0xff1ac988),
                width: 1.5,
              ),
            ),
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                  compartment.title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "$itemCount items",
                ),
              ],
            ),
          ),
        ),
      );

      compartments.add(widget);
    }

    return Padding(
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Wrap(
          direction: Axis.horizontal,
          spacing: 10,
          children: compartments,
        ),
      ),
    );
  }

  Widget buildItemsView() {
    if (backpack.compartments == null || backpack.compartments.isEmpty) {
      return buildEmptyView("compartments");
    }

    var items = <Item>[];

    for (var compartment in backpack.compartments) {
      if (compartment.items == null) {
        continue;
      }

      items.addAll(compartment.items);
    }

    if (items.isEmpty) {
      return buildEmptyView("items");
    }

    return Container();
  }

  Widget buildEmptyView(String content) {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: "This backpack has no $content yet\nclick ",
            ),
            WidgetSpan(
              child: Icon(
                Icons.add,
                size: 15,
              ),
            ),
            TextSpan(
              text: " to add the first one",
            ),
          ],
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
