import 'package:flutter/material.dart';
import 'giris.dart';
import 'package:flutter/material.dart';

class cikisEkran extends StatefulWidget {

   final AuthIslem auth;
   final VoidCallback onSignedOut;

   cikisEkran({this.auth,this.onSignedOut}); 


  @override
  _cikisEkranState createState() => _cikisEkranState();
}

class _cikisEkranState extends State<cikisEkran> {
  

  void _logoutUser() async{
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Padding(
            padding: EdgeInsets.all(30),
            child:ElevatedButton(onPressed: _logoutUser,
                  style: ElevatedButton.styleFrom(elevation: 10), 
                  child: Text(' Elevated Button'))),));
              

  }}