import 'package:flutter/material.dart';
import 'package:ArtHub/common/model.dart';

class PurchaseScreen extends StatefulWidget {
  @override
  _PurchaseScreenState createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  Selecteditems instancecart = Selecteditems();
  @override
  Widget build(BuildContext context) {
    List items = instancecart.selecteditems;
    print(items);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'My Cart',
                  style: TextStyle(
                    color: AppColors.purple,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        body: items.length == 0
            ? Padding(
                padding: const EdgeInsets.all(60.0),
                child: Column(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Container(
                          color: Colors.red,
                        )),
                    Expanded(
                        flex: 1,
                        child: Container(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Total Items'),
                                  Align(
                                      alignment: Alignment.topRight,
                                      child: Text(
                                        '500',
                                        textAlign: TextAlign.right,
                                      ))
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Service Charge'),
                                  Align(
                                      alignment: Alignment.topRight,
                                      child: Text(
                                        '500',
                                        textAlign: TextAlign.right,
                                      ))
                                ],
                              ),
                              Container(
                                width: double.infinity,
                                height: 1,
                                color: AppColors.purple,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Total'),
                                  Align(
                                      alignment: Alignment.topRight,
                                      child: Text(
                                        '500',
                                        textAlign: TextAlign.right,
                                      ))
                                ],
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: RaisedButton(onPressed: null),
                              )
                            ],
                          ),
                        )),
                  ],
                ),
              )
            : Center(
                child: Text('No item in your cart!'),
              ),
      ),
    );
  }
}
