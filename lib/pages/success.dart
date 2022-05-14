import 'package:flutter/material.dart';
import '../utils/Constants.dart';
import '../utils/authentication.dart';
import 'login.dart';

class success extends StatelessWidget {
  const success({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text('You Have Successfully Registered for garbage pickup. Expect the pickup team to come and pickup the waste within the next scheduled day'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AuthenticationHelper()
              .signOut()
              .then((_) => { 
                Constants.prefs.setBool("loggedIn", false),
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (contex) => Login()),
                  )});
        },
        child: Icon(Icons.logout),
        tooltip: 'Logout',
      ),
    );
  }
}