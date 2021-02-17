import 'package:ArtHub/screen/user/editprofile.dart';
import 'package:flutter/material.dart';
import 'package:ArtHub/common/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {});
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
      body: Column(),
    ));
  }

  _title(String title) {
    return Text(title);
  }

  _content(String content) {
    return Text(content);
  }
}
