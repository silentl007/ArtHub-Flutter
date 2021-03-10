import 'dart:convert';
import 'package:ArtHub/screen/gallery/gallerylist.dart';
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
  Future _future;
  String failed = 'failed';
  @override
  void initState() {
    super.initState();
    getprefs();
    _future = _getGallery();
    print('initState is called');
  }

  getprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('inapp', true);
    print('get prefs is called');
  }

  Future<List> _getGallery() async {
    print('_getGallery() is called');
    print('initial collecteddata $collecteddata');
    try {
      var data =
          await http.get('https://arthubserver.herokuapp.com/apiR/gallery');
      var jsonData = jsonDecode(data.body);
      if (jsonData != null) {
        for (var data in jsonData) {
          print(data['works']);
          ParsedDataGallery parsed = ParsedDataGallery(data['name'],
              data['address'], data['location'], data['number'], data['works']);
          collecteddata.add(parsed);
        }
      } else {
        return collecteddata;
      }
      print('returned collecteddata $collecteddata');
      return collecteddata;
    } catch (error) {
      List collecteddata = ['failed'];
      return collecteddata;
    }
  }

  @override
  Widget build(BuildContext context) {
    collecteddata.shuffle();
    print('Build is called');
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: classWidget.apptitleBar(context, 'Galleries'),
        body: FutureBuilder(
            future: _future,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData == false) {
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
              } else if (snapshot.data[0] == 'failed') {
                return Center(
                  child: Text('Internet Connection'),
                );
              } else {
                return GalleryList(
                  data: snapshot.data,
                );
              }
            }),
      ),
    );
  }
}
