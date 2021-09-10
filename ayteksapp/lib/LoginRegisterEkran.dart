import 'package:flutter/material.dart';
import 'giris.dart';
import 'diaologbox.dart';

class LoginRegisterEkran extends StatefulWidget {
  final AuthIslem auth;
  final VoidCallback onSignedIn;

  LoginRegisterEkran({this.auth, this.onSignedIn});

  @override
  _LoginRegisterEkranState createState() => _LoginRegisterEkranState();
}

enum PageType { login, register }

class _LoginRegisterEkranState extends State<LoginRegisterEkran>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: Duration(seconds: 1), value: 0.2);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  DialogBox dialogBox = new DialogBox();

  final formKey = new GlobalKey<
      FormState>(); //form state bilgisine göre textformfield düzenlemeye yarar.
  PageType _pageType = PageType.login;
  String _email = "";
  String _parola = "";

  void registerGec() {
    formKey.currentState.reset();
    setState(() {
      _pageType = PageType.register;
    });
  }

  void loginGec() {
    formKey.currentState.reset();
    setState(() {
      _pageType = PageType.login;
    });
  }

  void submit() async {
    if (kaydet()) {
      try {
        if (_pageType == PageType.login) {
          String userId = await widget.auth.signIn(_email, _parola);
          print('sign in ' + userId);
          dialogBox.bilgilendirmePenceresi(
              context, "Başarılı", "Giriş Başarılı");
        } else {
          String userId = await widget.auth.signUp(_email, _parola);
          print('sign up ' + userId);
          dialogBox.bilgilendirmePenceresi(
              context, "Başarılı", "Üyelik Başarılı");
        }

        widget.onSignedIn();
      } catch (e) {
        dialogBox.bilgilendirmePenceresi(context, "Hata", e.message);
      }
    }
  }

  List<Widget> inputlarOlustur() {
    return [
      SizedBox(
        height: 10,
      ),
      logoOlustur(),
      SizedBox(height: 50),
      TextFormField(
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          return value.isEmpty ? 'E mail alanına adresinizi giriniz' : null;
        },
        onSaved: (value) {
          _email = value;
          return _email;
        },
        decoration: InputDecoration(
            labelText: 'Email',
            hintText: 'aa@gmail.com',
            border: OutlineInputBorder()),
      ),
      SizedBox(height: 10),
      TextFormField(
        validator: (value) {
          return value.isEmpty ? 'Parola alanı boş geçilemez' : null;
        },
        onSaved: (value) {
          _parola = value;
          return _parola;
        },
        obscureText: true,
        decoration:
            InputDecoration(labelText: 'Parola', border: OutlineInputBorder()),
      ),
      SizedBox(height: 10),
    ];
  }

  Widget logoOlustur() {
    return Flexible(
      child: Hero(
        tag: 'logo',
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 70,
          child: Image.asset('images/logo3.png'),
        ),
      ),
    );
  }

  List<Widget> butonlarOlustur() {
    if (_pageType == PageType.login) {
      return [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.white, // background
            onPrimary: Colors.black, // foreground
          ),
          onPressed: submit,
          child: Text(
            'Giriş Yap',
            style: TextStyle(fontSize: 20),
          ),
        ),
        TextButton(
          style: TextButton.styleFrom(
            primary: Colors.white, // background // foreground
          ),
          onPressed: registerGec,
          child: Text(
            'Üyelik Oluştur',
            style: TextStyle(fontSize: 14),
          ),
        ),
      ];
    } else {
      return [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.white, // background
            onPrimary: Colors.black, // foreground
          ),
          onPressed: submit,
          child: Text(
            'Üye Ol',
            style: TextStyle(fontSize: 20),
          ),
        ),
        TextButton(
          style: TextButton.styleFrom(
            primary: Colors.white, // background
          ),
          onPressed: loginGec,
          child: Text(
            'Giriş Yap',
            style: TextStyle(fontSize: 14),
          ),
        ),
      ];
    }
  }

  bool kaydet() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF32CD32).withOpacity(controller.value),
      resizeToAvoidBottomInset: false,
      body: Container(
        margin: EdgeInsets.fromLTRB(20, 100, 20, 20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: inputlarOlustur() + butonlarOlustur(),
          ),
        ),
      ),
    );
  }
}
