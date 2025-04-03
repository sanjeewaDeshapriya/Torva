
import 'package:firebase_auth/firebase_auth.dart';
import 'package:torva/models/userModel.dart';

class AuthService {
  // firebase instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //  crate User Model
  Usermodel? _userWithFirebaseUID(User? user) {
    return user != null ? Usermodel(uid: user.uid) : null;
  }

  // Stream<Usermodel> get user {
  //   _auth.authStateChanges().map(_userWithFirebaseUID(user));
  // }

  Future signInAnonymously() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userWithFirebaseUID(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
