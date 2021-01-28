import 'package:flutter/material.dart';
import 'package:ArtHub/common/model.dart';
import 'package:ArtHub/common/sqliteoperations.dart';
import 'package:flutter_rave/flutter_rave.dart';

class PurchaseScreen extends StatefulWidget {
  @override
  _PurchaseScreenState createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  Widgets classWidget = Widgets();
  DataBaseFunctions _dataBaseFunctions;
  List data;
  List interfacedatalist;
  int itemnumber = 0;
  int summation = 0;
  initState() {
    super.initState();
    setState(() {
      _dataBaseFunctions = DataBaseFunctions.databaseinstance;
    });
    getdata();
    interfacedata();
  }

  getdata() async {
    List<ParsedDataProduct> databaseList = await _dataBaseFunctions.fetchdata();
    setState(() {
      itemnumber = databaseList.length;
      data = databaseList;
      data.forEach((element) {
        summation += element.cost;
      });
    });
  }

  getdataremove(int cost) async {
    List<ParsedDataProduct> databaseList = await _dataBaseFunctions.fetchdata();
    setState(() {
      itemnumber = databaseList.length;
      data = databaseList;
      summation -= cost;
    });
  }

  Future<List> interfacedata() async {
    List<ParsedDataProduct> databaseList = await _dataBaseFunctions.fetchdata();
    setState(() {
      interfacedatalist = databaseList;
    });
    return interfacedatalist;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: classWidget.apptitleBar('My Cart'),
        body: Container(
          color: Colors.white,
          child: FutureBuilder(
            future: interfacedata(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              Size size = MediaQuery.of(context).size;
              double innerheight = size.height * .20;
              double fontSize20 = size.height * 0.025;
              double fontSize25 = size.height * 0.03125;
              double fontSize15 = size.height * 0.01875;
              if (snapshot.hasData == false) {
                return Container();
              }
              return Container(
                child: itemnumber != 0
                    ? Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Column(
                          children: [
                            Expanded(
                                flex: 2,
                                child: Container(
                                  color: Colors.white,
                                    child: ListView.builder(
                                  itemCount: snapshot.data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, bottom: 8, left: 5, right: 5,),
                                      child: Material(
                                        elevation: 3,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)),
                                        child: Container(
                                          height: size.height * .20,
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  30)),
                                                      image: DecorationImage(
                                                          image: AssetImage(
                                                              snapshot
                                                                  .data[index]
                                                                  .avatar),
                                                          fit: BoxFit.cover)),
                                                  height: innerheight,
                                                  width: size.height * .15,
                                                ),
                                                Container(
                                                  color: Colors.transparent,
                                                  width: size.height * .22,
                                                  padding:
                                                      EdgeInsets.only(left: 20),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Text(
                                                        '${snapshot.data[index].productname}',
                                                        style: TextStyle(
                                                            color: AppColors
                                                                .purple,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize:
                                                                fontSize20),
                                                      ),
                                                      Text(
                                                        '₦ ${snapshot.data[index].cost}',
                                                        style: TextStyle(
                                                            color:
                                                                AppColors.red,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize:
                                                                fontSize20),
                                                      ),
                                                      Align(
                                                        alignment: Alignment
                                                            .bottomRight,
                                                        child: RaisedButton(
                                                          color: AppColors.blue,
                                                          onPressed: () =>
                                                              remove(
                                                                  snapshot
                                                                      .data[
                                                                          index]
                                                                      .id,
                                                                  snapshot
                                                                      .data[
                                                                          index]
                                                                      .cost),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          50))),
                                                          child: Text(
                                                            'Remove',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize:
                                                                    fontSize20),
                                                          ),
                                                        ),
                                                      )
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
                                ))),
                            Expanded(
                                flex: 1,
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Total Items ($itemnumber)',
                                            style: TextStyle(
                                                color: AppColors.purple,
                                                fontWeight: FontWeight.bold,
                                                fontSize: fontSize25),
                                          ),
                                          Align(
                                              alignment: Alignment.topRight,
                                              child: Text('₦ $summation',
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                      color: AppColors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: fontSize25)))
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Service Charge',
                                              style: TextStyle(
                                                  color: AppColors.purple,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: fontSize15)),
                                          Align(
                                              alignment: Alignment.topRight,
                                              child: Text('₦ 500',
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                      color: AppColors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: fontSize15)))
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
                                          Text('Total',
                                              style: TextStyle(
                                                  color: AppColors.purple,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: fontSize25)),
                                          Align(
                                              alignment: Alignment.topRight,
                                              child: Text(
                                                  '₦ ${summation + 500}',
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                      color: AppColors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: fontSize25)))
                                        ],
                                      ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          width: size.width * .35,
                                          height: size.height * .07,
                                          child: RaisedButton(
                                            elevation: 15,
                                            child: Text(
                                              'Checkout',
                                              style: TextStyle(
                                                  fontSize: fontSize20,
                                                  color: Colors.white),
                                            ),
                                            color: AppColors.red,
                                            onPressed: () =>
                                                purchase(context, summation),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(50))),
                                          ),
                                        ),
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
              );
            },
          ),
        ),
      ),
    );
  }

  remove(int productInt, int cost) async {
    await _dataBaseFunctions.deleteitem(productInt);
    interfacedata();
    getdataremove(cost);
  }

  purchase(BuildContext context, int cost) {
    final _payment = RaveCardPayment(
        isDemo: true,
        publicKey: 'FLWPUBK-1efc1119172b9d4a878f5a507c48f4f2-X',
        encKey: 'c040160e6dabc8df175e8fc9',
        transactionRef: 'yysgvdgq67g',
        amount: cost.toDouble(),
        email: 'xtreemsilentl@gmail.com',
        context: context);
    _payment.process();
  }
}
