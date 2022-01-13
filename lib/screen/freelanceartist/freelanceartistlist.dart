import 'dart:convert';
import 'package:art_hub/screen/freelanceartist/freelancesearchlist.dart';
import 'package:art_hub/screen/homescreen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:art_hub/common/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FreeLanceArtist extends StatefulWidget {
  @override
  _FreeLanceArtistState createState() => _FreeLanceArtistState();
}

class _FreeLanceArtistState extends State<FreeLanceArtist> {
  Widgets classWidget = Widgets();
  List<ParsedDataFreeLanceArts> collecteddata = [];
  Future? freelancers;
  @override
  // ignore: must_call_super
  void initState() {
    getprefs();
    freelancers = _getFreelancers();
  }

  Future _getFreelancers() async {
    try {
      Uri link = Uri.parse('${Server.link}/apiR/freelance');
      var data = await http.get(link);
      var jsonData = jsonDecode(data.body);
      if (jsonData != null) {
        for (var data in jsonData) {
          ParsedDataFreeLanceArts parsed = ParsedDataFreeLanceArts(
              name: data['name'],
              avatar: data['avatar'],
              works: data['works'],
              aboutme: data['aboutme']);
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
        body: WillPopScope(
          onWillPop: () async {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
                (Route<dynamic> route) => false);
                return true;
          },
          child: FutureBuilder(
              future: freelancers,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              AppColors.purple),
                          strokeWidth: 9.0,
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasData) {
                  return FreelanceSearch(data: snapshot.data);
                } else {
                  return Center(
                    child: ElevatedButton(
                      style: Decorations().buttonDecor(context: context, noBorder: true),
                      child: Decorations().buttonText(buttonText: 'Retry', context: context,),
                      onPressed: () {
                        freelancers = _getFreelancers();
                        setState(() {});
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
