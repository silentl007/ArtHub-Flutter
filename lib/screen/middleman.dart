import 'dart:async';
import 'package:ArtHub/screen/productdetails.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ArtHub/common/model.dart';

class Middle extends StatefulWidget {
  final ParsedDataProduct data;
  Middle(this.data);
  @override
  _MiddleState createState() => _MiddleState();
}

class _MiddleState extends State<Middle> {
  List user = [];
  void startTimer() {
    getPrefs();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ProductDetails(widget.data, user)));
    });
  }

  getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user.insert(0, prefs.getString('id'));
    user.insert(1, prefs.getString('accountType'));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Loading'),
      ),
    );
  }
}
