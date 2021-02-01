import 'package:ArtHub/screen/freelanceartist/freelanceartistlist.dart';
import 'package:flutter/material.dart';
import 'gallery/gallery.dart';
import 'package:ArtHub/common/model.dart';
import 'package:ArtHub/common/drawer.dart';

class HomeScreen extends StatelessWidget {
  final Widgets classWidget = Widgets();
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double fontSize = size.height * 0.025;
    return SafeArea(
      child: Scaffold(
          appBar: classWidget.apptitleBar('Home'),
          drawer: DrawerWidget(),
          body: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/appimages/welcomeback.png'),
                    fit: BoxFit.cover)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: size.width * .7,
                  height: size.height * .08,
                  child: RaisedButton(
                    color: AppColors.purple,
                    onPressed: () => galleries(context),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    child: Text(
                      'Galleries',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: fontSize),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: size.width * .7,
                  height: size.height * .08,
                  child: RaisedButton(
                    color: AppColors.red,
                    onPressed: () => freelancers(context),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    child: Text(
                      'Freelance',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: fontSize),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  void galleries(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Galleries()));
  }

  void freelancers(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => FreeLanceArtist()));
  }
}
