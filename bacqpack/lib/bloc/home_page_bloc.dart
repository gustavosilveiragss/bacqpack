import 'package:bacqpack/model/backpack.dart';
import 'package:bacqpack/utils/session_variables.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rxdart/rxdart.dart';

class HomePageBloc {
  var _backpacks = BehaviorSubject<List<Backpack>>();
  get backpacks => _backpacks.stream;

  void getBackpacks() async {
    final databaseReference = FirebaseDatabase.instance.reference();

    List<Backpack> tempBackpacks = [];

    var snapshot = await databaseReference.child("Backpacks").once();

    for (var backpack in snapshot.value) {
      if (backpack["UserUid"] != SessionVariables.userUid) {
        continue;
      }

      tempBackpacks.add(Backpack.fromJson(backpack));
    }

    backpacks.add(tempBackpacks);
  }

  void dispose() {
    _backpacks.close();
  }
}
