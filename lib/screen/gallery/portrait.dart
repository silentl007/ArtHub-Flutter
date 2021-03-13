import 'package:ArtHub/common/model.dart';
import 'package:ArtHub/screen/middleman.dart';
import 'package:flutter/material.dart';
import 'package:ArtHub/screen/productdetails.dart';
import 'package:number_display/number_display.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String link = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPrefs();
  }

  getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    link =
        'https://arthubserver.herokuapp.com/apiR/cartget/${prefs.getString('id')}/${prefs.getString('accountType')}';
  }

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
                                      child: CachedNetworkImage(
                                        imageUrl: data
                                            .avatar, // replace with data.avatar
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
                                                strokeWidth: 9.0,
                                              ),
                                            ],
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            new Icon(Icons.error),
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
                                            Text(
                                              '${data.productname}',
                                              style: TextStyle(
                                                  color: AppColors.purple,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: fontSize20),
                                            ),
                                            Text(
                                              '₦ ${displayNumber(data.cost)}',
                                              style: TextStyle(
                                                  color: AppColors.red,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: fontSize20),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomRight,
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

  void purchase(
      BuildContext context, ParsedDataProduct itemdetails) {
    print(itemdetails.images);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Middle(itemdetails,)));
  }
}
