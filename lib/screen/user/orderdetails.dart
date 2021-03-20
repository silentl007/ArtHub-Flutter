import 'package:flutter/material.dart';
import 'package:ArtHub/common/model.dart';
import 'package:number_display/number_display.dart';
import 'package:cached_network_image/cached_network_image.dart';

class OrderDetails extends StatefulWidget {
  List data;
  OrderDetails(this.data);
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  Widgets classWidget = Widgets();
  final displayNumber = createDisplay(length: 8, decimal: 0);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double innerheight = size.height * .20;
    double fontSize20 = size.height * 0.025;
    double padding8 = size.height * 0.01001;
    double padding5 = size.height * 0.00625;
    double padding40 = size.height * 0.05;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: classWidget.apptitleBar(context, 'Order Details'),
        body: Container(
          child: Padding(
            padding: EdgeInsets.all(padding40),
            child: ListView.builder(
              itemCount: widget.data.length,
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
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30.0),
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: widget.data[index]['avatar'],
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
                              width: size.height * .22,
                              padding: EdgeInsets.only(left: fontSize20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    '${widget.data[index]['product']}',
                                    style: TextStyle(
                                        color: AppColors.purple,
                                        fontWeight: FontWeight.bold,
                                        fontSize: fontSize20),
                                  ),
                                  Text(
                                    '${widget.data[index]['type']}',
                                    style: TextStyle(
                                        color: AppColors.purple,
                                        fontWeight: FontWeight.normal,
                                        fontSize: fontSize20),
                                  ),
                                  Text(
                                    '₦ ${displayNumber(widget.data[index]['cost'])}',
                                    style: TextStyle(
                                        color: AppColors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: fontSize20),
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
    );
  }
}
