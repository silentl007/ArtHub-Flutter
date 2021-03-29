import 'dart:convert';
import 'dart:io';
import 'package:ArtHub/common/middlemen/middleorders.dart';
import 'package:ArtHub/screen/homescreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ArtHub/common/model.dart';
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
  var cartItemsVar;
  Widgets classWidget = Widgets();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String useremail = '';
  String username = '';
  String publicKey = 'pk_test_317423d856fb6d9a2201e6b5540a0ad74904da87';
  String address = '';
  String location = '';
  String cardNumber = '';
  String cvvCode = '';
  List data;
  int expiryMonth;
  int expiryYear;
  int summation = 0;
  int servicecharge = 500;
  int payment;
  List costlist = [];
  @override
  void initState() {
    PaystackPlugin.initialize(publicKey: publicKey);
    super.initState();
    getprefs();
    cartItemsVar = cartItems();
  }

  getprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    useremail = prefs.getString('email');
    username = prefs.getString('displayName');
    address = prefs.getString('address');
    location = prefs.getString('location');
    cardNumber = prefs.getString('cardNumber');
    cvvCode = prefs.getString('cvvCode');
    expiryMonth = prefs.getInt('expiryMonth');
    expiryYear = prefs.getInt('expiryYear');
    prefs.setBool('inapp', true);
  }

  // Server Logic
  cartItems() async {
    String link =
        '${Server.link}/apiR/cartget/${widget.userDetails[0]}/${widget.userDetails[1]}';

    try {
      var query = await http.get(link,
          headers: {'Content-Type': 'application/json; charset=UTF-8'});
      var decode = jsonDecode(query.body);
      data = decode;
      if (data.isNotEmpty) {
        for (var items in data) {
          costlist.add(items['cost']);
        }
        summation = costlist.fold(0, (a, b) => a + b);
      }
      return data;
    } catch (error) {
      return null;
    }
  }

  remove(String productID) async {
    snackbar('Please wait!', 1, AppColors.purple);
    String link =
        '${Server.link}/apiD/cartremove/${widget.userDetails[0]}/$productID/${widget.userDetails[1]}';
    try {
      var query = await http.delete(link);
      if (query.statusCode == 200) {
        summation = 0;
        costlist = [];
        cartItemsVar = cartItems();
        setState(() {});
      }
    } catch (error) {
      print('error from delete - $error');
      return snackbar('Connection failed! Please check internet connection!', 4,
          AppColors.red);
    }
  }

  checkitemsavailability() async {
    snackbar('Please wait! Checking product availability', 1, AppColors.purple);
    String link = '${Server.link}/apiS/checkcart';
    Map<String, dynamic> body = {"purchaseditems": data, "test": "tested"};
    var encodedData = jsonEncode(body);
    try {
      var datasend = await http.post(link,
          body: encodedData,
          headers: {'Content-Type': 'application/json; charset=UTF-8'});
      var decoded = jsonDecode(datasend.body);
      print(decoded);
      if (datasend.statusCode == 200) {
        chargeCard();
        // snackbar('All items checked and are available', 4, AppColors.purple);
      } else if (datasend.statusCode == 404) {
        snackbar('Please remove the unavailable item - ${decoded['itemname']}',
            4, AppColors.red);
      } else {
        snackbar('server error', 4, AppColors.red);
      }
    } catch (error) {
      print('the error of checkitemsavailability is - $error');
      return snackbar('Connection failed! Please check internet connection!', 4,
          AppColors.red);
    }
  }

  purchaseOrder() async {
    String link = '${Server.link}/apiS/purchaseorders';
    Map body = {
      "userID": widget.userDetails[0].toString(),
      "accountType": widget.userDetails[1].toString(),
      "name": username,
      "email": useremail,
      "itemnumber": data.length,
      "deliveryAddress": '$address, $location State',
      "totalcost": payment,
      "itemscost": summation,
      "purchaseditems": data,
    };
    var encodedData = jsonEncode(body);
    try {
      var datasend = await http.post(link,
          body: encodedData,
          headers: {'Content-Type': 'application/json; charset=UTF-8'});
      if (datasend.statusCode == 200) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => MiddleOrders(
                      page: 1,
                    )),
            (Route<dynamic> route) => false);
      } else {
        return snackbar(
            'Something went wrong! Please try again!', 4, AppColors.red);
      }
    } catch (error) {
      return snackbar('Connection failed! Please check internet connection!', 4,
          AppColors.red);
    }
  }

  snackbar(String text, int duration, Color background) {
    return _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(text),
      duration: Duration(seconds: duration),
      backgroundColor: background,
    ));
  }

// functions for paystack payment
  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }
    return 'ChargedFrom user - ${widget.userDetails[0]} at time - _${DateTime.now().millisecondsSinceEpoch}';
  }

  chargeCard() async {
    payment = (summation + servicecharge) * 100;
    Charge charge = Charge()
      ..amount = payment
      ..reference = _getReference()
      ..card = PaymentCard(
        number: cardNumber,
        expiryMonth: expiryMonth,
        expiryYear: expiryYear,
        cvc: cvvCode,
      )
      // or ..accessCode = _getAccessCodeFrmInitialization()
      ..email = useremail;
    CheckoutResponse response = await PaystackPlugin.checkout(
      context,
      method: CheckoutMethod.card, // Defaults to CheckoutMethod.selectable
      charge: charge,
    );
    // logo: Image.asset('assets/appimages/stacklogo.png'));
    if (response.status == true) {
      snackbar('Please wait!', 1, AppColors.purple);
      purchaseOrder();
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
        key: _scaffoldKey,
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
            future: cartItemsVar,
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
                return Container(
                    child: Center(
                        child: RaisedButton(
                  child: Text('Retry'),
                  onPressed: () {
                    cartItemsVar = cartItems();
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
                              '${snapshot[index]['type']}',
                              style: TextStyle(
                                  color: AppColors.purple,
                                  fontWeight: FontWeight.normal,
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
                                onPressed: () =>
                                    remove(snapshot[index]['productID']),
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
                  '₦ ${displayNumber(servicecharge)}',
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
                  '₦ ${displayNumber(summation + servicecharge)}',
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
                onPressed: () => checkitemsavailability(),
                // onPressed: ()=> purchaseOrder(),
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
