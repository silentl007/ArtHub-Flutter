import 'package:art_hub/screen/user/orderdetails.dart';
import 'package:flutter/material.dart';
import 'package:art_hub/common/model.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'dart:convert';
import 'package:number_display/number_display.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class Delivered extends StatefulWidget {
  List userDetails;
  Delivered(this.userDetails);
  @override
  _DeliveredState createState() => _DeliveredState();
}

class _DeliveredState extends State<Delivered> {
  final displayNumber = createDisplay(length: 8, decimal: 0);
  var getdelivered;
  List<ParsedOrder> deliveredparsed = [];
  List data = [];
  @override
  void initState() {
    super.initState();
    getdelivered = getDelivered();
  }

  getDelivered() async {
    Uri link = Uri.parse(
        '${Server.link}/apiR/orders/${widget.userDetails[0]}/${widget.userDetails[1]}');

    try {
      var query = await http.get(link,
          headers: {'Content-Type': 'application/json; charset=UTF-8'});
      var decode = jsonDecode(query.body);
      data = decode;
      if (data.isNotEmpty) {
        for (var items in data) {
          if (items['status'] == 'Delivered' ||
              items['status'] == 'delivered') {
            ParsedOrder delivered = ParsedOrder(
                orderID: items['orderID'],
                itemnumber: items['itemnumber'],
                dateOrdered: items['dateOrdered'],
                itemscost: items['itemscost'],
                purchaseditems: items['purchaseditems']);
            deliveredparsed.add(delivered);
          }
        }
      }
      return deliveredparsed;
    } catch (error) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double padding10 = size.height * 0.0125;
    return FutureBuilder(
      future: getdelivered,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return loading();
        } else if (snapshot.hasData == true) {
          return Container(
            child: snapshot.data.length != 0
                ? Padding(
                    padding: EdgeInsets.all(padding10),
                    child: itembuilder(snapshot.data),
                  )
                : Center(
                    child: Text('No Delivered Orders'),
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
              getdelivered = getDelivered();
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
        return BounceInDown(
          preferences: AnimationPreferences(
            offset: Duration(seconds: 2),
          ),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
            ),
            child: ListTile(
              onTap: () {
                orderDetails(snapshot[index].purchaseditems);
              },
              leading: Icon(Icons.check),
              trailing: Icon(Icons.arrow_right),
              title: slide(
                  'right',
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Order ID'),
                      Text('${snapshot[index].orderID}'),
                    ],
                  )),
              subtitle: slide(
                  'right',
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date: ${snapshot[index].dateOrdered}'),
                      Text('No. of items: ${snapshot[index].itemnumber}'),
                      Text(
                          'Cost of items: ₦${displayNumber(snapshot[index].itemscost)}'),
                    ],
                  )),
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
}
