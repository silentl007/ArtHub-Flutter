import 'package:flutter/material.dart';
import 'package:ArtHub/common/model.dart';

class Delivered extends StatefulWidget {
  @override
  _DeliveredState createState() => _DeliveredState();
}

class _DeliveredState extends State<Delivered> {
  var getorder;
  List<ParsedOrder> parsed = [];
  @override
  void initState() {
    super.initState();
    getorder = getOrders();
  }

  getOrders() async {}
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: getorder,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return loading();
        } else if (snapshot.hasData == true) {
          return Container(
            child: Center(
              child: Text('data found'),
            ),
          );
        } else {
          return Container(
              child: Center(
                  child: RaisedButton(
            child: Text('Retry'),
            onPressed: () {
              setState(() {});
            },
          )));
        }
      },
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
}
