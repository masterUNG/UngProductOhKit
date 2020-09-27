import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ungproduct/models/user_model.dart';
import 'package:ungproduct/utility/my_constant.dart';
import 'package:ungproduct/utility/my_style.dart';
import 'package:ungproduct/utility/normal_dialog.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  int indexTheme = 0;
  String choosePosition;
  File file;
  String urlAvatar, name, user, password, rePassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        backgroundColor: MyStyle().primaryColors[indexTheme],
        actions: [buildIconButton()],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildRowAvartar(),
            buildTextFieldName(),
            buildContainerPosition(),
            buildTextFieldUser(),
            buildTextFieldPassword(),
            buildTextFieldRePassword(),
          ],
        ),
      ),
    );
  }

  IconButton buildIconButton() {
    return IconButton(
      icon: Icon(Icons.cloud_upload),
      onPressed: () {
        if (file == null) {
          normalDialog(context, 'Please Choose Avatar');
        } else if (name == null ||
            name.isEmpty ||
            user == null ||
            user.isEmpty ||
            password == null ||
            password.isEmpty ||
            rePassword == null ||
            rePassword.isEmpty) {
          normalDialog(context, 'Have Space Please Fill Every Blank');
        } else if (password != rePassword) {
          normalDialog(context, 'กรุณากรอก Password ให้เหมือนกัน');
        } else if (choosePosition == null) {
          normalDialog(context, 'กรุณาเลือก Position ด้วยคะ');
        } else {
          print(
              'name = $name, user = $user, password = $password, re-Password = $rePassword');
          authenToFirebase();
        }
      },
    );
  }

  Container buildContainerPosition() => Container(
        width: 280,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: choosePosition,
              items: MyConstant()
                  .positions
                  .map(
                    (e) => DropdownMenuItem(
                      child: Text(
                        e,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      value: e,
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  choosePosition = value;
                });
              },
              hint: Text(
                'Please Choose Position',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
        ),
      );

  Row buildRowAvartar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(
            Icons.add_a_photo,
            size: 36,
          ),
          onPressed: () => chooseAvatar(ImageSource.camera),
        ),
        Container(
          width: 180,
          height: 180,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: file == null
                ? Image.asset('images/avatar.png')
                : CircleAvatar(
                    backgroundImage: FileImage(file),
                  ),
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.add_photo_alternate,
            size: 36,
          ),
          onPressed: () => chooseAvatar(ImageSource.gallery),
        ),
      ],
    );
  }

  Container buildTextFieldName() => Container(
        margin: EdgeInsets.only(bottom: 16),
        width: 250,
        child: TextField(
          onChanged: (value) => name = value.trim(),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.face),
            border: OutlineInputBorder(),
            labelText: 'Name :',
          ),
        ),
      );

  Container buildTextFieldUser() => Container(
        margin: EdgeInsets.only(bottom: 16),
        width: 250,
        child: TextField(
          onChanged: (value) => user = value.trim(),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.account_circle),
            border: OutlineInputBorder(),
            labelText: 'User :',
          ),
        ),
      );

  Container buildTextFieldPassword() => Container(
        margin: EdgeInsets.only(bottom: 16),
        width: 250,
        child: TextField(
          onChanged: (value) => password = value.trim(),
          obscureText: true,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock),
            border: OutlineInputBorder(),
            labelText: 'Password :',
          ),
        ),
      );

  Container buildTextFieldRePassword() => Container(
        margin: EdgeInsets.only(bottom: 16),
        width: 250,
        child: TextField(
          onChanged: (value) => rePassword = value.trim(),
          obscureText: true,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock_open),
            border: OutlineInputBorder(),
            labelText: 'Re-Password :',
          ),
        ),
      );

  Future<Null> chooseAvatar(ImageSource source) async {
    try {
      var result = await ImagePicker().getImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );
      print('path ==>> ${result.path}');
      setState(() {
        file = File(result.path);
      });
    } catch (e) {
      print('e chooseAvatar ==> ${e.toString()}');
    }
  }

  Future<Null> authenToFirebase() async {
    await Firebase.initializeApp().then(
      (value) async {
        print('Initial Success');
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: user, password: password)
            .then((value) {
          String uid = value.user.uid;
          uploadAvatarToFirebase(uid);
        }).catchError((value) {
          String error = value.message;
          normalDialog(context, error);
        });
      },
    );
  }

  Future uploadAvatarToFirebase(String uid) async {
    print('uid ==>> $uid');
    String nameAvatar = '$uid.jpg';

    String urlAvatar = await (await FirebaseStorage.instance
            .ref()
            .child('Avatar/$nameAvatar')
            .putFile(file)
            .onComplete)
        .ref
        .getDownloadURL();
    print('urlAvatar = $urlAvatar');
    insertDataToCloudFirestore(urlAvatar, uid);
  }

  Future<Null> insertDataToCloudFirestore(String urlAvatar, String uid) async {
    UserModel model =
        UserModel(name: name, position: choosePosition, urlAvatar: urlAvatar);

    Map<String, dynamic> map = model.toJson();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(map)
        .then((value) => Navigator.pop(context));
  }
}
