import 'dart:convert';
import 'dart:io';
import 'package:art_hub/common/middlemen/middleorders.dart';
import 'package:art_hub/screen/homescreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:art_hub/common/model.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:number_display/number_display.dart';
import 'package:http/http.dart' as http;

class PurchaseScreen extends StatefulWidget {
  final List? userDetails;
  final homecheck;
  PurchaseScreen({this.userDetails, this.homecheck});
  @override
  _PurchaseScreenState createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  final displayNumber = createDisplay(length: 8, decimal: 0);
  var cartItemsVar;
  Widgets classWidget = Widgets();
  PaystackPlugin paystack = PaystackPlugin();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String useremail = '';
  String username = '';
  String address = '';
  String location = '';
  String cardNumber = '';
  String cvvCode = '';
  List? data;
  int? expiryMonth;
  int? expiryYear;
  int summation = 0;
  int servicecharge = 500;
  int? payment;
  List costlist = [];
  @override
  void initState() {
    paystack.initialize(publicKey: Texts.publicKey);
    super.initState();
    getprefs();
    cartItemsVar = cartItems();
  }

  getprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    useremail = prefs.getString('email')!;
    username = prefs.getString('displayName')!;
    address = prefs.getString('address')!;
    location = prefs.getString('location')!;
    cardNumber = prefs.getString('cardNumber')!;
    cvvCode = prefs.getString('cvvCode')!;
    expiryMonth = prefs.getInt('expiryMonth');
    expiryYear = prefs.getInt('expiryYear');
    prefs.setBool('inapp', true);
  }

  // Server Logic
  cartItems() async {
    Uri link = Uri.parse(
        '${Server.link}/apiR/cartget/${widget.userDetails![0]}/${widget.userDetails![1]}');

    try {
      var query = await http.get(link,
          headers: {'Content-Type': 'application/json; charset=UTF-8'});
      var decode = jsonDecode(query.body);
      data = decode;
      if (data!.isNotEmpty) {
        for (var items in data!) {
          costlist.add(items['cost']);
        }
        summation = costlist.reduce((a, b) => a + b);
      }
      return data;
    } catch (error) {
      return null;
    }
  }

  remove(String productID) async {
    snackbar('Please wait!', 1, AppColors.purple);
    Uri link = Uri.parse(
        '${Server.link}/apiD/cartremove/${widget.userDetails![0]}/$productID/${widget.userDetails![1]}');
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
    Uri link = Uri.parse('${Server.link}/apiS/checkcart');
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
    Uri link = Uri.parse('${Server.link}/apiS/purchaseorders');
    Map body = {
      "userID": widget.userDetails![0].toString(),
      "accountType": widget.userDetails![1].toString(),
      "name": username,
      "email": useremail,
      "itemnumber": data!.length,
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
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      duration: Duration(seconds: duration),
      backgroundColor: background,
    ));
  }

// functions for paystack payment
  String _getReference() {
    // ignore: unused_local_variable
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }
    return 'ChargedFrom user - ${widget.userDetails![0]} at time - _${DateTime.now().millisecondsSinceEpoch}';
  }

  chargeCard() async {
    payment = (summation + servicecharge) * 100;
    Charge charge = Charge()
      ..amount = payment!
      ..reference = _getReference()
      ..card = PaymentCard(
        number: cardNumber,
        expiryMonth: expiryMonth,
        expiryYear: expiryYear,
        cvc: cvvCode,
      )
      // or ..accessCode = _getAccessCodeFrmInitialization()
      ..email = useremail;
    CheckoutResponse response = await paystack.checkout(
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
        return errorDialog();
      },
    );
  }

  Dialog errorDialog() {
    Sizes().heightSizeCalc(context);
    Sizes().widthSizeCalc(context);
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Sizes.w5)), //this right here
      child: Container(
        height: Sizes.h350,
        width: double.infinity,
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
              SizedBox(height: Sizes.h15),
              Text(
                'Failed to process payment',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: Sizes.w17,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: Sizes.h15),
              Text(
                "Error in processing payment, please try again",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: Sizes.w13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: Texts.textScale),
        child: Scaffold(
          key: _scaffoldKey,
          floatingActionButton: classWidget.floatingHome(context),
          appBar: classWidget.apptitleBar(context, 'My Cart'),
          body: WillPopScope(
            onWillPop: () async {
              if (widget.homecheck == 'home') {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                    (Route<dynamic> route) => false);
                return true;
              } else {
                Navigator.pop(context);
                return true;
              }
            },
            child: Container(
              color: Colors.white,
              child: FutureBuilder(
                future: cartItemsVar,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return loading();
                  } else if (snapshot.hasData == true) {
                    return Container(
                      child: snapshot.data.length != 0
                          ? Column(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Padding(
                                        padding: EdgeInsets.all(Sizes.w40),
                                        child: itembuilder(snapshot.data))),
                                Expanded(
                                    flex: 1,
                                    child: Padding(
                                        padding: EdgeInsets.all(Sizes.w40),
                                        child: checkoutsummary(
                                            snapshot.data.length))),
                              ],
                            )
                          : Center(
                              child: Text('No item in your cart!'),
                            ),
                    );
                  } else {
                    return Container(
                        child: Center(
                            child: ElevatedButton(
                      style: Decorations()
                          .buttonDecor(context: context, noBorder: false),
                      child: Decorations()
                          .buttonText(buttonText: 'Retry', context: context),
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
        ),
      ),
    );
  }

  itembuilder(List snapshot) {
    Sizes().heightSizeCalc(context);
    Sizes().widthSizeCalc(context);
    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: snapshot.length,
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
              borderRadius: BorderRadius.all(Radius.circular(Sizes.w30)),
              child: Container(
                height: Sizes.h165,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Padding(
                  padding: EdgeInsets.all(Sizes.w8),
                  child: Row(
                    children: [
                      Container(
                        height: Sizes.h165,
                        width: Sizes.h120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(Sizes.w30),
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
                        width: Sizes.h180,
                        padding: EdgeInsets.only(left: Sizes.w20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              '${snapshot[index]['product']}',
                              style: TextStyle(
                                  color: AppColors.purple,
                                  fontWeight: FontWeight.bold,
                                  fontSize: Sizes.w20),
                            ),
                            Text(
                              '${snapshot[index]['type']}',
                              style: TextStyle(
                                  color: AppColors.purple,
                                  fontWeight: FontWeight.normal,
                                  fontSize: Sizes.w20),
                            ),
                            Text(
                              '₦ ${displayNumber(snapshot[index]['cost'])}',
                              style: TextStyle(
                                  color: AppColors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: Sizes.w20),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Pulse(
                                preferences: AnimationPreferences(
                                    offset: Duration(seconds: 3),
                                    autoPlay: AnimationPlayStates.Loop),
                                child: ElevatedButton(
                                    onPressed: () =>
                                        remove(snapshot[index]['productID']),
                                    style: Decorations().buttonDecor(
                                        context: context,
                                        buttoncolor: AppColors.blue),
                                    child: Decorations().buttonText(
                                        buttonText: 'Remove',
                                        context: context,
                                        fontweight: FontWeight.w600,
                                        fontsize: Sizes.w20)),
                              ),
                            )
                          ],
                        ),
                      ),
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

  slide(String direction, int duration, Widget widget) {
    if (direction == 'left') {
      return SlideInLeft(
        preferences: AnimationPreferences(
          offset: Duration(seconds: duration),
        ),
        child: widget,
      );
    } else {
      return SlideInRight(
        preferences:
            AnimationPreferences(duration: Duration(seconds: duration)),
        child: widget,
      );
    }
  }

  checkoutsummary(int itemnumber) {
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
                    fontSize: Sizes.w25),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Text(
                  '₦ ${displayNumber(summation)}',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      color: AppColors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: Sizes.w25),
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
                      fontSize: Sizes.w15)),
              Align(
                alignment: Alignment.topRight,
                child: Text(
                  '₦ ${displayNumber(servicecharge)}',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      color: AppColors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: Sizes.w15),
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
                    fontSize: Sizes.w25),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Text(
                  '₦ ${displayNumber(summation + servicecharge)}',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      color: AppColors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: Sizes.w25),
                ),
              )
            ],
          ),
          BounceInDown(
            preferences: AnimationPreferences(offset: Duration(seconds: 1)),
            child: HeartBeat(
              preferences: AnimationPreferences(
                  offset: Duration(seconds: 3),
                  autoPlay: AnimationPlayStates.Loop),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: Sizes.w150,
                  height: Sizes.h60,
                  child: ElevatedButton(
                    style: Decorations().buttonDecor(
                        context: context,
                        elevation: 15,
                        buttoncolor: AppColors.red),
                    child: Decorations().buttonText(
                        buttonText: 'Checkout',
                        context: context,
                        fontsize: Sizes.w20),
                    onPressed: () => checkitemsavailability(),
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
