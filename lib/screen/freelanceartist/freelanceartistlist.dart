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

  // Pseudo Future logic using initState
  // real life application use a future builder because of data fetching
  @override
  void initState() {
    Data artistname = Data();
    List artlist = artistname.artists;
    for (var data in artlist) {
      ParsedDataFreeLanceArts parsed = ParsedDataFreeLanceArts(
          name: data['name'],
          youtube: data['youtube'],
          avatar: data['avatar'],
          works: data['works'],
          aboutme: data['aboutme']);
      artnamelist.add(parsed);
    }
    filteredartname = artnamelist;
    getprefs();
  }

  getprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('inapp', true);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double padding8 = size.height * 0.01001;
    double padding20 = size.height * 0.025;
    double padding15 = size.height * 0.01875;
    double padding10 = size.height * 0.01252;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: classWidget.apptitleBar(context, 'Freelancers'),
        body: Container(
          padding: EdgeInsets.fromLTRB(padding20, padding15, padding10, 0),
          child: Column(
            children: <Widget>[
              searchbar(),
              Expanded(
                child: GridView.builder(
                  itemCount: filteredartname.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      childAspectRatio: .8),
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.only(top: padding8),
                      child: InkWell(
                        onTap: () => profile(filteredartname[index]),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(70)),
                              image: DecorationImage(
                                  image:
                                      AssetImage(filteredartname[index].avatar),
                                  fit: BoxFit.cover)),
                          child: Container(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: ListTile(
                                tileColor: AppColors.purple,
                                title: Text(
                                  '${filteredartname[index].name}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  searchbar() {
    return Material(
      elevation: 10.0,
      borderRadius: BorderRadius.circular(30.0),
      shadowColor: Color(0x55434343),
      child: TextField(
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: "Search for Artists",
          prefixIcon: Icon(
            Icons.search,
            color: Colors.black54,
          ),
          border: InputBorder.none,
        ),
        onChanged: (text) {
          text = text.toLowerCase();
          setState(() {
            filteredartname = artnamelist
                .where((items) => (items.name.toLowerCase().contains(text)))
                .toList();
          });
        },
      ),
    );
  }

  void profile(ParsedDataFreeLanceArts profiledata) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => FreeLanceProfile(profiledata)));
  }
}
