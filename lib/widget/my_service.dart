import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ungproduct/models/user_model.dart';
import 'package:ungproduct/widget/authen.dart';
import 'package:ungproduct/widget/barcode.dart';

class MyService extends StatefulWidget {
  @override
  _MyServiceState createState() => _MyServiceState();
}

class _MyServiceState extends State<MyService> {
  UserModel userModel;
  Widget currentWidget = Barcode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findUserLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  buildUserAccountsDrawerHeader(),
                  buildListTileBarcode(),
                  buildListTilePage2(),
                ],
              ),
            ),
            buildSignOut(),
          ],
        ),
      ),
      body: currentWidget,
    );
  }

  ListTile buildListTileBarcode() {
    return ListTile(
      onTap: () {
        Navigator.pop(context);
        setState(() {
          currentWidget = Barcode();
        });
      },
      leading: Icon(Icons.account_balance),
      title: Text('Bar Code'),
      subtitle: Text('Read, Search and Add Bar Code'),
    );
  }

  ListTile buildListTilePage2() {
    return ListTile(
      onTap: () {
        Navigator.pop(context);
      },
      leading: Icon(Icons.filter_2),
      title: Text('Page 2'),
      subtitle: Text('Show Page 2'),
    );
  }

  UserAccountsDrawerHeader buildUserAccountsDrawerHeader() {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/wall.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      currentAccountPicture: userModel == null
          ? Image.asset('images/avatar.png')
          : CircleAvatar(
              backgroundImage: NetworkImage(userModel.urlAvatar),
            ),
      accountName: Text(userModel == null ? 'Name' : userModel.name),
      accountEmail: Text(userModel == null ? 'Position' : userModel.position),
    );
  }

  Column buildSignOut() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.red.shade700),
          child: ListTile(
            onTap: () async {
              await Firebase.initializeApp().then((value) async {
                await FirebaseAuth.instance
                    .signOut()
                    .then((value) => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Authen(),
                        ),
                        (route) => false));
              });
            },
            leading: Icon(
              Icons.exit_to_app,
              size: 36,
              color: Colors.white,
            ),
            title: Text(
              'Sing Out',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              'คือการ LogOut',
              style: TextStyle(color: Colors.white),
            ),
            trailing: Icon(
              Icons.arrow_forward,
              size: 36,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Future<Null> findUserLogin() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) async {
        String uid = event.uid;
        print('uid ===>> $uid');
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .snapshots()
            .listen((event) {
          setState(() {
            userModel = UserModel.fromJson(event.data());
          });
        });
      });
    });
  }
}
