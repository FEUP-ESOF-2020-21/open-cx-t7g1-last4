import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  //logout
  Future <void> signOut() async{
    await _firebaseAuth.signOut();
  }

  //login com email e password
  Future <String> logIn({String email, String password}) async{
      final currentUser = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return _firebaseAuth.currentUser.uid;
  }

  //singup com email e password
  Future <String> signUp({String email, String username, String password}) async{
    await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

    //update username
    _firebaseAuth.currentUser.updateProfile(displayName: username);
    _firebaseAuth.currentUser.reload();
    return _firebaseAuth.currentUser.uid;
  }

}
