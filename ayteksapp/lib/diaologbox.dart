import 'package:flutter/material.dart';

class DialogBox{

  bilgilendirmePenceresi(BuildContext context,String baslik,String icerik){
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text(baslik),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(icerik)
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Tamam'),
              onPressed: (){
                return Navigator.pop(context);
              },
            )
          ],
        );
      }

    );
  }
}