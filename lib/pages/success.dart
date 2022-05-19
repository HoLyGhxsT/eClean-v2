import 'package:flutter/material.dart';
import '../utils/Constants.dart';
import '../utils/authentication.dart';
import 'login.dart';

class success extends StatelessWidget {
  const success({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Center(
              child: Text(
                  'You Have Successfully Registered for garbage pickup.')),
                  
        ),
      
      ),
    );
  }
}
