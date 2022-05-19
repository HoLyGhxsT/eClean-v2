import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eclean/pages/success.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import '../utils/Constants.dart';
import '../utils/authentication.dart';
import 'login.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('e-Clean')),
      drawer: Drawer(
          child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(),
          _createDrawerItem(icon: Icons.calendar_view_month, text: 'Booking', onTap: (){
            if(Constants.prefs.getBool("Booked")==true){
              Navigator.push(context, MaterialPageRoute(builder: (context) => success()),);
            }
          }),
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
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          SizedBox(height: 80),
          Center(
            child: Text(
              'Register for pickup!',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: HomeForm(),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     AuthenticationHelper().signOut().then((_) {
      //       Constants.prefs.setBool("loggedIn", false);
      //       Navigator.pushReplacement(
      //         context,
      //         MaterialPageRoute(builder: (contex) => Login()),
      //       );
      //     });
      //   },
      //   child: Icon(Icons.logout),
      //   tooltip: 'Logout',
      // ),
    );
  }

  Container buildLogo() {
    return Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.blue),
      child: Center(
        child: Text(
          "Logo",
          style: TextStyle(color: Colors.white, fontSize: 60.0),
        ),
      ),
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

class HomeForm extends StatefulWidget {
  const HomeForm({Key? key}) : super(key: key);

  @override
  _HomeFormState createState() => _HomeFormState();
}

class _HomeFormState extends State<HomeForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController,
      _numberController,
      _addrController;

  late DatabaseReference _ref;

  @override
  void initState() {
    //  to implement initState
    super.initState();
    _nameController = TextEditingController();
    _numberController = TextEditingController();
    _addrController = TextEditingController();
    _ref = FirebaseDatabase.instance.ref();
  }

  @override
  Widget build(BuildContext context) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.all(
        const Radius.circular(100.0),
      ),
    );
    var space = SizedBox(height: 10);
    bool errFlag = false;
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name', border: border),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          space,
          TextFormField(
            controller: _numberController,
            decoration: InputDecoration(
                labelText: 'Number', border: border, prefixText: '+91', counterText: ''),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter number';
              } else if (value.length < 10) {
                return 'Please enter a valid number';
              }
              return null;
            },
            keyboardType: TextInputType.phone,
            maxLength: 10,
          ),
          space,
          TextFormField(
            controller: _addrController,
            decoration: InputDecoration(labelText: 'Address', border: border),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter address';
              }
              return null;
            },
            keyboardType: TextInputType.multiline,
          ),
          SizedBox(height: 20),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  String name = _nameController.text;
                  String phno = _numberController.text;
                  String addr = _addrController.text;

                  CollectionReference users =
                      FirebaseFirestore.instance.collection('requests');
                  FirebaseAuth auth = FirebaseAuth.instance;
                  String uid = auth.currentUser!.uid.toString();
                  users.doc(uid).set({
                    'Name': name,
                    'uid': uid,
                    'contact': phno,
                    'address': addr
                  }).then((value) {
                    Constants.prefs.setBool("Booked", true);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
                          "Successfully Booked",
                          style: TextStyle(fontSize: 16),
                        ),));
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => success()));
                  }).catchError((error) => ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(
                          content:
                              Text(error, style: TextStyle(fontSize: 16)))));
                  return;
                }
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(24.0)))),
              child: Text('ADD'),
            ),
          ),
        ],
      ),
    );
  }

  // void insert() {
  //   _ref.push().set({
  //                 'name': name,
  //                 'contact': phno,
  //                 'address': addr
  //               }).catchError((onError) => {
  //                     errFlag = true,
  //                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //                       content: Text(
  //                           'Something went wrong, Please try again later!'),
  //                     )),
  //                     print('$errFlag')
  //                   });
  //               if (errFlag == false) {
  //                 Navigator.pushReplacement(context,
  //                     MaterialPageRoute(builder: (context) => success()));
  //               }
  // }
}
