import 'package:ArtHub/common/model.dart';
import 'package:ArtHub/common/sqliteoperations.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ArtHub/screen/purchasescreen.dart';

class ProductDetails extends StatefulWidget {
  final ParsedDataProduct data;
  ProductDetails(this.data);

  @override
  _ProductDetailsState createState() => _ProductDetailsState(data);
}

class _ProductDetailsState extends State<ProductDetails> {
  final ParsedDataProduct data;
  DataBaseFunctions _dataBaseFunctions;
  List<String> itemcheck = [];
  int itemnumber = 0;
  _ProductDetailsState(this.data);
  @override
  initState() {
    super.initState();
    setState(() {
      _dataBaseFunctions = DataBaseFunctions.databaseinstance;
    });
    getdata();
  }

  int _current = 0;
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  getdata() async {
    List<ParsedDataProduct> databaseList = await _dataBaseFunctions.fetchdata();
    setState(() {
      itemnumber = databaseList.length;
    });
    if (databaseList.isNotEmpty) {
      databaseList.forEach((element) {
        itemcheck.add(element.productname);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fontSize20 = size.height * 0.025;
    double fontSize18 = size.height * 0.0225;
    double fontSize25 = size.height * 0.03125;
    // print(size.height);
    // print(size.width);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Details'),
          actions: [
            InkWell(
              onTap: () {
                purchasecreen(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 30),
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
                    padding: const EdgeInsets.only(top: 25.0),
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
                      items: data.images.map((images) {
                        return Material(
                          color: Colors.transparent,
                          elevation: 10,
                          borderRadius: BorderRadius.circular(10),
                          borderOnForeground: false,
                          child: Container(
                            height: size.height * 0.35,
                            width: size.width * .75,
                            margin: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image: AssetImage(images),
                                    fit: BoxFit.cover)),
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
                    color: AppColors.grey,
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
                                    padding: const EdgeInsets.only(left: 70.0),
                                    child: Container(
                                      color: Colors.transparent,
                                      child: Align(
                                          alignment: Alignment.bottomCenter,
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
                                  alignment: Alignment.bottomLeft,
                                  child: Container(
                                    height: 40,
                                    width: 90,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        color: AppColors.red),
                                    child: Center(
                                        child: Text(
                                      '₦ ${data.cost}',
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
                              padding:
                                  const EdgeInsets.only(left: 70.0, top: 10),
                              child: SingleChildScrollView(
                                child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.str,
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
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: size.width * .35,
                                height: size.height * .07,
                                child: RaisedButton(
                                    elevation: 8,
                                    onPressed: () => addcart(context, data),
                                    color: AppColors.purple,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.shopping_cart,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          'Add to Cart',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: fontSize18),
                                        ),
                                      ],
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50)))),
                              ),
                            ),
                          )
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

  void purchasecreen(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PurchaseScreen()));
  }

  addcart(BuildContext context, ParsedDataProduct cartitem) async {
    if (itemcheck.contains(cartitem.productname)) {
      return showDialog(
          context: context,
          child: AlertDialog(
            content: Text('Already in cart'),
          ));
    } else {
      await _dataBaseFunctions.insertitem(cartitem);
      getdata();
      return showDialog(
          context: context,
          child: AlertDialog(
            content: Text('Added to cart'),
          ));
    }
  }
}
