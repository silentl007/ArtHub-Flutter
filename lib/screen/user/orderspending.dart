import 'package:ArtHub/screen/user/orderdetails.dart';
import 'package:flutter/material.dart';
import 'package:ArtHub/common/model.dart';
import 'dart:convert';
import 'package:number_display/number_display.dart';
import 'package:http/http.dart' as http;

class Pending extends StatefulWidget {
  List userDetails;
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
    String link =
        '${Server.link}/apiR/orders/${widget.userDetails[0]}/${widget.userDetails[1]}';

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
    Size size = MediaQuery.of(context).size;
    double padding10 = size.height * 0.0125;
    return FutureBuilder(
      future: getpending,
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
                    child: Text('No Pending Orders'),
                  ),
          );
        } else {
          return Container(
              child: Center(
                  child: RaisedButton(
            child: Text('Retry'),
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
              Radius.circular(25),
            ),
          ),
          child: ListTile(
            onTap: () {
              orderDetails(snapshot[index].purchaseditems);
            },
            leading: Icon(Icons.menu),
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
                Text('Number of items: ${snapshot[index].itemnumber}'),
                Text(
                    'Total cost of items: ₦${displayNumber(snapshot[index].itemscost)}'),
              ],
            ),
          ),
        );
      },
    );
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
