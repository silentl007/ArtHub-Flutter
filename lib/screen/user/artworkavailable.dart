import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:art_hub/common/model.dart';
import 'package:http/http.dart' as http;
import 'package:number_display/number_display.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Available extends StatefulWidget {
  final List? userDetails;
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
    Uri link = Uri.parse(
        '${Server.link}/apiR/uploaded/${widget.userDetails![0]}/${widget.userDetails![1]}');
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
    Uri link = Uri.parse(
        '${Server.link}/apiD/uploadremove/${widget.userDetails![0]}/$productID/${widget.userDetails![1]}');
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
    return ScaffoldMessenger.of(context).showSnackBar((SnackBar(
      content: Text(text),
      duration: Duration(seconds: duration),
      backgroundColor: background,
    )));
  }

  @override
  Widget build(BuildContext context) {
    Sizes().heightSizeCalc(context);
    Sizes().widthSizeCalc(context);
    return SafeArea(
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: Texts.textScale),
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
                          padding: EdgeInsets.all(Sizes.w40),
                          child: itembuilder(snapshot.data),
                        )
                      : Center(
                          child: Text('No item uploaded yet!'),
                        ),
                );
              } else {
                return Container(
                    child: Center(
                        child: ElevatedButton(
                  style: Decorations()
                      .buttonDecor(context: context, noBorder: true),
                  child: Decorations().buttonText(
                    buttonText: 'Retry',
                    context: context,
                  ),
                  onPressed: () {
                    upload = uploads();
                    setState(() {});
                  },
                )));
              }
            },
          ),
        ),
      ),
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
                        width: Sizes.w176,
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
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Pulse(
                                preferences: AnimationPreferences(
                                    autoPlay: AnimationPlayStates.Loop),
                                child: ElevatedButton(
                                  onPressed: () =>
                                      remove(snapshot[index]['productID']),
                                  style: Decorations().buttonDecor(
                                      context: context,
                                      buttoncolor: AppColors.blue),
                                  child: Decorations().buttonText(
                                      buttonText: 'Remove',
                                      context: context,
                                      fontweight: FontWeight.w600,
                                      fontsize: Sizes.w20),
                                ),
                              ),
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
