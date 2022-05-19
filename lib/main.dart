import 'package:eclean/pages/adminPanel.dart';
import 'package:eclean/pages/home.dart';
import 'package:eclean/utils/Constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Constants.prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eClean',
      // home: Constants.prefs.getBool("loggedIn") == true ? Home() : Login(),
      theme: ThemeData(primarySwatch: Colors.green),
      home: PrefCheck(),
    );
  }
}

class PrefCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // if (Constants.prefs.getBool("loggedIn") == false) {
    //   return Login();
    // } else {
    //   if (Constants.prefs.getBool("notAdmin") == true) {
    //     return Home();
    //   } else {
    //     return Admin();
    //   }
    // }
    if (Constants.prefs.getBool("loggedIn") == false) {
      return Login();
    } else if(Constants.prefs.getBool("notAdmin") == true){
      return Home();
    } return Login();
    // if (Constants.prefs.getBool("loggedIn") == false) {
    //   return Login();
    // } else if (Constants.prefs.getBool("notAdmin") == true) {
    //   return Home();
    // }
    // return Login();
  }
}
