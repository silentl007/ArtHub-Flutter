import 'package:ArtHub/common/model.dart';
import 'package:ArtHub/screen/freelanceartist/freelanceartistlist.dart';
import 'package:ArtHub/screen/user/userorders.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MiddleOrders extends StatefulWidget {
  final int page;
  MiddleOrders({this.page});
  @override
  _MiddleOrdersState createState() => _MiddleOrdersState();
}

class _MiddleOrdersState extends State<MiddleOrders> {
  List user = [];
  // @override
  // void initState() {
  //   super.initState();
  //   if (widget.page == null) {
  //     widget.page = 0;
  //   }
  // }
  getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user.insert(0, prefs.getString('id'));
    user.insert(1, prefs.getString('accountType'));
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: FutureBuilder(
        future: getPrefs(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return loading();
          } else if (snapshot.data.length == 2) {
            orderscreen(snapshot.data);
            return Container();
          } else {
            return Container();
          }
        },
      )),
    );
  }

  loading() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(AppColors.purple),
        strokeWidth: 9.0,
      ),
    );
  }

  orderscreen(List data) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      return Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => Orders(userdetails: data, page: widget.page,)));
    });
  }
}
