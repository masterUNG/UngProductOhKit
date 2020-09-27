import 'dart:io';
import 'dart:math';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ungproduct/models/ung_document_model.dart';
import 'package:ungproduct/utility/normal_dialog.dart';

class AddBarCode extends StatefulWidget {
  @override
  _AddBarCodeState createState() => _AddBarCodeState();
}

class _AddBarCodeState extends State<AddBarCode> {
  String barcodeResult;
  List<File> files = List();
  List<Widget> widgets = List();
  File showFile;
  List<String> urlImages = List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => readQR(),
        child: Icon(Icons.assessment),
      ),
      appBar: buildAppBar(context),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildResultReadBarCode(),
          widgets.length == 0
              ? SizedBox()
              : Container(
                  padding: EdgeInsets.all(16),
                  width: 250,
                  height: 200,
                  child: Image.file(
                    showFile,
                    fit: BoxFit.cover,
                  ),
                ),
          files.length == 0 ? SizedBox() : buildShowImage2(),
          widgets.length == 0
              ? SizedBox()
              : OutlineButton.icon(
                  onPressed: () => processSave(),
                  icon: Icon(Icons.save),
                  label: Text('Save'),
                ),
        ],
      ),
      // body: files.length == 0 ? SizedBox() : buildShowImage2(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Add BarCode'),
      actions: [
        IconButton(
          icon: Icon(Icons.add_a_photo),
          onPressed: () {
            if (barcodeResult == null || barcodeResult.isEmpty) {
              normalDialog(context, 'Please Scan Document Bar Code First');
            } else {
              choosePhoto(ImageSource.camera);
            }
          },
        ),
        IconButton(
          icon: Icon(Icons.add_photo_alternate),
          onPressed: () {
            if (barcodeResult == null || barcodeResult.isEmpty) {
              normalDialog(context, 'Please Scan Document Bar Code First');
            } else {
              choosePhoto(ImageSource.gallery);
            }
          },
        ),
      ],
    );
  }

  Widget buildShowImage2() {
    return Container(
      height: 120,
      child: Expanded(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widgets.length,
          itemBuilder: (context, index) => widgets[index],
        ),
      ),
    );
  }

  Widget buildShowImage() {
    return GridView.count(
      crossAxisCount: 2,
      children: widgets,
    );
  }

  Row buildResultReadBarCode() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(barcodeResult == null || barcodeResult.isEmpty
              ? 'Please Click Read BarCode'
              : barcodeResult),
        ),
      ],
    );
  }

  Future<Null> readQR() async {
    print('readQR Work');
    try {
      var result = await BarcodeScanner.scan();
      setState(() {
        barcodeResult = result.rawContent;
      });
      print('barcodeResult = $barcodeResult');
    } catch (e) {
      print('e readQR ==> ${e.toString()}');
    }
  }

  Future<Null> choosePhoto(ImageSource source) async {
    // print('TakePhoto Works');
    try {
      var result = await ImagePicker().getImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (result != null) {
        print('result !=  null');

        setState(() {
          showFile = File(result.path);
          files.add(showFile);
          widgets.add(createWidget(showFile));
          print('membar of widgets ==>> ${widgets.length}');
        });
      }
    } catch (e) {
      print('e takePhoto ==>> ${e.toString()}');
    }
  }

  Widget createWidget(File file) {
    return Container(
      padding: EdgeInsets.all(8),
      width: 100,
      height: 100,
      child: Image.file(
        file,
        fit: BoxFit.cover,
      ),
    );
  }

  Future<Null> processSave() async {
    // print('Amount File ==>> ${files.length}');
    await Firebase.initializeApp().then((value) async {
      for (var file in files) {
        Random random = Random();
        int i = random.nextInt(100000);
        String nameImage = 'image$i.jpg';

        FirebaseStorage storage = FirebaseStorage.instance;
        StorageReference reference =
            storage.ref().child('MyDocument/doc$barcodeResult/$nameImage');
        StorageUploadTask task = reference.putFile(file);
        String urlImage = await (await task.onComplete).ref.getDownloadURL();
        // print('urlImage ===>> $urlImage');
        urlImages.add(urlImage);
      }
      processInsertData();
    });
  }

  Future<Null> processInsertData() async {
    UngDocumentModel model = UngDocumentModel(pathImages: urlImages);

    await FirebaseFirestore.instance
        .collection('UngDocument')
        .doc(barcodeResult)
        .set(model.toJSON())
        .then((value) {
      print('Insert Success');
      Navigator.pop(context);
    });
  }
}
