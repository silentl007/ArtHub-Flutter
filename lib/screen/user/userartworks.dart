import 'package:ArtHub/screen/user/artworkavailable.dart';
import 'package:ArtHub/screen/user/artworksold.dart';
import 'package:flutter/material.dart';
import 'package:ArtHub/common/model.dart';

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
    final Size size = MediaQuery.of(context).size;
    double fontSize20 = size.height * 0.025;
    double padding30 = size.height * 0.03755;
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: SafeArea(
          child: Scaffold(
        appBar: AppBar(
            title: Padding(
              padding: EdgeInsets.only(right: padding30),
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
                      fontSize: fontSize20,
                      fontWeight: FontWeight.w700),
                ),
              ),
              Tab(
                child: Text(
                  'Sold',
                  style: TextStyle(
                      color: AppColors.purple,
                      fontSize: fontSize20,
                      fontWeight: FontWeight.w700),
                ),
              )
            ])),
        body: TabBarView(
          children: [
            Available(userDetails: widget.userDetails),
            Sold(),
          ],
        ),
      )),
    );
  }
}
