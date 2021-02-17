import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ArtHub/common/model.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  Widgets classWidget = Widgets();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDetails();
  }

  getDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // init the textfieldforms with collected data
    // once new data is submitted, update the shared prefereneces data
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: classWidget.apptitleBar(context, 'Edit Profile'),
        body: Container(),
      ),
    );
  }
}
