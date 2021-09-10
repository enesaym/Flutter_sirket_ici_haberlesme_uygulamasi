import 'package:ayteksapp/durumEkran.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';



class PhotoUploadPage extends StatefulWidget {
  @override
  _PhotoUploadPageState createState() => _PhotoUploadPageState();
}

class _PhotoUploadPageState extends State<PhotoUploadPage> {

  final _formKey=GlobalKey<FormState>();
  String _myValue="";
  File _image;
  final picker=ImagePicker();
  String url;

  Future getImage() async{
    final pickedFile=await picker.getImage(source: ImageSource.camera); // cameradan fotograf secme.
    setState(() {
      _image=File(pickedFile.path);
    });
  }
  
  bool kaydet(){
    final form=_formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }else{
      return false;
    }
  }

  void resimYukle() async{
    if(kaydet()){
      final Reference postResimRef=FirebaseStorage.instance.ref().child('postResimler');
      var timeKey=new DateTime.now();
      final UploadTask uploadTask=postResimRef.child(timeKey.toString()+'.jpg').putFile(_image);
      var imageUrl=await (await uploadTask).ref.getDownloadURL();
      url=imageUrl.toString();
      anasayfayaGit();
      veritabaninaKaydet(url);
    }
  }

  void veritabaninaKaydet(url){
    var dbTimeKey=new DateTime.now();
    var formatDate=new DateFormat("MMM d,yyyy");
    var formatTime=new DateFormat("EEE, hh:mm aaa");
    String date=formatDate.format(dbTimeKey);
    String time=formatTime.format(dbTimeKey);
    DatabaseReference dbRef=FirebaseDatabase.instance.reference();
    var data={
      "resim":url,
      "açıklama":_myValue,
      "tarih":date,
      "saat":time,
    };

  dbRef.child("Postlar").push().set(data);

  }

  void anasayfayaGit(){
    Navigator.push(context,MaterialPageRoute(builder:(context)=>durumEkran()));
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Resim Yükle"),
        centerTitle: true,
        ),
        body: Center(child: _image==null ? Text("Henüz resim yüklenmedi"):resimPost(),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.orange,
          tooltip: 'Resim yükle',
          child: Icon(Icons.add_a_photo),
          onPressed: getImage,
        ),
    );
  }

  Widget resimPost(){
    return Container(
      margin: EdgeInsets.all(15.0),
      child: Form(
        key:_formKey,
        child: Column(
          children: <Widget>[
            Image.file(_image,height: 330.0,width: 660.0,),
            SizedBox(height: 15.0,),
            TextFormField(
              decoration: InputDecoration(labelText: 'Açıklama'),
              validator: (value){
                return value.isEmpty ? 'Açıklama giriniz':null;
              },
              onSaved: (value){
                _myValue=value;
                return _myValue;
              },
            ),
            SizedBox(height: 15,),
            ElevatedButton(
              child: Text('Yeni Post Ekle'),
              onPressed: resimYukle,
            )
          ],
        ),
      ),
    );
  }
}