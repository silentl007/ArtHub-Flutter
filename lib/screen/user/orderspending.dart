import 'package:art_hub/screen/user/orderdetails.dart';
import 'package:flutter/material.dart';
import 'package:art_hub/common/model.dart';
import 'dart:convert';
import 'package:number_display/number_display.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_animator/flutter_animator.dart';

class Pending extends StatefulWidget {
  final List userDetails;
  Pending(this.userDetails);
  @override
  _PendingState createState() => _PendingState();
}

class _PendingState extends State<Pending> {
  final displayNumber = createDisplay(length: 8, decimal: 0);
  var getpending;
  List<ParsedOrder> pendingparsed = [];
  List data = [];
  @override
  void initState() {
    super.initState();
    getpending = getPending();
  }

  getPending() async {
    Uri link = Uri.parse(
        '${Server.link}/apiR/orders/${widget.userDetails[0]}/${widget.userDetails[1]}');

    try {
      var query = await http.get(link,
          headers: {'Content-Type': 'application/json; charset=UTF-8'});
      var decode = jsonDecode(query.body);
      data = decode;
      if (data.isNotEmpty) {
        for (var items in data) {
          if (items['status'] == 'Pending' || items['status'] == 'pending') {
            ParsedOrder pending = ParsedOrder(
                orderID: items['orderID'],
                itemnumber: items['itemnumber'],
                dateOrdered: items['dateOrdered'],
                itemscost: items['itemscost'],
                purchaseditems: items['purchaseditems']);
            pendingparsed.add(pending);
          }
        }
      }
      return pendingparsed;
    } catch (error) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    Sizes().heightSizeCalc(context);
    Sizes().widthSizeCalc(context);
    return FutureBuilder(
      future: getpending,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return loading();
        } else if (snapshot.hasData == true) {
          return Container(
            child: snapshot.data.length != 0
                ? Padding(
                    padding: EdgeInsets.all(Sizes.w10),
                    child: itembuilder(snapshot.data),
                  )
                : Center(
                    child: Text('No Pending Orders'),
                  ),
          );
        } else {
          return Container(
              child: Center(
                  child: ElevatedButton(
            style: Decorations().buttonDecor(context: context, noBorder: true),
            child: Decorations().buttonText(
              buttonText: 'Retry',
              context: context,
            ),
            onPressed: () {
              getpending = getPending();
              setState(() {});
            },
          )));
        }
      },
    );
  }

  itembuilder(List snapshot) {
    return ListView.builder(
      itemCount: snapshot.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(Sizes.w25),
            ),
          ),
          child: ListTile(
            onTap: () {
              orderDetails(snapshot[index].purchaseditems);
            },
            leading: Pulse(
              preferences:
                  AnimationPreferences(autoPlay: AnimationPlayStates.Loop),
              child: IconButton(
                icon: Icon(Icons.qr_code),
                onPressed: () {
                  showQR(snapshot[index].orderID, Sizes.h200);
                },
              ),
            ),
            trailing: Icon(Icons.arrow_right),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Order ID'),
                Text('${snapshot[index].orderID}'),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Date: ${snapshot[index].dateOrdered}'),
                Text('No. of items: ${snapshot[index].itemnumber}'),
                Text(
                    'Cost of items: ₦${displayNumber(snapshot[index].itemscost)}'),
              ],
            ),
          ),
        );
      },
    );
  }

  slide(String direction, Widget widget) {
    int duration = 2;
    if (direction == 'left') {
      return SlideInLeft(
        preferences: AnimationPreferences(
          offset: Duration(seconds: duration),
        ),
        child: widget,
      );
    } else {
      return SlideInRight(
        preferences: AnimationPreferences(offset: Duration(seconds: duration)),
        child: widget,
      );
    }
  }

  void orderDetails(List orderdetails) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => OrderDetails(orderdetails)));
  }

  loading() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(AppColors.purple),
        strokeWidth: 9.0,
      ),
    );
  }

  showQR(String orderID, double qrsize) {
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: QrImage(
              backgroundColor: Colors.white,
              size: qrsize,
              data: orderID,
              version: QrVersions.auto,
            ),
          );
        });
  }
}
