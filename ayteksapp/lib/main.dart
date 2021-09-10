import 'package:ayteksapp/LoginRegisterEkran.dart';
import 'package:ayteksapp/durumEkran.dart';
import 'package:ayteksapp/giris.dart';
import 'package:ayteksapp/mapping.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(AyteksApp());
}

class AyteksApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "AYTEKS app",
      theme: ThemeData(
        primaryColor: Colors.black
      ),
      home: MappingPage(auth: AuthService()),
    );
  }
}