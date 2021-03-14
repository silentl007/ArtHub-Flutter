import 'dart:io';
import 'package:ArtHub/screen/homescreen.dart';
import 'package:ArtHub/screen/user/userorders.dart';
import 'package:flutter/material.dart';
import 'package:ArtHub/common/model.dart';
import 'package:ArtHub/common/sqliteoperations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:number_display/number_display.dart';

class PurchaseScreen extends StatefulWidget {
  @override
  _PurchaseScreenState createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  final displayNumber = createDisplay(length: 8, decimal: 0);
  Widgets classWidget = Widgets();
  DataBaseFunctions _dataBaseFunctions;
  String useremail = '';
  String publicKey = 'pk_test_317423d856fb6d9a2201e6b5540a0ad74904da87';
  List data;
  List interfacedatalist;
  int itemnumber = 0;
  int summation = 0;
  int payment;
  @override
  void initState() {
    PaystackPlugin.initialize(publicKey: publicKey);
    super.initState();

    _dataBaseFunctions = DataBaseFunctions.databaseinstance;
    getdata();
    interfacedata();
    getprefs();
  }

  getprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    useremail = prefs.getString('email');
    prefs.setBool('inapp', true);
  }

// SQLite logic
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

   remove(int productInt, int cost) async {
    await _dataBaseFunctions.deleteitem(productInt);
    interfacedata();
    getdataremove(cost);
  }

  Future<List> interfacedata() async {
    List<ParsedDataProduct> databaseList = await _dataBaseFunctions.fetchdata();
    
      interfacedatalist = databaseList;
    
    return interfacedatalist;
  }

// functions for paystack payment
  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }
    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  chargeCard() async {
    payment = summation * 100;
    Charge charge = Charge()
      ..amount = payment
      ..reference = _getReference()
      // or ..accessCode = _getAccessCodeFrmInitialization()
      ..email = useremail;
    CheckoutResponse response = await PaystackPlugin.checkout(context,
        method: CheckoutMethod.card, // Defaults to CheckoutMethod.selectable
        charge: charge,
        logo: Image.asset('assets/appimages/stacklogo.png'));
    if (response.status == true) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => Orders(
                    page: 1,
                  )),
          (Route<dynamic> route) => false);
    } else {
      _showErrorDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
                (Route<dynamic> route) => false);
          },
          child: Icon(Icons.home),
          backgroundColor: AppColors.purple,
        ),
        appBar: classWidget.apptitleBar(context, 'My Cart'),
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
              double padding40 = size.height * 0.05;
              double padding8 = size.height * 0.01001;
              double padding5 = size.height * 0.00625;
              if (snapshot.hasData == false) {
                return Container();
              }
              return Container(
                child: itemnumber != 0
                    ? Padding(
                        padding: EdgeInsets.all(padding40),
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
                                          padding: EdgeInsets.only(
                                            top: padding8,
                                            bottom: padding8,
                                            left: padding5,
                                            right: padding5,
                                          ),
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
                                                padding:
                                                    EdgeInsets.all(padding8),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          30)),
                                                          image: DecorationImage(
                                                              image: AssetImage(
                                                                  snapshot
                                                                      .data[
                                                                          index]
                                                                      .avatar),
                                                              fit: BoxFit
                                                                  .cover)),
                                                      height: innerheight,
                                                      width: size.height * .15,
                                                    ),
                                                    Container(
                                                      color: Colors.transparent,
                                                      width: size.height * .22,
                                                      padding: EdgeInsets.only(
                                                          left: fontSize20),
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
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize:
                                                                    fontSize20),
                                                          ),
                                                          Text(
                                                            '₦ ${displayNumber(snapshot.data[index].cost)}',
                                                            style: TextStyle(
                                                                color: AppColors
                                                                    .red,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize:
                                                                    fontSize20),
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .bottomRight,
                                                            child: RaisedButton(
                                                              color: AppColors
                                                                  .blue,
                                                              onPressed: () => remove(
                                                                  snapshot
                                                                      .data[
                                                                          index]
                                                                      .id,
                                                                  snapshot
                                                                      .data[
                                                                          index]
                                                                      .cost),
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
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
                                              child: Text(
                                                  '₦ ${displayNumber(summation)}',
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
                                              child: Text(
                                                  '₦ ${displayNumber(500)}',
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
                                                  '₦ ${displayNumber(summation + 500)}',
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
                                            onPressed: () => chargeCard(),
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

 

  void _showErrorDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return errorDialog(context);
      },
    );
  }

  Dialog errorDialog(context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height * 0.438;
    double sizedBox15 = size.height * 0.01877;
    double fontSize13 = size.height * 0.01627;
    double fontSize17 = size.height * 0.02128;
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0)), //this right here
      child: Container(
        height: height,
        width: width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.cancel,
                color: Colors.red,
                size: 90,
              ),
              SizedBox(height: sizedBox15),
              Text(
                'Failed to process payment',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: fontSize17,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: sizedBox15),
              Text(
                "Error in processing payment, please try again",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: fontSize13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
