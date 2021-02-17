import 'package:ArtHub/common/model.dart';
import 'package:flutter/material.dart';
import 'package:ArtHub/screen/productdetails.dart';

class FreeLanceProfile extends StatelessWidget {
  final Widgets classWidget = Widgets();
  final ParsedDataFreeLanceArts artistdata;
  FreeLanceProfile(this.artistdata);
  @override
  Widget build(BuildContext context) {
    ScrollController scrollController;
    Size size = MediaQuery.of(context).size;
    double fontSize40 = size.height * 0.05;
    double padding22 = size.height * 0.0275;
    double padding15 = size.height * 0.01875;
    double padding10 = size.height * 0.01252;
    double padding18 = size.height * 0.02253;
    double padding8 = size.height * 0.01001;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: classWidget.apptitleBar(context, '${artistdata.name}'),
        body: Padding(
          padding:  EdgeInsets.all(padding22),
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  child: Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(100)),
                                image: DecorationImage(
                                    image: AssetImage(artistdata.avatar),
                                    fit: BoxFit.cover)),
                          )),
                      Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              child: Padding(
                                padding:  EdgeInsets.only(left: padding18),
                                child: Text(
                                  '${artistdata.name}',
                                  style: TextStyle(
                                      fontSize: fontSize40,
                                      color: AppColors.purple,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding:  EdgeInsets.only(top: padding15, bottom: padding10),
                  child: Container(
                    child: SingleChildScrollView(
                      child: Text(
                        '${artistdata.aboutme}',
                        textAlign: TextAlign.justify,
                        textScaleFactor: 1,
                        style: TextStyle(color: AppColors.purple),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.only(top: padding8),
                  child: GridView.builder(
                    itemCount: artistdata.works.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () => details(context, artistdata.works[index]),
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                image: DecorationImage(
                                    image: AssetImage(
                                        artistdata.works[index]['avatar']),
                                    fit: BoxFit.cover))),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void details(BuildContext context, Map element) {
    ParsedDataProduct details = ParsedDataProduct(
        artistname: element['name'],
        productname: element['product'],
        cost: element['cost'],
        type: element['type'],
        avatar: element['avatar'],
        desc: element['desc'],
        description: element['description'],
        avail: element['available'],
        weight: element['weight'],
        dimension: element['dimension'],
        materials: element['material used'],
        images: element['images']);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ProductDetails(details)));
  }
}
