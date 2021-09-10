import 'package:ayteksapp/c%C4%B1k%C4%B1sEkran.dart';
import 'package:ayteksapp/durumEkran.dart';
import 'package:flutter/material.dart';
import 'package:ayteksapp/chatEkran.dart';
import 'giris.dart';


class GovdeEkran extends StatefulWidget {

  @override
  _GovdeEkranState createState() => _GovdeEkranState();
}

class _GovdeEkranState extends State<GovdeEkran> {

  int _seciliIndex=0;
  List<Widget> _WidgetOptions = <Widget> [
      ChatEkran(),
      durumEkran(),
      cikisEkran(),
  ];

  void _itemTiklama(int index){
    setState(() {
      _seciliIndex=index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _WidgetOptions.elementAt(_seciliIndex),
      ),
      bottomNavigationBar:BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 1,
        iconSize: 30,
        backgroundColor: Colors.deepOrange,
        items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.message),label: '',),
        BottomNavigationBarItem(icon: Icon(Icons.home),label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.exit_to_app),label: ''),
      ],
      currentIndex: _seciliIndex,
      onTap: _itemTiklama,
      ),
    );
  }
}