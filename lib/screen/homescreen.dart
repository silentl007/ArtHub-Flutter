import 'package:ArtHub/screen/freelanceartist/freelanceartistlist.dart';
import 'package:flutter/material.dart';
import 'gallery/gallery.dart';
import 'package:ArtHub/common/model.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
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
                      color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20),
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
                      color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20),
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
