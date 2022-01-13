import 'package:artHub/screen/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:artHub/common/model.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widgets classWidget = Widgets();
    return SafeArea(
      child: Scaffold(
          appBar: classWidget.apptitleBar(context, 'About Us'),
          body: WillPopScope(
              onWillPop: () async{
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                    (Route<dynamic> route) => false);
                    return true;
              },
              child: Container())),
    );
  }
}
