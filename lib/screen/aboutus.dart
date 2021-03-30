import 'package:ArtHub/screen/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:ArtHub/common/model.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widgets classWidget = Widgets();
    return SafeArea(
      child: Scaffold(
          appBar: classWidget.apptitleBar(context, 'About Us'),
          body: WillPopScope(
              onWillPop: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                    (Route<dynamic> route) => false);
              },
              child: Container())),
    );
  }
}
