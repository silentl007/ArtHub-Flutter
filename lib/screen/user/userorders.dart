import 'package:ArtHub/screen/homescreen.dart';
import 'package:ArtHub/screen/user/ordersdelivered.dart';
import 'package:flutter/material.dart';
import 'package:ArtHub/common/model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'orderspending.dart';

class Orders extends StatefulWidget {
  int page;
  Orders({this.page});
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  Widgets classWidget = Widgets();
  int initialPage = 0;
  @override
  void initState() {
    super.initState();
    getprefs();
    if (widget.page != null) {
      initialPage = widget.page;
    }
  }

  getprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('inapp', true);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double fontSize20 = size.height * 0.025;
    double padding30 = size.height * 0.03755;
    return DefaultTabController(
      initialIndex: initialPage,
      length: 2,
      child: SafeArea(
          child: Scaffold(
        appBar: AppBar(
            title: Padding(
              padding: EdgeInsets.only(right: padding30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Orders',
                    style: TextStyle(
                      color: AppColors.purple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            bottom: TabBar(indicatorColor: AppColors.purple, tabs: <Widget>[
              Tab(
                child: Text(
                  'Delivered',
                  style: TextStyle(
                      color: AppColors.purple,
                      fontSize: fontSize20,
                      fontWeight: FontWeight.w700),
                ),
              ),
              Tab(
                child: Text(
                  'Pending',
                  style: TextStyle(
                      color: AppColors.purple,
                      fontSize: fontSize20,
                      fontWeight: FontWeight.w700),
                ),
              )
            ])),
        body: WillPopScope(
          onWillPop: () => _backtoHome(),
          child: TabBarView(
            children: [
              Delivered(),
              Pending(),
            ],
          ),
        ),
      )),
    );
  }

  _backtoHome() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (Route<dynamic> route) => false);
  }
}
