import 'package:ArtHub/common/model.dart';
import 'package:flutter/material.dart';
import 'package:ArtHub/screen/productdetails.dart';

class PortraitDisplay extends StatefulWidget {
  final List works;

  PortraitDisplay({this.works});
  @override
  _PortraitDisplayState createState() => _PortraitDisplayState(works: works);
}

class _PortraitDisplayState extends State<PortraitDisplay> {
  final List works;

  _PortraitDisplayState({this.works});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double innerheight = size.height * .20;
    double fontSize20 = size.height * 0.020;
    return Container(
        child: Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 30, right: 30, top: 10),
          child: searchbar(),
        ),
        Container(
          child: SingleChildScrollView(
            child: Column(
              children: works.map((data) {
                return Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40, top: 10),
                  child: Material(
                    elevation: 10,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    child: Container(
                      height: size.height * .20,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                  image: DecorationImage(
                                      image: AssetImage(data.avatar),
                                      fit: BoxFit.cover)),
                              height: innerheight,
                              width: size.height * .15,
                            ),
                            SingleChildScrollView(
                                                          child: Container(
                                color: Colors.transparent,
                                width: size.height * .22,
                                padding: EdgeInsets.only(left: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      '${data.productname}',
                                      style: TextStyle(
                                          color: AppColors.purple,
                                          fontWeight: FontWeight.bold,
                                          fontSize: fontSize20),
                                    ),
                                    Text(
                                      '₦ ${data.cost}',
                                      style: TextStyle(
                                          color: AppColors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: fontSize20),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: RaisedButton(
                                        color: AppColors.blue,
                                        onPressed: () => purchase(context, data),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50))),
                                        child: Text(
                                          'View',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: fontSize20),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        )
      ],
    ));
  }

  searchbar() {
    return Material(
      elevation: 10.0,
      borderRadius: BorderRadius.circular(30.0),
      shadowColor: Color(0x55434343),
      child: TextField(
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: "Search...",
          prefixIcon: Icon(
            Icons.search,
            color: Colors.black54,
          ),
          border: InputBorder.none,
        ),
        // onChanged: (text) {
        //   text = text.toLowerCase();
        //   setState(() {
        //     filtereddata = collecteddata.where((items)=>(
        //       items.name.toLowerCase().contains(text) || items.location.toLowerCase().contains(text)
        //     )).toList();
        //   });
        // },
      ),
    );
  }

  void purchase(BuildContext context, ParsedDataProduct itemdetails) {
    print(itemdetails.images);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ProductDetails(itemdetails)));
  }
}
