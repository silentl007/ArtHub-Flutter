import 'package:ArtHub/screen/gallery/portrait.dart';
import 'package:flutter/material.dart';
import 'package:ArtHub/common/model.dart';

class GalleryArt extends StatefulWidget {
  final worksdata;
  GalleryArt(this.worksdata);
  @override
  _GalleryArtState createState() => _GalleryArtState();
}

class _GalleryArtState extends State<GalleryArt> {
  List<ParsedDataProduct> portraitworks = [];
  List<ParsedDataProduct> sculpworks = [];

  @override
  initState() {
    super.initState();
    _separatorWorks();
  }

  _separatorWorks() {
    print(widget.worksdata);
    List items = widget.worksdata;
    for (var data in items) {
      if (data['type'] == 'Painting' || data['type'] == 'painting') {
        ParsedDataProduct parsed = ParsedDataProduct(
            artistname: data['name'],
            productname: data['product'],
            productID: data['productID'],
            cost: data['cost'],
            type: data['type'],
            avatar: data['avatar'],
            desc: data['desc'],
            description: data['description'],
            avail: data['available'],
            weight: data['weight'],
            dimension: data['dimension'],
            materials: data['materials'],
            images: data['images']);
        portraitworks.add(parsed);
      } else if (data['type'] == 'Sculptor' || data['type'] == 'sculptor') {
        ParsedDataProduct parsed = ParsedDataProduct(
            artistname: data['name'],
            productname: data['product'],
            productID: data['productID'],
            cost: data['cost'],
            type: data['type'],
            avatar: data['avatar'],
            desc: data['desc'],
            description: data['description'],
            avail: data['available'],
            weight: data['weight'],
            dimension: data['dimension'],
            materials: data['materials'],
            images: data['images']);
        sculpworks.add(parsed);
      }
      ;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fontSize20 = size.height * 0.025;
    double padding30 = size.height * 0.03755;

    portraitworks.shuffle();
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              title: Padding(
                padding: EdgeInsets.only(right: padding30),
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
