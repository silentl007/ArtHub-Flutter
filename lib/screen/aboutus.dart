import 'package:flutter/material.dart';
import 'package:ArtHub/common/model.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widgets classWidget = Widgets();
    return SafeArea(
      child: Scaffold(
          appBar: classWidget.apptitleBar(context, 'About Us'),
          body: Container()),
    );
  }
}
