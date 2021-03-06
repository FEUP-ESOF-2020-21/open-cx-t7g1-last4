import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  //logout
  Future <void> signOut() async{
    await _firebaseAuth.signOut();
  }

  //retorna o utilizador que está logado
  Future getCurrentUser() async{
    return _firebaseAuth.currentUser;
  }

  //retorna o id do utilizador
  Future getuid() async{
    return _firebaseAuth.currentUser.uid;
  }

  //login com email e password
  Future <String> logIn({String email, String password}) async{
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
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

// classe que verifica se o email é válido
class EmailValidator {
  static String validate(String value){
    if (value.isEmpty){
      return "Email can't be empty";
    }
    return null;
  }
}

// classe que verifica se a password é válida
class PasswordValidator {
  static String validate(String value){
    if (value.isEmpty){
      return "Password can't be empty";
    }
    return null;
  }
}
