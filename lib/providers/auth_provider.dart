import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:kios_agro/models/user_model.dart';
import 'package:kios_agro/providers/user_provider.dart';

enum Status {
  Uninitialized,
  Authenticated,
  Authenticating,
  Unauthenticated,
}

class AuthProvider extends ChangeNotifier {
  FirebaseAuth _auth;
  FirebaseUser _user;
  UserModel _userModel;

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ]);

  Status _status = Status.Authenticated;

  AuthProvider.instance() : _auth = FirebaseAuth.instance {
    _auth.onAuthStateChanged.listen(_onAuthStateChanged);
  }

  Status get status => _status;
  FirebaseUser get user => _user;
  UserModel get userModel => _userModel;

  Future<bool> signIn(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      var user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      _user = user.user;
      if (user.user == null) {
        _status = Status.Unauthenticated;
        notifyListeners();
        return false;
      } else {
        return true;
      }
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(
      String name,
      String email,
      String password,
      String noTelp,
      String alamat,
      String kecamatan,
      String kabupaten,
      String provinsi,
      var idKec,
      var idKab,
      var idProv) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();

      var userAuth = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      print('regis');

      var newUser = {
        'alamat': {
          'id': idKec,
          'id_kabupaten': idKab,
          'id_provinsi': idProv,
          'alamat': alamat,
          'kecamatan': kecamatan,
          'kabupaten': kabupaten,
          'provinsi': provinsi
        },
        'balance': 0,
        'bank': '',
        'holder': '',
        'email': email,
        'mutasi': [],
        'nama': name,
        'namatoko': '',
        'orders': {
          'seller': [],
          'buyyer': [],
        },
        'pengiriman': '',
        'player_id': '',
        'products': [],
        'rating': [],
        'rekening': '',
        'subscribe': 'free',
        'surname': '',
        'telepon': noTelp,
        'urltoko': '',
        'verifyshop': false,
      };

      FirebaseDatabase.instance
          .reference()
          .child('/users/${userAuth.user.uid.toString()}')
          .set(newUser)
          .then((value) => print('berhasil'))
          .catchError((e) => print(e));

      return true;
    } catch (e) {
      _status = Status.Uninitialized;
      notifyListeners();
      return false;
    }
  }

  Future googleSignIn() async {
    try {
      _status = Status.Authenticating;
      notifyListeners();

      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final AuthResult authResult =
          await _auth.signInWithCredential(credential);
      _user = authResult.user;

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await _auth.currentUser();

      assert(user.uid == currentUser.uid);

      FirebaseDatabase.instance
          .reference()
          .child('/users/${_user.uid.toString()}')
          .once()
          .then(
        (value) {
          if (value.value == null) {
            var newUser = {
              'alamat': {
                'id': '',
                'id_kabupaten': '',
                'id_provinsi': '',
                'alamat': '',
                'kecamatan': '',
                'kabupaten': '',
                'provinsi': ''
              },
              'email': _user.email,
              'mutasi': [],
              'nama': _user.displayName,
              'namatoko': '',
              'orders': {
                'seller': [],
                'buyyer': [],
              },
              'pengiriman': '',
              'player_id': '',
              'products': [],
              'rating': [],
              'rekening': '',
              'subscribe': 'free',
              'surname': '',
              'telepon': '',
              'urltoko': '',
              'verifyshop': false,
            };

            FirebaseDatabase.instance
                .reference()
                .child('/users/${_user.uid.toString()}')
                .update(newUser)
                .then((value) => print('berhasil'))
                .catchError((e) => print(e));
          }
        },
      );

      _status = Status.Authenticated;

      notifyListeners();
    } catch (e) {
      setStatus(Status.Uninitialized);
      notifyListeners();
    }
  }

  Future signOut() async {
    await _auth.signOut().then((value) => print('success'));
    _status = Status.Unauthenticated;
    notifyListeners();
  }

  Future<void> _onAuthStateChanged(FirebaseUser firebaseUser) async {
    print(firebaseUser.displayName);
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
    } else {
      _user = firebaseUser;
      _status = Status.Authenticated;
      UserProvider().getUserData(_user.uid);
    }
    notifyListeners();
  }

  void setStatus(newStatus) {
    _status = newStatus;
    notifyListeners();
  }
}
