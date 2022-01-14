import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:art_hub/common/model.dart';
import 'package:http/http.dart' as http;
import 'package:number_display/number_display.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animator/flutter_animator.dart';

class Sold extends StatefulWidget {
  final List userDetails;
  Sold(this.userDetails);
  @override
  _SoldState createState() => _SoldState();
}

class _SoldState extends State<Sold> {
  final displayNumber = createDisplay(length: 8, decimal: 0);
  List data = [];
  List costlist = [];
  int? summation;
  var sold;

  @override
  void initState() {
    super.initState();
    sold = soldworks();
  }

  soldworks() async {
    Uri link = Uri.parse(
        '${Server.link}/apiR/soldworks/${widget.userDetails[0]}/${widget.userDetails[1]}');

    try {
      var query = await http.get(link,
          headers: {'Content-Type': 'application/json; charset=UTF-8'});
      var decode = jsonDecode(query.body);
      data = decode;
      if (data.isNotEmpty) {
        for (var items in data) {
          costlist.add(items['cost']);
        }
        summation = costlist.reduce((a, b) => a + b);
      }
      return data;
    } catch (error) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    Sizes().heightSizeCalc(context);
    Sizes().widthSizeCalc(context);

    return FutureBuilder(
      future: sold,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return loading();
        } else if (snapshot.hasData == true) {
          return Container(
            child: snapshot.data.length != 0
                ? Padding(
                    padding: EdgeInsets.all(Sizes.w40),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 10,
                          child: itembuilder(snapshot.data),
                        ),
                        Expanded(
                          flex: 1,
                          child: solddetails(snapshot.data.length),
                        ),
                      ],
                    ))
                : Center(
                    child: Text('No sold artwork yet!'),
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
              sold = soldworks();
              setState(() {});
            },
          )));
        }
      },
    );
  }

  itembuilder(List snapshot) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: snapshot.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.only(
              top: Sizes.h8,
              bottom: Sizes.h8,
              left: Sizes.w5,
              right: Sizes.w5,
            ),
            child: Material(
              elevation: 3,
              borderRadius: BorderRadius.all(Radius.circular(Sizes.w30)),
              child: Container(
                height: Sizes.h160,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Padding(
                  padding: EdgeInsets.all(Sizes.w8),
                  child: Row(
                    children: [
                      Container(
                        height: Sizes.h160,
                        width: Sizes.w120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(Sizes.w30),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: snapshot[index]['avatar'],
                            placeholder: (context, url) => new Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  CircularProgressIndicator(
                                    valueColor:
                                        new AlwaysStoppedAnimation<Color>(
                                            AppColors.purple),
                                    strokeWidth: 5.0,
                                  ),
                                ],
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                new Icon(Icons.error),
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.transparent,
                        width: Sizes.h176,
                        padding: EdgeInsets.only(left: Sizes.w20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              '${snapshot[index]['product']}',
                              style: TextStyle(
                                  color: AppColors.purple,
                                  fontWeight: FontWeight.bold,
                                  fontSize: Sizes.w20),
                            ),
                            Text(
                              '${snapshot[index]['type']}',
                              style: TextStyle(
                                  color: AppColors.purple,
                                  fontWeight: FontWeight.normal,
                                  fontSize: Sizes.w20),
                            ),
                            Text(
                              '₦ ${displayNumber(snapshot[index]['cost'])}',
                              style: TextStyle(
                                  color: AppColors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: Sizes.w20),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  solddetails(int itemnumber) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Total Items ($itemnumber)',
          style: TextStyle(
              color: AppColors.purple,
              fontWeight: FontWeight.bold,
              fontSize: Sizes.w25),
        ),
        Text(
          '₦ ${displayNumber(summation!)}',
          textAlign: TextAlign.right,
          style: TextStyle(
              color: AppColors.red,
              fontWeight: FontWeight.bold,
              fontSize: Sizes.w25),
        ),
      ],
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

  loading() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(AppColors.purple),
        strokeWidth: 9.0,
      ),
    );
  }
}
