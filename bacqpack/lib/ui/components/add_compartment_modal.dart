import 'package:flutter/material.dart';

class AddCompartmentModal extends StatefulWidget {
  final Function callback;

  AddCompartmentModal(this.callback);

  @override
  _AddCompartmentModalState createState() => _AddCompartmentModalState();
}

class _AddCompartmentModalState extends State<AddCompartmentModal> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.callback("working");

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
        child: Container(),
      ),
    );
  }
}
