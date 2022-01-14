import 'package:art_hub/screen/homescreen.dart';
import 'package:art_hub/screen/user/artworkavailable.dart';
import 'package:art_hub/screen/user/artworksold.dart';
import 'package:flutter/material.dart';
import 'package:art_hub/common/model.dart';

class Artworks extends StatefulWidget {
  final List userDetails;
  Artworks(this.userDetails);
  @override
  _ArtworksState createState() => _ArtworksState();
}

class _ArtworksState extends State<Artworks> {
  Widgets classWidget = Widgets();
  @override
  Widget build(BuildContext context) {
    Sizes().heightSizeCalc(context);
    Sizes().widthSizeCalc(context);

    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: SafeArea(
          child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: Texts.textScale),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              title: Padding(
                padding: EdgeInsets.only(right: Sizes.w30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Artworks',
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
                    'Available',
                    style: TextStyle(
                        color: AppColors.purple,
                        fontSize: Sizes.w20,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                Tab(
                  child: Text(
                    'Sold',
                    style: TextStyle(
                        color: AppColors.purple,
                        fontSize: Sizes.w20,
                        fontWeight: FontWeight.w700),
                  ),
                )
              ])),
          body: WillPopScope(
            onWillPop: () async {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                  (Route<dynamic> route) => false);
              return true;
            },
            child: TabBarView(
              children: [
                Available(userDetails: widget.userDetails),
                Sold(widget.userDetails),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
