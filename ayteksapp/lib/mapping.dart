import 'package:ayteksapp/c%C4%B1k%C4%B1sEkran.dart';
import 'package:ayteksapp/chatEkran.dart';
import 'package:ayteksapp/giris.dart';
import 'package:ayteksapp/durumEkran.dart';
import 'package:ayteksapp/LoginRegisterEkran.dart';
import 'package:ayteksapp/govdeEkran.dart';
import 'package:flutter/material.dart';

class MappingPage extends StatefulWidget {

  final AuthIslem auth;
  MappingPage({this.auth});

  @override
  _MappingPageState createState() => _MappingPageState();
}

enum AuthStatus{
  signIn,notSignIn
}

class _MappingPageState extends State<MappingPage> {


  AuthStatus authStatus=AuthStatus.notSignIn;

  @override
  void initState() {
    super.initState();

    widget.auth.getCurrentUser().then((firebaseUserId){

      setState(() {
        if(firebaseUserId==null){
          authStatus=AuthStatus.notSignIn;
        }else{
          authStatus=AuthStatus.signIn;
        }
      });
    });
  }

  void _signedIn(){
    setState(() {
      authStatus=AuthStatus.signIn;
    });
  }

  void _signOut(){
    setState(() {
      authStatus=AuthStatus.notSignIn;
    });
  }


  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notSignIn:
        return LoginRegisterEkran(
          auth: widget.auth,
          onSignedIn: _signedIn,
        );
        break;
      case AuthStatus.signIn:
      return durumEkran(
        auth: widget.auth,
        onSignedOut: _signOut,
      );
      break;
      default:
        return null;
    }
  }
}