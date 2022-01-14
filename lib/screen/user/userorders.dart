import 'package:art_hub/screen/homescreen.dart';
import 'package:art_hub/screen/user/ordersdelivered.dart';
import 'package:flutter/material.dart';
import 'package:art_hub/common/model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'orderspending.dart';

class Orders extends StatefulWidget {
  final int? page;
  final List? userdetails;
  Orders({this.page, this.userdetails});
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
      initialPage = widget.page!;
    }
  }

  getprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('inapp', true);
  }

  @override
  Widget build(BuildContext context) {
    Sizes().heightSizeCalc(context);
    Sizes().widthSizeCalc(context);
    return DefaultTabController(
      initialIndex: initialPage,
      length: 2,
      child: SafeArea(
          child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: Texts.textScale),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              title: Padding(
                padding: EdgeInsets.only(right: Sizes.w30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Orders',
                      style: TextStyle(
                          color: AppColors.purple,
                          fontSize: Sizes.w20,
                          fontWeight: FontWeight.w700),
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
                        fontSize: Sizes.w20,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                Tab(
                  child: Text(
                    'Pending',
                    style: TextStyle(
                        color: AppColors.purple,
                        fontSize: Sizes.w20,
                        fontWeight: FontWeight.w700),
                  ),
                )
              ])),
          body: WillPopScope(
            onWillPop: () => _backtoHome(),
            child: TabBarView(
              children: [
                Delivered(widget.userdetails!),
                Pending(widget.userdetails!),
              ],
            ),
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
