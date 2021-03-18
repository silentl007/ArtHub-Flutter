import 'dart:convert';
import 'package:ArtHub/screen/freelanceartist/freelancesearchlist.dart';
import 'package:http/http.dart' as http;
import 'package:ArtHub/screen/freelanceartist/freelanceartistprofile.dart';
import 'package:flutter/material.dart';
import 'package:ArtHub/common/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FreeLanceArtist extends StatefulWidget {
  @override
  _FreeLanceArtistState createState() => _FreeLanceArtistState();
}

class _FreeLanceArtistState extends State<FreeLanceArtist> {
  Widgets classWidget = Widgets();
  List artnamelist = [];
  List filteredartname = List();
  @override
  void initState() {
    getprefs();
  }

  _getFreelancers() async {
    try {
      var data = await http.get('${Server.link}/apiR/freelance');
      var jsonData = jsonDecode(data.body);
      if (jsonData != null) {
        for (var data in jsonData) {
          ParsedDataFreeLanceArts parsed = ParsedDataFreeLanceArts(
              name: data['name'],
              avatar: data['avatar'],
              works: data['works'],
              aboutme: data['aboutme']);
          artnamelist.add(parsed);
        }
      } else
        return artnamelist;
      return artnamelist;
    } catch (error) {
      print('this is the error - $error');
      return null;
    }
  }

  getprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('inapp', true);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: classWidget.apptitleBar(context, 'Freelancers'),
          body: FutureBuilder(
            future: _getFreelancers(),
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
                return FreelanceSearch(snapshot.data);
              } else {
                return Center(
                  child: RaisedButton(
                    child: Text('Retry'),
                    onPressed: () {
                      setState(() {});
                    },
                  ),
                );
              }
            },
          )),
    );
  }
}
