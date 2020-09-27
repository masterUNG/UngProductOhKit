import 'package:flutter/material.dart';
import 'package:ungproduct/widget/add_barcode.dart';

class Barcode extends StatefulWidget {
  @override
  _BarcodeState createState() => _BarcodeState();
}

class _BarcodeState extends State<Barcode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('This is Barcode'),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddBarCode(),
          ),
        ),
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
