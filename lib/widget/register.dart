import 'package:flutter/material.dart';
import 'package:ungproduct/utility/my_constant.dart';
import 'package:ungproduct/utility/my_style.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  int indexTheme = 0;
  String choosePosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        backgroundColor: MyStyle().primaryColors[indexTheme],
        actions: [
          IconButton(
            icon: Icon(Icons.cloud_upload),
            onPressed: () {},
          )
        ],
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
              child: Text(e, style: TextStyle(fontWeight: FontWeight.bold),),
              value: e,
            ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  choosePosition = value;
                });
              },hint: Text('Please Choose Position', style: TextStyle(color: Colors.red),),
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
            onPressed: null),
        Container(
          width: 180,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset('images/avatar.png'),
          ),
        ),
        IconButton(
            icon: Icon(
              Icons.add_photo_alternate,
              size: 36,
            ),
            onPressed: null),
      ],
    );
  }

  Container buildTextFieldName() => Container(
        margin: EdgeInsets.only(bottom: 16),
        width: 250,
        child: TextField(
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
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock_open),
            border: OutlineInputBorder(),
            labelText: 'Re-Password :',
          ),
        ),
      );
}
