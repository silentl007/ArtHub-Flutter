import 'dart:convert';
import 'package:art_hub/common/middlemen/middlemancart.dart';
import 'package:art_hub/common/model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:number_display/number_display.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
  _ProductDetailsState(this.data);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final displayNumber = createDisplay(length: 8, decimal: 0);
  GlobalKey<AnimatorWidgetState> _cartAnimationkey =
      GlobalKey<AnimatorWidgetState>();
  List cart = [];
  List productIDs = [];
  int? itemnumber;
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

  cartItems() async {
    Uri link = Uri.parse(
        '${Server.link}/apiR/cartget/${widget.userDetails[0]}/${widget.userDetails[1]}');

    try {
      var query = await http.get(link,
          headers: {'Content-Type': 'application/json; charset=UTF-8'});
      var decode = jsonDecode(query.body);
      cart = decode;
      if (query.statusCode == 200) {
        setState(() {
          itemnumber = cart.length;
        });
        if (cart.isNotEmpty) {
          for (var items in cart) {
            productIDs.add(items['productID']);
          }
        }
      }
    } catch (error) {
      return snackbar('Connection failed! Please check internet connection!', 4,
          AppColors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    Sizes().heightSizeCalc(context);
    Sizes().widthSizeCalc(context);
    return SafeArea(
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: Texts.textScale),
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          floatingActionButton: BounceInDown(
            preferences: AnimationPreferences(duration: Duration(seconds: 2)),
            child: FloatingActionButton(
              onPressed: () => addcart(data),
              child: Icon(Icons.add_shopping_cart),
              backgroundColor: AppColors.purple,
            ),
          ),
          appBar: AppBar(
            title: Decorations()
                .buttonText(buttonText: 'Details', context: context),
            actions: [
              SlideInLeft(
                preferences:
                    AnimationPreferences(duration: Duration(seconds: 2)),
                child: HeartBeat(
                  key: _cartAnimationkey,
                  child: InkWell(
                    onTap: () {
                      purchasecreen();
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: Sizes.w30),
                      child: Row(
                        children: [
                          itemnumber == null
                              ? loading()
                              : Text(
                                  '$itemnumber',
                                  style: TextStyle(
                                      color: AppColors.purple,
                                      fontSize: Sizes.w20),
                                ),
                          Icon(
                            Icons.shopping_cart,
                            size: Sizes.w30,
                          ),
                        ],
                      ),
                    ),
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
                      padding: EdgeInsets.only(top: Sizes.w25),
                      child: CarouselSlider(
                        options: CarouselOptions(
                          height: Sizes.h350,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          autoPlayInterval: Duration(seconds: 2),
                          pauseAutoPlayOnTouch: true,
                          autoPlayAnimationDuration: Duration(seconds: 1),
                          initialPage: 0,
                          onPageChanged:
                              (index, CarouselPageChangedReason changedReason) {
                            setState(() {
                              _current = index;
                            });
                          },
                        ),
                        items: data.images!.map((imageURL) {
                          return Material(
                            color: Colors.transparent,
                            // elevation: 1,
                            borderRadius: BorderRadius.circular(Sizes.w10),
                            borderOnForeground: false,
                            child: Container(
                              height: Sizes.h350,
                              width: Sizes.w317,
                              child: CachedNetworkImage(
                                imageUrl: imageURL,
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
                      children: map<Widget>(data.images!, (index, url) {
                        return Container(
                          width: Sizes.w10,
                          height: Sizes.h10,
                          margin: EdgeInsets.symmetric(
                              vertical: Sizes.h10, horizontal: Sizes.w2),
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
                  width: double.infinity,
                  height: Sizes.h360,
                  decoration: BoxDecoration(
                      // color: AppColors.grey,
                      // border: Border.all(color: AppColors.purple),
                      borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Sizes.w100),
                    topRight: Radius.circular(Sizes.w100),
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
                                      padding: EdgeInsets.only(left: Sizes.w70),
                                      child: Container(
                                        color: Colors.transparent,
                                        child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              data.productname!,
                                              style: TextStyle(
                                                  color: AppColors.purple,
                                                  fontSize: Sizes.w25,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ),
                                    )),
                                Expanded(
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      height: Sizes.h40,
                                      width: Sizes.w90,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(Sizes.w10)),),
                                      child: Center(
                                          child: Text(
                                        '₦ ${displayNumber(data.cost!)}',
                                        style: TextStyle(
                                            color: AppColors.red,
                                            fontWeight: FontWeight.w700,
                                            fontSize: Sizes.w20),
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
                                padding:
                                    EdgeInsets.only(left: Sizes.w70, top: 0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text('Type:',
                                          style: TextStyle(
                                              fontSize: Sizes.w20,
                                              color: AppColors.purple,
                                              fontWeight: FontWeight.w700)),
                                      Text('${data.type}',
                                          style: TextStyle(
                                              fontSize: Sizes.w20,
                                              color: AppColors.purple)),
                                      Text('Description:',
                                          style: TextStyle(
                                              fontSize: Sizes.w20,
                                              color: AppColors.purple,
                                              fontWeight: FontWeight.w700)),
                                      Text(
                                        '${data.description}',
                                        style: TextStyle(
                                            fontSize: Sizes.w20,
                                            color: AppColors.purple),
                                      ),
                                      Text('Weight:',
                                          style: TextStyle(
                                              fontSize: Sizes.w20,
                                              color: AppColors.purple,
                                              fontWeight: FontWeight.w700)),
                                      Text(
                                        '${data.weight} kg',
                                        style: TextStyle(
                                            fontSize: Sizes.w20,
                                            color: AppColors.purple),
                                      ),
                                      Text('Dimensions:',
                                          style: TextStyle(
                                              fontSize: Sizes.w20,
                                              color: AppColors.purple,
                                              fontWeight: FontWeight.w700)),
                                      Text(
                                        '${data.dimension} inchs',
                                        style: TextStyle(
                                            fontSize: Sizes.w20,
                                            color: AppColors.purple),
                                      ),
                                      Text('Materials:',
                                          style: TextStyle(
                                              fontSize: Sizes.w20,
                                              color: AppColors.purple,
                                              fontWeight: FontWeight.w700)),
                                      Text(
                                        '${data.materials}',
                                        style: TextStyle(
                                            fontSize: Sizes.w20,
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
      ),
    );
  }

  void purchasecreen() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MiddleCart()));
  }

  addcart(ParsedDataProduct cartitem) async {
    if (productIDs.isNotEmpty) {
      if (productIDs.contains(cartitem.productID)) {
        return snackbar('Already in cart!', 4, AppColors.red);
      } else {
        snackbar('Please wait!', 1, AppColors.purple);
        added(cartitem);
      }
    } else {
      snackbar('Please wait!', 1, AppColors.purple);
      added(cartitem);
    }
  }

  added(ParsedDataProduct cartitem) async {
    if (itemnumber == null) {
      return snackbar('Please wait! Fetching data!', 1, AppColors.purple);
    } else {
      Uri link = Uri.parse(
          '${Server.link}/apiS/cartadd/${widget.userDetails[0]}/${widget.userDetails[1]}');
      Map<String, dynamic> dataBody = {
        "productID": cartitem.productID,
        "accountType": cartitem.accountType,
        "artistemail": cartitem.artistemail,
        "name": cartitem.artistname,
        "product": cartitem.productname,
        "cost": cartitem.cost,
        "type": cartitem.type,
        "avatar": cartitem.avatar,
        "description": cartitem.description,
        "dimension": cartitem.dimension,
        "weight": cartitem.weight,
        "materials": cartitem.materials,
      };
      var encodedData = jsonEncode(dataBody);
      try {
        var add = await http.post(link,
            body: encodedData,
            headers: {'Content-Type': 'application/json; charset=UTF-8'});
        if (add.statusCode == 200) {
          cartItems();
          _cartAnimationkey.currentState!.forward();
          return snackbar('Added to cart!', 1, AppColors.purple);
        }
      } catch (error) {
        return snackbar('Connection failed! Please check internet connection!',
            4, AppColors.red);
      }
    }
  }

  loading() {
    return SizedBox(
      height: Sizes.h15,
      width: Sizes.w15,
      child: CircularProgressIndicator(
        // value: 10,
        valueColor: new AlwaysStoppedAnimation<Color>(AppColors.purple),
        strokeWidth: 5.0,
      ),
    );
  }

  snackbar(String text, int duration, Color background) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      duration: Duration(seconds: duration),
      backgroundColor: background,
    ));
  }
}
