import 'package:eclean/pages/success.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../utils/Constants.dart';
import '../utils/authentication.dart';
import 'login.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          SizedBox(height: 80),
          // logo
          SizedBox(height: 50),
          Text(
            'Register for pickup!',
            style: TextStyle(fontSize: 24),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: HomeForm(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          AuthenticationHelper().signOut().then((_) {
            Constants.prefs.setBool("loggedIn", false);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (contex) => Login()),
            );
          });
        },
        child: Icon(Icons.logout),
        tooltip: 'Logout',
      ),
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
          "T",
          style: TextStyle(color: Colors.white, fontSize: 60.0),
        ),
      ),
    );
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
            decoration: InputDecoration(labelText: 'Number', border: border),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter number';
              }
              return null;
            },
            keyboardType: TextInputType.phone,
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
            keyboardType: TextInputType.streetAddress,
          ),
          space,
          SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                String name = _nameController.text;
                String phno = _numberController.text;
                String addr = _addrController.text;

                _ref.push().set({
                  'name': name,
                  'contact': phno,
                  'address': addr
                }).catchError((onError) => {
                      errFlag = true,
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'Something went wrong, Please try again later!'),
                      )),
                      print('$errFlag')
                    });
                if (errFlag == false) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => success()));
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
  //   String name = _nameController.text;
  //   String phno = _numberController.text;
  //   String addr = _addrController.text;

  //   _ref
  //       .push()
  //       .set({'name': name, 'contact': phno, 'address': addr});
  // }
}