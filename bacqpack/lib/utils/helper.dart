import 'package:bacqpack/utils/session_variables.dart';
import 'package:flutter/material.dart';

class Helper {
  static void showError(String message, {bool floating = true}) {
    final snackBar = SnackBar(
      elevation: 20,
      backgroundColor: Colors.red,
      behavior: floating ? SnackBarBehavior.floating : SnackBarBehavior.fixed,
      content: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 2.0,
                color: Colors.white,
              ),
              borderRadius: BorderRadius.all(Radius.circular(90)),
            ),
            child: Transform.rotate(
              angle: 180,
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            message,
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    );

    Scaffold.of(SessionVariables.lastPageContext).showSnackBar(snackBar);
  }
}
