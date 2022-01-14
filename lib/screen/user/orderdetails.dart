import 'package:flutter/material.dart';
import 'package:art_hub/common/model.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:number_display/number_display.dart';
import 'package:cached_network_image/cached_network_image.dart';

class OrderDetails extends StatefulWidget {
  final List data;
  OrderDetails(this.data);
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  Widgets classWidget = Widgets();
  final displayNumber = createDisplay(length: 8, decimal: 0);
  @override
  Widget build(BuildContext context) {
    Sizes().heightSizeCalc(context);
    Sizes().widthSizeCalc(context);
    return SafeArea(
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: Texts.textScale),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: classWidget.apptitleBar(context, 'Order Details'),
          floatingActionButton: classWidget.floatingHome(context),
          body: Container(
            child: Padding(
              padding: EdgeInsets.all(Sizes.w40),
              child: ListView.builder(
                itemCount: widget.data.length,
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
                      borderRadius:
                          BorderRadius.all(Radius.circular(Sizes.w30)),
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
                                  borderRadius:
                                      BorderRadius.circular(Sizes.w30),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: widget.data[index]['avatar'],
                                    placeholder: (context, url) => new Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          CircularProgressIndicator(
                                            valueColor:
                                                new AlwaysStoppedAnimation<
                                                    Color>(AppColors.purple),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      '${widget.data[index]['product']}',
                                      style: TextStyle(
                                          color: AppColors.purple,
                                          fontWeight: FontWeight.bold,
                                          fontSize: Sizes.w20),
                                    ),
                                    Text(
                                      '${widget.data[index]['type']}',
                                      style: TextStyle(
                                          color: AppColors.purple,
                                          fontWeight: FontWeight.normal,
                                          fontSize: Sizes.w20),
                                    ),
                                    Text(
                                      '₦ ${displayNumber(widget.data[index]['cost'])}',
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
            ),
          ),
        ),
      ),
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
}
