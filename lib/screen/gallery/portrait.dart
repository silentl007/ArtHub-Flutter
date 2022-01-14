import 'package:art_hub/common/model.dart';
import 'package:art_hub/common/middlemen/middlemanproductdetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:number_display/number_display.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PortraitDisplay extends StatefulWidget {
  final List? works;

  PortraitDisplay({this.works});
  @override
  _PortraitDisplayState createState() => _PortraitDisplayState(works: works!);
}

class _PortraitDisplayState extends State<PortraitDisplay> {
  final List? works;
  _PortraitDisplayState({this.works});
  final displayNumber = createDisplay(length: 8, decimal: 0);

  @override
  Widget build(BuildContext context) {
    Sizes().heightSizeCalc(context);
    Sizes().widthSizeCalc(context);
    return works!.isEmpty
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
                      children: works!.map((data) {
                        return Padding(
                          padding: EdgeInsets.only(
                              left: Sizes.w40,
                              right: Sizes.w40,
                              top: Sizes.h10),
                          child: Material(
                            elevation: 10,
                            borderRadius:
                                BorderRadius.all(Radius.circular(Sizes.w30)),
                            child: Container(
                              height: Sizes.h160,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(Sizes.w30)),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(Sizes.w20),
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
                                          errorWidget: (context, url, error) =>
                                              new Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                    SingleChildScrollView(
                                      child: Container(
                                        color: Colors.transparent,
                                        width: Sizes.w176,
                                        padding:
                                            EdgeInsets.only(left: Sizes.w20),
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
                                                  fontSize: Sizes.w20),
                                            ),
                                            Text(
                                              '₦ ${displayNumber(data.cost)}',
                                              style: TextStyle(
                                                  color: AppColors.red,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: Sizes.w20),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: Pulse(
                                                preferences:
                                                    AnimationPreferences(
                                                        offset: Duration(
                                                            seconds: 2),
                                                        autoPlay:
                                                            AnimationPlayStates
                                                                .Loop),
                                                child: ElevatedButton(
                                                  onPressed: () =>
                                                      purchase(context, data),
                                                  style: Decorations()
                                                      .buttonDecor(
                                                          context: context,
                                                          buttoncolor:
                                                              AppColors.blue),
                                                  child: Decorations()
                                                      .buttonText(
                                                          buttonText: 'View',
                                                          context: context,
                                                          fontweight:
                                                              FontWeight.w600,
                                                          fontsize: Sizes.w20),
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
