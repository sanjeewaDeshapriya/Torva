import 'package:firebase_auth/firebase_auth.dart';
import 'package:torva/models/userModel.dart';

class AuthService {
  // firebase instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //  crate User Model
  Usermodel? _userWithFirebaseUID(User? user) {
    return user != null ? Usermodel(uid: user.uid) : null;
  }

  Stream<Usermodel?> get user {
    return _auth.authStateChanges().map(_userWithFirebaseUID);
  }

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

  //signOut
  Future signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  //signIn with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userWithFirebaseUID(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  //register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userWithFirebaseUID(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
