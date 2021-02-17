import 'package:ArtHub/screen/user/editprofile.dart';
import 'package:flutter/material.dart';
import 'package:ArtHub/common/model.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Widgets classWidget = Widgets();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('fetch, and read user data in pref');
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => EditProfile()));
        },
        backgroundColor: AppColors.purple,
        child: Icon(Icons.edit),
      ),
      appBar: classWidget.apptitleBar(context, 'Profile'),
    ));
  }
}
