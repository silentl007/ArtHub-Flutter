import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ArtHub/common/model.dart';
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
    // TODO: implement initState
    super.initState();
    sold = soldworks();
  }

  soldworks() async {
    String link =
        '${Server.link}/apiR/soldworks/${widget.userDetails[0]}/${widget.userDetails[1]}';

    try {
      var query = await http.get(link,
          headers: {'Content-Type': 'application/json; charset=UTF-8'});
      var decode = jsonDecode(query.body);
      data = decode;
      if (data.isNotEmpty) {
        for (var items in data) {
          costlist.add(items['cost']);
        }
        summation = costlist.reduce( (a, b) => a + b);
       
      }
      return data;
    } catch (error) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double padding40 = size.height * 0.05;
    return FutureBuilder(
      future: sold,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return loading();
        } else if (snapshot.hasData == true) {
          return Container(
            child: snapshot.data.length != 0
                ? Padding(
                    padding: EdgeInsets.all(padding40),
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
                  child: RaisedButton(
            child: Text('Retry'),
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
    Size size = MediaQuery.of(context).size;
    double innerheight = size.height * .20;
    double fontSize20 = size.height * 0.025;
    double padding8 = size.height * 0.01001;
    double padding5 = size.height * 0.00625;
    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: snapshot.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.only(
              top: padding8,
              bottom: padding8,
              left: padding5,
              right: padding5,
            ),
            child: Material(
              elevation: 3,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: Container(
                height: size.height * .20,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Padding(
                  padding: EdgeInsets.all(padding8),
                  child: Row(
                    children: [
                      Container(
                        height: innerheight,
                        width: size.height * .15,
                        child: FadeInDown(
                          preferences: AnimationPreferences(
                            offset: Duration(seconds: 2),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30.0),
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
                      ),
                      Container(
                        color: Colors.transparent,
                        width: size.height * .22,
                        padding: EdgeInsets.only(left: fontSize20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            slide(
                                'left',
                                Text(
                                  '${snapshot[index]['product']}',
                                  style: TextStyle(
                                      color: AppColors.purple,
                                      fontWeight: FontWeight.bold,
                                      fontSize: fontSize20),
                                )),
                            slide(
                                'right',
                                Text(
                                  '${snapshot[index]['type']}',
                                  style: TextStyle(
                                      color: AppColors.purple,
                                      fontWeight: FontWeight.normal,
                                      fontSize: fontSize20),
                                )),
                            slide(
                                'left',
                                Text(
                                  '₦ ${displayNumber(snapshot[index]['cost'])}',
                                  style: TextStyle(
                                      color: AppColors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: fontSize20),
                                )),
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
    Size size = MediaQuery.of(context).size;
    double fontSize25 = size.height * 0.03125;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        slide(
            'right',
            Text(
              'Total Items ($itemnumber)',
              style: TextStyle(
                  color: AppColors.purple,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize25),
            )),
        slide(
            'left',
            Text(
              '₦ ${displayNumber(summation!)}',
              textAlign: TextAlign.right,
              style: TextStyle(
                  color: AppColors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize25),
            )),
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
