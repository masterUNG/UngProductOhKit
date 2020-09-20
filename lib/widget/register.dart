import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ungproduct/utility/my_constant.dart';
import 'package:ungproduct/utility/my_style.dart';

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
        print(
            'name = $name, user = $user, password = $password, re-Password = $rePassword');
      },
    );
  }

  Container buildContainerPosition() => Container(
        width: 250,
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
}
