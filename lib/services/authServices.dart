// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';

// class AuthService{
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//   User? _user;

//   User? get user{
//     return _user;
//   }

//   AuthService(){} //constructor

//   Future<bool> login(String email, String password) async{
//     try {
//       final credential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
//       if(credential!=null){
//         _user = credential.user;
//         return true;
//       }
//     } catch (e) {
//       debugPrint(e.toString());
//     }
//     return false;
//   }

// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? _user;

  User? get user {
    return _user;
  } //Keyword: get
// This keyword defines the function as a getter.

  AuthService() {
    _user = _firebaseAuth.currentUser;
  }

  Future<bool> login(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if (credential != null) {
        _user = credential.user;
        return true;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future<bool> isUserLoggedIn() async {
    _user = _firebaseAuth.currentUser;
    return _user != null;
  }

  Future<bool> logout() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future<bool> signup(String email, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (credential.user != null) {
        _user = credential.user;
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }
}

//we want to make this auth service to different partb of our application andwe can do it using get package!! in get package we will register this class

//in utils we can crreate it

//after creating registerServices we ill call it in in main 