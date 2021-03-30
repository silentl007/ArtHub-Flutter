import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ArtHub/common/model.dart';
import 'package:http/http.dart' as http;
import 'package:number_display/number_display.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Available extends StatefulWidget {
  final List userDetails;
  Available({this.userDetails});
  @override
  _AvailableState createState() => _AvailableState();
}

class _AvailableState extends State<Available> {
  final displayNumber = createDisplay(length: 8, decimal: 0);
  List data = [];
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var upload;

  @override
  void initState() {
    super.initState();
    upload = uploads();
    getprefs();
  }

  getprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('inapp', true);
  }

  uploads() async {
    String link =
        '${Server.link}/apiR/uploaded/${widget.userDetails[0]}/${widget.userDetails[1]}';

    try {
      var query = await http.get(link,
          headers: {'Content-Type': 'application/json; charset=UTF-8'});
      var decode = jsonDecode(query.body);
      data = decode;
      return data;
    } catch (error) {
      return null;
    }
  }

  remove(String productID) async {
    snackbar('Please wait!', 1, AppColors.purple);
    String link =
        '${Server.link}/apiD/uploadremove/${widget.userDetails[0]}/$productID/${widget.userDetails[1]}';
    try {
      var query = await http.delete(link);
      if (query.statusCode == 200) {
        upload = uploads();
        setState(() {});
      }
    } catch (error) {
      print('error from delete - $error');
      return snackbar('Connection failed! Please check internet connection!', 4,
          AppColors.red);
    }
  }

  snackbar(String text, int duration, Color background) {
    return _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(text),
      duration: Duration(seconds: duration),
      backgroundColor: background,
    ));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double padding40 = size.height * 0.05;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        body: FutureBuilder(
          future: upload,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return loading();
            } else if (snapshot.hasData == true) {
              return Container(
                child: snapshot.data.length != 0
                    ? Padding(
                        padding: EdgeInsets.all(padding40),
                        child: itembuilder(snapshot.data),
                      )
                    : Center(
                        child: Text('No item uploaded yet!'),
                      ),
              );
            } else {
              return Container(
                  child: Center(
                      child: RaisedButton(
                child: Text('Retry'),
                onPressed: () {
                  upload = uploads();
                  setState(() {});
                },
              )));
            }
          },
        ),
      ),
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
                            slide(
                                'right',
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Pulse(
                                    preferences: AnimationPreferences(
                                        autoPlay: AnimationPlayStates.Loop),
                                    child: RaisedButton(
                                      color: AppColors.blue,
                                      onPressed: () =>
                                          remove(snapshot[index]['productID']),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50))),
                                      child: Text(
                                        'Remove',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: fontSize20),
                                      ),
                                    ),
                                  ),
                                ))
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

  slide(String direction, Widget widget) {
    if (direction == 'left') {
      return SlideInLeft(
        preferences: AnimationPreferences(
          offset: Duration(seconds: 2),
        ),
        child: widget,
      );
    } else {
      return SlideInRight(
        preferences: AnimationPreferences(offset: Duration(seconds: 2)),
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
