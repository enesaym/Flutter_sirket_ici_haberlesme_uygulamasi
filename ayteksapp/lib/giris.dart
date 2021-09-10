import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthIslem{
  Future <String> signIn(String mail,String parola) ;
  Future <String> signUp(String mail,String parola);
  Future<Void> signOut();
  Future <String> getCurrentUser();
}

class AuthService implements AuthIslem {
  
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  
  Future <String> signIn(String mail,String parola) async{
    UserCredential result=await _firebaseAuth.signInWithEmailAndPassword(email: mail, password: parola);
    User user=result.user;
    return user.uid;
  }
  Future <String> signUp(String mail,String parola) async{
    UserCredential result=await _firebaseAuth.createUserWithEmailAndPassword(email: mail, password: parola);
    User user=result.user;
    return user.uid;
  }

  Future<Void> signOut() async{
    await _firebaseAuth.signOut();
  }

  Future<String> getCurrentUser() async {
    User user = await _firebaseAuth.currentUser;
    if(user==null){
      return null;
    }
    return user.uid;
  }
}


