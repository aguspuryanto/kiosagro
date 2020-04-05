import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kios_agro/providers/auth_provider.dart';

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
  }
}
