import 'dart:convert';
import 'package:ArtHub/common/model.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ArtHub/screen/purchasescreen.dart';
import 'package:number_display/number_display.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProductDetails extends StatefulWidget {
  final ParsedDataProduct data;
  final List userDetails;
  ProductDetails(this.data, this.userDetails);

  @override
  _ProductDetailsState createState() => _ProductDetailsState(data);
}

class _ProductDetailsState extends State<ProductDetails> {
  final ParsedDataProduct data;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final displayNumber = createDisplay(length: 8, decimal: 0);
  String userID = '';
  String accountType = '';
  List cart = [];
  int itemnumber = 0;
  List pseudodata = [1, 1, 1, 1, 1, 1, 1, 1];
  _ProductDetailsState(this.data);
  @override
  initState() {
    super.initState();
    cartItems();
  }

  int _current = 0;
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  // getPrefs() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     userID = prefs.getString('userID');
  //     accountType = prefs.getString('accountType');
  //   });
  // }

  cartItems() async {
    var link =
        'https://arthubserver.herokuapp.com/apiR/cartget/${widget.userDetails[0]}/${widget.userDetails[1]}';
    try {
      print(link);
      var query = await http.get(link,
          headers: {'Content-Type': 'application/json; charset=UTF-8'});
      var decode = jsonDecode(query.body);
      print('cart items - $decode');
      decode = cart;
      setState(() {
        itemnumber = cart.length;
      });
    } catch (error) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 4),
        content: Text('Connection failed! Please check internet connection!'),
        backgroundColor: AppColors.red,
      ));
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fontSize20 = size.height * 0.025;
    double fontSize25 = size.height * 0.03125;
    double costHeight40 = size.height * 0.05;
    double costWidth90 = size.width * 0.2;
    double padding30 = size.height * 0.0375;
    double padding70 = size.height * 0.0876;
    double padding10 = size.height * 0.01252;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () => addcart(data),
          child: Icon(Icons.add_shopping_cart),
          backgroundColor: AppColors.purple,
        ),
        appBar: AppBar(
          title: Text('Details'),
          actions: [
            InkWell(
              onTap: () {
                purchasecreen();
              },
              child: Padding(
                padding: EdgeInsets.only(right: padding30),
                child: Row(
                  children: [
                    Text(
                      '$itemnumber',
                      style: TextStyle(
                          color: AppColors.purple, fontSize: fontSize20),
                    ),
                    Icon(
                      Icons.shopping_cart,
                      size: 30,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: Column(children: [
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: fontSize25),
                    child: CarouselSlider(
                      height: size.height * 0.35,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      autoPlayInterval: Duration(seconds: 2),
                      pauseAutoPlayOnTouch: Duration(seconds: 5),
                      autoPlayAnimationDuration: Duration(seconds: 1),
                      initialPage: 0,
                      onPageChanged: (index) {
                        setState(() {
                          _current = index;
                        });
                      },
                      items: pseudodata.map((images) {
                        // replace with data.image
                        return Material(
                          color: Colors.transparent,
                          elevation: 10,
                          borderRadius: BorderRadius.circular(10),
                          borderOnForeground: false,
                          child: Container(
                            height: size.height * 0.35,
                            width: size.width * .75,
                            child: CachedNetworkImage(
                              imageUrl:
                                  "http://via.placeholder.com/350x150", // replace with images
                              placeholder: (context, url) => new Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    CircularProgressIndicator(
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
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
                        );
                      }).toList(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: map<Widget>(data.images, (index, url) {
                      return Container(
                        width: 10,
                        height: 10,
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _current == index
                                ? AppColors.purple
                                : AppColors.grey),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
                width: size.width,
                height: size.height * .45,
                decoration: BoxDecoration(
                    // color: AppColors.grey,
                    // border: Border.all(color: AppColors.purple),
                    borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(100),
                  topRight: Radius.circular(100),
                )),
                child: Column(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Container(
                          color: Colors.transparent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: padding70),
                                    child: Container(
                                      color: Colors.transparent,
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            data.productname,
                                            style: TextStyle(
                                                color: AppColors.purple,
                                                fontSize: fontSize25,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ),
                                  )),
                              Expanded(
                                flex: 1,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    height: costHeight40,
                                    width: costWidth90,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        color: AppColors.red),
                                    child: Center(
                                        child: Text(
                                      '₦ ${displayNumber(data.cost)}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: fontSize20),
                                    )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                    Expanded(
                      flex: 3,
                      child: Stack(
                        children: [
                          Container(
                            child: Padding(
                              padding: EdgeInsets.only(left: padding70, top: 0),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text('Type:',
                                        style: TextStyle(
                                            fontSize: fontSize20,
                                            color: AppColors.purple,
                                            fontWeight: FontWeight.w700)),
                                    Text('${data.type}',
                                        style: TextStyle(
                                            fontSize: fontSize20,
                                            color: AppColors.purple)),
                                    Text('Description:',
                                        style: TextStyle(
                                            fontSize: fontSize20,
                                            color: AppColors.purple,
                                            fontWeight: FontWeight.w700)),
                                    Text(
                                      '${data.description}:',
                                      style: TextStyle(
                                          fontSize: fontSize20,
                                          color: AppColors.purple),
                                    ),
                                    Text('Weight:',
                                        style: TextStyle(
                                            fontSize: fontSize20,
                                            color: AppColors.purple,
                                            fontWeight: FontWeight.w700)),
                                    Text(
                                      '${data.weight} kg',
                                      style: TextStyle(
                                          fontSize: fontSize20,
                                          color: AppColors.purple),
                                    ),
                                    Text('Dimensions:',
                                        style: TextStyle(
                                            fontSize: fontSize20,
                                            color: AppColors.purple,
                                            fontWeight: FontWeight.w700)),
                                    Text(
                                      '${data.dimension} inchs',
                                      style: TextStyle(
                                          fontSize: fontSize20,
                                          color: AppColors.purple),
                                    ),
                                    Text('Materials:',
                                        style: TextStyle(
                                            fontSize: fontSize20,
                                            color: AppColors.purple,
                                            fontWeight: FontWeight.w700)),
                                    Text(
                                      '${data.materials}',
                                      style: TextStyle(
                                          fontSize: fontSize20,
                                          color: AppColors.purple),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          )
        ]),
      ),
    );
  }

  void purchasecreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PurchaseScreen()));
  }

  addcart(ParsedDataProduct cartitem) async {
    print('cartitem - ${cartitem.productID}');
    print(cart.isEmpty);
    if (cart.isNotEmpty) {
      for (var items in cart) {
        if (items.productID == cartitem.productID) {
          print('already in cart!');
        } else {
          cart.add(cartitem);
          print('add to cart');
        }
      }
    } else {
      print('empty cart');
    }

    //   if (itemcheck.contains(cartitem.productname)) {
    //     return _scaffoldKey.currentState.showSnackBar(SnackBar(
    //       duration: Duration(seconds: 1),
    //       content: Text('Already in cart!'),
    //       backgroundColor: AppColors.red,
    //     ));
    //   } else {
    //     await _dataBaseFunctions.insertitem(cartitem);
    //     // getdata();
    //     return _scaffoldKey.currentState.showSnackBar(SnackBar(
    //       content: Text('Added to cart!'),
    //       duration: Duration(seconds: 1),
    //       backgroundColor: AppColors.purple,
    //     ));
    //   }
  }
}
