import 'package:ayteksapp/LoginRegisterEkran.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ayteksapp/constants.dart';
import 'giris.dart';

class ChatEkran extends StatefulWidget {

  final AuthIslem auth;
  final VoidCallback onSignedOut;
  ChatEkran({this.auth,this.onSignedOut}); 

  @override
  _ChatEkranState createState() => _ChatEkranState();
}

class _ChatEkranState extends State<ChatEkran> {

  void _logoutUser() async{
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e.toString());
    }
  }
  
  String _value = 'mesajlarMuhasebe';
  final mesajKontroller=TextEditingController();
  final auth=FirebaseAuth.instance;
  User kullanici;

  final firestore=FirebaseFirestore.instance;
  String mesaj;
  void kullaniciGetir() async
  {
    try {
      final k=auth.currentUser;  //kullanıcıyı getirmek.
      if(k!=null){
        kullanici=k;
      }
    } catch (e) {
      print(e.message);
    }

  }  
  
  @override
  void initState() {
    super.initState();
    kullaniciGetir();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF32CD32),
      title:DropdownButton<String>(
          style: TextStyle(color: Colors.white,fontSize: 18),
          value: _value,
          dropdownColor: Color(0xFF32CD32),
          items: <DropdownMenuItem<String>>[
            new DropdownMenuItem(
              child: new Text('Muhasebe mesajlar'),
              value: 'mesajlarMuhasebe',
            ),
            new DropdownMenuItem(
              child: new Text('Depo mesajlar'),
              value: 'mesajlarDepo'
            ),
          ], 
          onChanged: (String value) {
            setState(() => _value = value);
          },)
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment:CrossAxisAlignment.stretch,
          children: [
            StreamBuilder<QuerySnapshot>(  //stream query veri tipi alır. //stream ile kanal oluşturur.
                stream: firestore.collection(_value).orderBy('gonderimZamanı',descending: true).snapshots(),
                builder: (context,snapshot){
                  if(!snapshot.hasData){
                    return Center(child: CircularProgressIndicator(backgroundColor: Colors.blueGrey,
                    ),
                    );
                  }
                  final mesajlar =snapshot.data.docs;  //mesaj belgeleri tutar.
                  List<MesajBaloncuk>mesajWidgetlar=[];
                  for (var mesaj in mesajlar) {
                    final mesajText=mesaj.data()['text'];
                    final mesajGonderici=mesaj.data()['gonderen'];
                    final mevcutKullanici=kullanici.email;


                    final mesajWidget=MesajBaloncuk(text: mesajText,gonderen: mesajGonderici, 
                    mevcutuser: mevcutKullanici==mesajGonderici,  //suanki kullanıcıyı tespit ederiz.
                    ); 
                    TextStyle(color: Colors.white);
                    mesajWidgetlar.add(mesajWidget); //mesajlar listeye aktarılır.
                    
                  }
                  return Expanded(child: ListView(
                    reverse: true,   //mesajların aşağıdan yukarı gitmesini sağlar.
                    padding: EdgeInsets.symmetric(horizontal: 10.0,vertical:20),
                    children: mesajWidgetlar,
                  )
                  );
                },
            ),

            Container(
              decoration: kMesajContainerDecoration,
              child: Row(crossAxisAlignment: CrossAxisAlignment.center,children:[
                Expanded(child: TextField(
                  controller: mesajKontroller,
                  onChanged: (value){
                    mesaj=value;
              },
              decoration: kMesajTextFieldDecoration,
            ),
            ),
            TextButton(onPressed: ()async{
              await firestore.collection(_value).add({
                'text':mesaj,
                'gonderen':kullanici.email,
                'gonderimZamanı':DateTime.now(),
              },);
              mesajKontroller.clear();
            }, child: Text('Gönder'),
            style: TextButton.styleFrom(primary: Color(0xFF32CD32), 
            textStyle: TextStyle(fontWeight: FontWeight.bold,fontSize:18.0),
            ),
            ),
          ],
          ),
          ),
          ],
          ),
        ),
    );
  }
}

class MesajBaloncuk extends StatelessWidget {
  final String text;
  final String gonderen;
  final bool mevcutuser;
  MesajBaloncuk({this.text,this.gonderen,this.mevcutuser});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: mevcutuser ? CrossAxisAlignment.end: CrossAxisAlignment.start,
        children: [Text('$gonderen',style: TextStyle(color: Colors.green),),
        SizedBox(height: 5),
        Material(
          borderRadius: mevcutuser ? BorderRadius.only(  //mesaj alanını kullanıcıya gore duzenler.
            topLeft: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            topRight: Radius.circular(0),
            bottomRight: Radius.circular(10),
          ):BorderRadius.only(
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10),
            topLeft: Radius.circular(0),
            bottomLeft: Radius.circular(10),
          ),
          elevation: 10,
          color: Color(0xFF32CD32),
          child: Padding(padding: EdgeInsets.symmetric(horizontal:20, vertical: 10),
          child: Text('$text',style: TextStyle(color: Colors.white,fontSize: 17),),
          ),
        ),
        ],
      ),
    );
  }
}