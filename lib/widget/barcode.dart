import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:ungproduct/utility/my_style.dart';
import 'package:ungproduct/widget/add_barcode.dart';
import 'package:ungproduct/widget/detail.dart';

class Barcode extends StatefulWidget {
  @override
  _BarcodeState createState() => _BarcodeState();
}

class _BarcodeState extends State<Barcode> {
  List<String> nameDocs = List();
  List<List<String>> listUrlImages = List();

  @override
  void initState() {
    super.initState();
    readAllData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: nameDocs.length == 0
          ? MyStyle().showProgress()
          : ListView.builder(
              itemCount: nameDocs.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Detail(
                      barCode: nameDocs[index],
                      images: listUrlImages[index],
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(nameDocs[index]),
                    Container(
                      width: 100,
                      height: 100,
                      padding: EdgeInsets.all(8),
                      child: Image.network(
                        listUrlImages[index][0],
                        fit: BoxFit.cover,
                      ),
                    )
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddBarCode(),
          ),
        ).then((value) => readAllData()),
        child: Icon(Icons.add_a_photo),
      ),
    );
  }

  Future<Null> readAllData() async {
    if (nameDocs.length != 0) {
      nameDocs.clear();
      listUrlImages.clear();
    }

    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection('UngDocument')
          .snapshots()
          .listen((event) {
        for (var snapshot in event.docs) {
          String string = snapshot.id;
          var result = snapshot.data()['pathImage'];
          print('result ===>>> $result');
          List<String> urlImages = List();
          for (var item in result) {
            String string = item;
            print('string = $string');
            urlImages.add(string);
          }
          setState(() {
            nameDocs.add(string.toString());
            listUrlImages.add(urlImages);
          });
        }
      });
    });
  }
}
