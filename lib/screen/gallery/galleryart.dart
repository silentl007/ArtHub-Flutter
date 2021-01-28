import 'package:ArtHub/screen/gallery/portrait.dart';
import 'package:flutter/material.dart';
import 'package:ArtHub/common/model.dart';

class GalleryArt extends StatefulWidget {
  final String sorter;
  GalleryArt(this.sorter);
  @override
  _GalleryArtState createState() => _GalleryArtState();
}

class _GalleryArtState extends State<GalleryArt> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fontSize20 = size.height * 0.025;
    Data datacollect = Data();
    List<ParsedDataProduct> portraitworks = [];
    List<ParsedDataProduct> sculpworks = [];
    List items = datacollect.items;
    for (var data in items) {
      data['works'].forEach((element) {
        if (element['type'] == 'painting') {
          ParsedDataProduct parsed = ParsedDataProduct(
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
          portraitworks.add(parsed);
        } else if (element['type'] == 'sculptor') {
          ParsedDataProduct parsed = ParsedDataProduct(
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
          sculpworks.add(parsed);
        }
      });
    }
    portraitworks.shuffle();
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              title: Padding(
                padding: const EdgeInsets.only(right: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Art',
                      style: TextStyle(
                        color: AppColors.purple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              bottom: TabBar(indicatorColor: AppColors.purple, tabs: <Widget>[
                Tab(
                  child: Text(
                    'Portraits',
                    style: TextStyle(
                        color: AppColors.purple,
                        fontSize: fontSize20,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                Tab(
                  child: Text(
                    'Sculptors',
                    style: TextStyle(
                        color: AppColors.purple,
                        fontSize: fontSize20,
                        fontWeight: FontWeight.w700),
                  ),
                )
              ])),
          body: TabBarView(
            children: [
              PortraitDisplay(works: portraitworks),
              PortraitDisplay(works: sculpworks)
            ],
          ),
        ),
      ),
    );
  }
}
