import 'package:art_hub/screen/gallery/portrait.dart';
import 'package:flutter/material.dart';
import 'package:art_hub/common/model.dart';
import 'package:flutter_animator/flutter_animator.dart';

class GalleryArt extends StatefulWidget {
  final worksdata;
  GalleryArt(this.worksdata);
  @override
  _GalleryArtState createState() => _GalleryArtState();
}

class _GalleryArtState extends State<GalleryArt> {
  List<ParsedDataProduct> portraitworks = [];
  List<ParsedDataProduct> sculpworks = [];
  Widgets classWidget = Widgets();

  @override
  initState() {
    super.initState();
    _separatorWorks();
  }

  _separatorWorks() {
    List items = widget.worksdata;
    for (var data in items) {
      if (data['type'] == 'Painting' || data['type'] == 'painting') {
        String wString = data['weight'].toString();
        double weight = double.tryParse(wString)!;
        ParsedDataProduct parsed = ParsedDataProduct(
            artistname: data['name'],
            productname: data['product'],
            accountType: data['accountType'],
            productID: data['productID'],
            artistemail: data['email'],
            cost: data['cost'],
            type: data['type'],
            avatar: data['avatar'],
            desc: data['desc'],
            description: data['description'],
            avail: data['available'],
            weight: weight,
            dimension: data['dimension'],
            materials: data['materials'],
            images: data['images']);
        portraitworks.add(parsed);
      } else if (data['type'] == 'Sculptor' || data['type'] == 'sculptor') {
        String wString = data['weight'].toString();
        double weight = double.tryParse(wString)!;
        ParsedDataProduct parsed = ParsedDataProduct(
            artistname: data['name'],
            productname: data['product'],
            productID: data['productID'],
            artistemail: data['email'],
            accountType: data['accountType'],
            cost: data['cost'],
            type: data['type'],
            avatar: data['avatar'],
            desc: data['desc'],
            description: data['description'],
            avail: data['available'],
            weight: weight,
            dimension: data['dimension'],
            materials: data['materials'],
            images: data['images']);
        sculpworks.add(parsed);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    portraitworks.shuffle();
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: SafeArea(
        child: MediaQuery(
          data:
              MediaQuery.of(context).copyWith(textScaleFactor: Texts.textScale),
          child: Scaffold(
            backgroundColor: Colors.white,
            floatingActionButton: classWidget.floatingHome(context),
            appBar: AppBar(
              toolbarHeight: Sizes.h30,
                title: Padding(
                  padding: EdgeInsets.only(right: Sizes.w30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SlideInLeft(
                        preferences:
                            AnimationPreferences(offset: Duration(seconds: 1)),
                        child: Text(
                          'Art',
                          style: TextStyle(
                            color: AppColors.purple,
                            fontWeight: FontWeight.bold,
                          ),
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
                          fontSize: Sizes.w20,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Sculptors',
                      style: TextStyle(
                          color: AppColors.purple,
                          fontSize: Sizes.w20,
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
      ),
    );
  }
}
