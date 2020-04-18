import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel _user = null;

  UserModel get user => _user;

  getUserData(uid) {
    FirebaseDatabase()
        .reference()
        .child('users/${uid.toString()}')
        .once()
        .then((value) {
      _user = UserModel.fromSnapshot(value.key, value.value);
    });
    notifyListeners();
  }

  updateData(accountData) async {
    await FirebaseDatabase.instance
        .reference()
        .child('/users/${_user.key.toString()}')
        .update(accountData)
        .then((value) {
      getUserData(_user.key);
      return true;
    }).catchError((e) {
      print(e);
      return false;
    });
    return true;
  }
}
