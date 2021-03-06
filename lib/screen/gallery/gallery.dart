import 'dart:convert';
import 'package:ArtHub/screen/gallery/gallerylist.dart';
import 'package:ArtHub/screen/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:ArtHub/common/model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Galleries extends StatefulWidget {
  @override
  _GalleriesState createState() => _GalleriesState();
}

class _GalleriesState extends State<Galleries> {
  Widgets classWidget = Widgets();
  List<ParsedDataGallery> collecteddata = List();
  Future gallery;
  @override
  void initState() {
    super.initState();
    getprefs();
    gallery = _getGallery();
  }

  getprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('inapp', true);
  }

  Future _getGallery() async {
    try {
      var data = await http.get('${Server.link}/apiR/gallery');
      var jsonData = jsonDecode(data.body);
      if (jsonData != null) {
        for (var data in jsonData) {
          ParsedDataGallery parsed = ParsedDataGallery(data['name'],
              data['address'], data['location'], data['number'], data['works']);
          collecteddata.add(parsed);
        }
      } else {
        return collecteddata;
      }
      return collecteddata;
    } catch (error) {
      print('this is the error - $error');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    collecteddata.shuffle();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: classWidget.apptitleBar(context, 'Galleries'),
        body: WillPopScope(
          onWillPop: (){
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
              (Route<dynamic> route) => false);
          },
                  child: FutureBuilder(
              future: gallery,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CircularProgressIndicator(
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(AppColors.purple),
                          strokeWidth: 9.0,
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasData) {
                  return GalleryList(
                    data: snapshot.data,
                  );
                } else {
                  return Center(
                    child: RaisedButton(
                      child: Text('Retry'),
                      onPressed: () {
                        gallery = _getGallery();
                        setState(() {
                          
                        });
                      },
                    ),
                  );
                }
              }),
        ),
      ),
    );
  }
}
