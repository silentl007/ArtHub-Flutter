import 'dart:convert';
import 'dart:io';
import 'package:ArtHub/screen/homescreen.dart';
import 'package:ArtHub/screen/user/userorders.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ArtHub/common/model.dart';
import 'package:ArtHub/common/sqliteoperations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:number_display/number_display.dart';
import 'package:http/http.dart' as http;

class PurchaseScreen extends StatefulWidget {
  final List userDetails;
  PurchaseScreen({this.userDetails});
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
  int summation = 0;
  int payment;
  @override
  void initState() {
    PaystackPlugin.initialize(publicKey: publicKey);
    super.initState();

    // _dataBaseFunctions = DataBaseFunctions.databaseinstance;
    // getdata();
    // interfacedata();
    getprefs();
    cartItems();
  }

  getprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    useremail = prefs.getString('email');
    prefs.setBool('inapp', true);
  }

  // Server Logic
  cartItems() async {
    var link =
        'https://arthubserver.herokuapp.com/apiR/cartget/${widget.userDetails[0]}/${widget.userDetails[1]}';

    try {
      var query = await http.get(link,
          headers: {'Content-Type': 'application/json; charset=UTF-8'});
      var decode = jsonDecode(query.body);
      data = decode;
      if (query.statusCode == 200) {
        data.forEach((element) {
          summation += element['cost'];
          print('costs - ${element['cost']}');
        });
        print('summation number is - $summation');
      }
      return data;
    } catch (error) {
      return null;
    }
  }

// SQLite logic
  // getdata() async {
  //   List<ParsedDataProduct> databaseList = await _dataBaseFunctions.fetchdata();
  //   setState(() {
  //     itemnumber = databaseList.length;
  //     data = databaseList;
  //     data.forEach((element) {
  //       summation += element.cost;
  //     });
  //   });
  // }

  // getdataremove(int cost) async {
  //   List<ParsedDataProduct> databaseList = await _dataBaseFunctions.fetchdata();
  //   setState(() {
  //     itemnumber = databaseList.length;
  //     data = databaseList;
  //     summation -= cost;
  //   });
  // }

  remove(int productInt, int cost) async {
    await _dataBaseFunctions.deleteitem(productInt);
    interfacedata();
    // getdataremove(cost);
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double padding40 = size.height * 0.05;
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
            future: cartItems(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return loading();
              } else if (snapshot.hasData == true) {
                return Container(
                  child: snapshot.data.length != 0
                      ? Padding(
                          padding: EdgeInsets.all(padding40),
                          child: Column(
                            children: [
                              Expanded(
                                  flex: 2, child: itembuilder(snapshot.data)),
                              Expanded(
                                  flex: 1,
                                  child: checkoutsummary(snapshot.data.length)),
                            ],
                          ),
                        )
                      : Center(
                          child: Text('No item in your cart!'),
                        ),
                );
              } else {
                return Container(child: Center(child: Text('Internet')));
              }
            },
          ),
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
                      Container(
                        color: Colors.transparent,
                        width: size.height * .22,
                        padding: EdgeInsets.only(left: fontSize20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              '${snapshot[index]['product']}',
                              style: TextStyle(
                                  color: AppColors.purple,
                                  fontWeight: FontWeight.bold,
                                  fontSize: fontSize20),
                            ),
                            Text(
                              '₦ ${displayNumber(snapshot[index]['cost'])}',
                              style: TextStyle(
                                  color: AppColors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: fontSize20),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: RaisedButton(
                                color: AppColors.blue,
                                onPressed: () => remove(snapshot[index]['id'],
                                    snapshot[index]['cost']),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                child: Text(
                                  'Remove',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: fontSize20),
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
      ),
    );
  }

  checkoutsummary(int itemnumber) {
    Size size = MediaQuery.of(context).size;
    double fontSize20 = size.height * 0.025;
    double fontSize25 = size.height * 0.03125;
    double fontSize15 = size.height * 0.01875;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize25),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize15),
                ),
              )
            ],
          ),
          Container(
            width: double.infinity,
            height: 1,
            color: AppColors.purple,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(
                    color: AppColors.purple,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize25),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Text(
                  '₦ ${displayNumber(summation + 500)}',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      color: AppColors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize25),
                ),
              )
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
                  style: TextStyle(fontSize: fontSize20, color: Colors.white),
                ),
                color: AppColors.red,
                onPressed: () => chargeCard(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
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
