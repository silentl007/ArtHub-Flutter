import 'package:ArtHub/common/model.dart';
import 'package:ArtHub/common/middlemen/middlemanproductdetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:number_display/number_display.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PortraitDisplay extends StatefulWidget {
  final List works;

  PortraitDisplay({this.works});
  @override
  _PortraitDisplayState createState() => _PortraitDisplayState(works: works);
}

class _PortraitDisplayState extends State<PortraitDisplay> {
  final List works;
  _PortraitDisplayState({this.works});
  final displayNumber = createDisplay(length: 8, decimal: 0);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double innerheight = size.height * .20;
    double fontSize20 = size.height * 0.020;
    double padding40 = size.height * 0.05;
    double padding10 = size.height * 0.01252;
    double padding20 = size.height * 0.025;
    return works.isEmpty
        ? Center(
            child: Text('No item found'),
          )
        : SingleChildScrollView(
            child: Container(
                child: Column(
              children: [
                Container(
                  child: SingleChildScrollView(
                    child: Column(
                      children: works.map((data) {
                        return Padding(
                          padding: EdgeInsets.only(
                              left: padding40,
                              right: padding40,
                              top: padding10),
                          child: Material(
                            elevation: 10,
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            child: Container(
                              height: size.height * .20,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(padding20),
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
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                          child: CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            imageUrl: data.avatar,
                                            placeholder: (context, url) =>
                                                new Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  CircularProgressIndicator(
                                                    valueColor:
                                                        new AlwaysStoppedAnimation<
                                                                Color>(
                                                            AppColors.purple),
                                                    strokeWidth: 5.0,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    new Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SingleChildScrollView(
                                      child: Container(
                                        color: Colors.transparent,
                                        width: size.height * .22,
                                        padding:
                                            EdgeInsets.only(left: padding20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            SlideInLeft(
                                              preferences: AnimationPreferences(
                                                offset: Duration(seconds: 2),
                                              ),
                                              child: Text(
                                                '${data.productname}',
                                                style: TextStyle(
                                                    color: AppColors.purple,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: fontSize20),
                                              ),
                                            ),
                                            SlideInRight(
                                              preferences: AnimationPreferences(
                                                offset: Duration(seconds: 2),
                                              ),
                                              child: Text(
                                                '₦ ${displayNumber(data.cost)}',
                                                style: TextStyle(
                                                    color: AppColors.red,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: fontSize20),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: SlideInRight(
                                                preferences:
                                                    AnimationPreferences(
                                                  offset: Duration(seconds: 2),
                                                ),
                                                child: Pulse(
                                                  preferences:
                                                      AnimationPreferences(
                                                          offset: Duration(
                                                              seconds: 2),
                                                          autoPlay:
                                                              AnimationPlayStates
                                                                  .Loop),
                                                  child: RaisedButton(
                                                    color: AppColors.blue,
                                                    onPressed: () =>
                                                        purchase(context, data),
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    50))),
                                                    child: Text(
                                                      'View',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: fontSize20),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                )
              ],
            )),
          );
  }

  void purchase(BuildContext context, ParsedDataProduct itemdetails) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Middle(
                  itemdetails,
                )));
  }
}
