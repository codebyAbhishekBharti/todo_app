
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService{
  FirebaseAuth _auth = FirebaseAuth.instance;
  Future<User?> signUpWithEmailAndPassword(String email, String pass) async{
    try{
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: pass);
      return credential.user;
    }
    catch(e){
      print("Some error occurred");
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(String email, String pass) async{
    try{
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: pass);
      return credential.user;
    }
    catch (e){
      print("Some error occurred");
    }
    return null;
  }

}