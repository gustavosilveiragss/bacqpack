import 'package:bacqpack/ui/components/error_modal.dart';
import 'package:flutter/material.dart';

class Helper {
  static void showError(BuildContext context, String message) {
    showGeneralDialog(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      //transitionDuration: Duration(milliseconds: 800),
      pageBuilder: (context, anim1, anim2) {
        Future.delayed(Duration(seconds: 8), () {
          //Navigator.of(context).pop(true);
        });

        return ErrorModal(message);
      },
      /*transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },*/
    );
  }
}
