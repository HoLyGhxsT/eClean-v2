import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/Constants.dart';
import '../utils/authentication.dart';
import 'login.dart';

class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('e-Clean')),
      drawer: Drawer(
          child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(),
          _createDrawerItem(icon: Icons.calendar_view_month, text: 'Booking'),
          _createDrawerItem(icon: Icons.help_center, text: 'Get Help'),
          _createDrawerItem(icon: Icons.bug_report, text: 'Report a bug'),
          _createDrawerItem(
              icon: Icons.logout,
              text: 'Logout',
              onTap: () async {
                AuthenticationHelper().signOut().then((_) {
                  Constants.prefs.setBool("loggedIn", false);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (contex) => Login()),
                  );
                });
              }),
          Divider(),
          _createDrawerItem(icon: Icons.exit_to_app, text: 'Quit', onTap: exit)
        ],
      )),
      body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('requests').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int i) {
                  return Container(
                    width: 200,
                    height: 100,
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    color: Colors.green.shade200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20,),
                        Text("Name : " + snapshot.data!.docs[i]['Name']),
                        Text("Contact : " + snapshot.data!.docs[i]['contact']),
                        Text("Address : " + snapshot.data!.docs[i]['address'])
                      ],
                    ),
                  );
                },
              );
            },
          )
  
    );
  }

  Widget _createHeader() {
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill, image: AssetImage('assets/drawer.jpg'))),
        child: Stack(children: <Widget>[
          Positioned(
              bottom: 12.0,
              left: 16.0,
              child: Text("e-Clean",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500))),
        ]));
  }

  Widget _createDrawerItem(
      {IconData? icon, String? text, GestureTapCallback? onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text!),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  void exit() {
    SystemNavigator.pop();
  }
}
