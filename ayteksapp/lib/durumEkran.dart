import 'package:ayteksapp/LoginRegisterEkran.dart';
import 'package:ayteksapp/PhotoUpload.dart';
import 'package:ayteksapp/chatEkran.dart';
import 'package:flutter/material.dart';
import 'giris.dart';
import 'Posts.dart';
import 'package:ayteksapp/LoginRegisterEkran.dart';
import 'package:firebase_database/firebase_database.dart';


class durumEkran extends StatefulWidget {

   final AuthIslem auth;
   final VoidCallback onSignedOut;

   durumEkran({this.auth,this.onSignedOut}); 


  @override
  _durumEkranState createState() => _durumEkranState();
}

class _durumEkranState extends State<durumEkran> {

  List<Posts> postList=[];

  void _logoutUser() async{
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e.toString());
    }
  }
  @override
  void initState() {
    super.initState();
    DatabaseReference ref=FirebaseDatabase.instance.reference().child("Postlar"); //realtime postların referansı

    ref.once().then((DataSnapshot snap){

      var idler=snap.value.keys;  //verilerin key değerlerini alır
      var veriler=snap.value;
      postList.clear();

      for (var inKey in idler) {
        Posts post=new Posts(
          resim: veriler[inKey]['resim'],
          aciklama: veriler[inKey]['açıklama'],
          tarih: veriler[inKey]['tarih'],
          saat: veriler[inKey]['saat']
        );
        postList.add(post);
      }
      setState(() {
        print(postList.length);
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF32CD32),
      body: Container(
        child: postList.length==0 ? Text("Henüz post eklenmedi"):ListView.builder(
          itemCount: postList.length,itemBuilder: (_,index){
            return postCard(postList[index].resim, postList[index].aciklama, postList[index].tarih, postList[index].saat);
          }
          ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color(0xFF32CD32),
        child: Container(
          margin: EdgeInsets.only(left:50,right:20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              IconButton( 
              color: Colors.white,
              icon: Icon(Icons.message), 
              onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (_)=>ChatEkran()));}),
              IconButton( 
              iconSize: 40,
              color: Colors.white,
              icon: Icon(Icons.add_a_photo), 
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>PhotoUploadPage()));
              }),
              IconButton( 
              color: Colors.red,
              icon: Icon(Icons.exit_to_app), 
              onPressed: _logoutUser)
            ],
          ),
        ),
      ),
    );
  }
Widget postCard(String resim,String aciklama,String tarih,String saat){
      return Card(
        elevation: 10.0,
        margin: EdgeInsets.all(15.0),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    tarih,
                    style: Theme.of(context).textTheme.subtitle,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    saat,
                    style: Theme.of(context).textTheme.subtitle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SizedBox(height:15),
              Image.network(resim,fit: BoxFit.cover,),
              SizedBox(height: 10,),
              Text(aciklama,
                style: Theme.of(context).textTheme.subhead,
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      );
  }
}