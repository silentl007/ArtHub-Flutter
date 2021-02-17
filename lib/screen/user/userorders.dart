import 'package:ArtHub/screen/user/ordersdelivered.dart';
import 'package:flutter/material.dart';
import 'package:ArtHub/common/model.dart';

import 'orderspending.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  Widgets classWidget = Widgets();
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double fontSize20 = size.height * 0.025;
    double padding30 = size.height * 0.03755;
    return DefaultTabController(
      initialIndex: 0,
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
        body: TabBarView(
          children: [
            Delivered(),
            Pending(),
          ],
        ),
      )),
    );
  }
}
