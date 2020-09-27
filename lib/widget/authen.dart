import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ungproduct/utility/my_style.dart';
import 'package:ungproduct/utility/normal_dialog.dart';
import 'package:ungproduct/widget/my_service.dart';
import 'package:ungproduct/widget/register.dart';

class Authen extends StatefulWidget {
  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  bool statusRedEye = true, wait = true;
  int indexTheme = 0;
  String user, password;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkStatusLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.5),
            radius: 1.5,
            colors: [Colors.white, MyStyle().primaryColors[indexTheme]],
          ),
        ),
        child: wait ? MyStyle().showProgress() : buildCenter(),
      ),
    );
  }

  Center buildCenter() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildContainer(),
            buildText(),
            buildTextFieldUser(),
            buildTextFieldPassword(),
            buildRaisedButton(),
            buildFlatButton(),
          ],
        ),
      ),
    );
  }

  FlatButton buildFlatButton() => FlatButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Register(),
          ),
        ),
        child: Text(
          'New Register',
          style: TextStyle(
            color: Colors.pink.shade400,
            fontStyle: FontStyle.italic,
          ),
        ),
      );

  Container buildRaisedButton() => Container(
        margin: EdgeInsets.only(top: 16),
        width: 250,
        child: RaisedButton(
          color: Color(0xFFE1A51A),
          onPressed: () {
            if (user == null ||
                user.isEmpty ||
                password == null ||
                password.isEmpty) {
              normalDialog(context, 'Have Space ? Please Fill Every Blank');
            } else {
              checkAuthen();
            }
          },
          child: Text(
            'Login',
            style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ),
      );

  Container buildTextFieldUser() => Container(
        margin: EdgeInsets.only(bottom: 16),
        width: 250,
        child: TextField(
          onChanged: (value) => user = value.trim(),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'User :',
          ),
        ),
      );

  Container buildTextFieldPassword() => Container(
        width: 250,
        child: TextField(
          onChanged: (value) => password = value.trim(),
          obscureText: statusRedEye,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(Icons.remove_red_eye),
              onPressed: () {
                setState(() {
                  statusRedEye = !statusRedEye;
                });
              },
            ),
            border: OutlineInputBorder(),
            labelText: 'Password :',
          ),
        ),
      );

  Text buildText() => Text(
        'อึ่ง ซ่อมแซม',
        style: GoogleFonts.sriracha(
            textStyle: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
                color: Colors.red[900])),
      );

  Container buildContainer() {
    return Container(
      width: 150,
      child: Image.asset('images/logo.png'),
    );
  }

  Future<Null> checkStatusLogin() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) {
        if (event != null) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => MyService(),
              ),
              (route) => false);
        } else {
          setState(() {
            wait = false;
          });
        }
      });
    });
  }

  Future<Null> checkAuthen() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: user, password: password)
          .then(
            (value) => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => MyService(),
                ),
                (route) => false),
          )
          .catchError((value) {
        String string = value.message;
        normalDialog(context, string);
      });
    });
  }
}
