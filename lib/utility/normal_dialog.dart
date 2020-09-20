import 'package:flutter/material.dart';

Future<Null> normalDialog(BuildContext context, String string) async {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(backgroundColor: Colors.lime.shade200,
      title: ListTile(
        leading: Container(
          width: 48,
          child: Image.asset('images/avatar.png'),
        ),
        title: Text(string),
      ),
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'OK',
                style: TextStyle(color: Colors.pink),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
