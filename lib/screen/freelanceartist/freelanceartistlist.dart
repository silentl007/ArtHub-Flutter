import 'package:ArtHub/screen/freelanceartist/freelanceartistprofile.dart';
import 'package:flutter/material.dart';
import 'package:ArtHub/common/model.dart';

class FreeLanceArtist extends StatefulWidget {
  @override
  _FreeLanceArtistState createState() => _FreeLanceArtistState();
}

class _FreeLanceArtistState extends State<FreeLanceArtist> {
  @override
  Widget build(BuildContext context) {
    Data artistname = Data();
    List artname = [];
    List artlist = artistname.artists;
    for (var data in artlist) {
      ParsedDataFreeLanceArts parsed = ParsedDataFreeLanceArts(
          name: data['name'],
          youtube: data['youtube'],
          avatar: data['avatar'],
          works: data['works'],
          aboutme: data['aboutme']);
      artname.add(parsed);
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Freelance',
                  style: TextStyle(
                    color: AppColors.purple,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        body: Container(
          padding: EdgeInsets.fromLTRB(20, 15, 10, 0),
          child: Column(
            children: <Widget>[
              searchbar(),
              Expanded(
                child: GridView.builder(
                  itemCount: artname.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      childAspectRatio: .8),
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: InkWell(
                        onTap: () => profile(context, artname[index]),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(70)),
                              image: DecorationImage(
                                  image: AssetImage(artname[index].avatar),
                                  fit: BoxFit.cover)),
                          child: Container(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: ListTile(
                                tileColor: AppColors.purple,
                                title: Text(
                                  '${artname[index].name}',
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
      ),
    );
  }

  void profile(BuildContext context, ParsedDataFreeLanceArts profiledata) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => FreeLanceProfile(profiledata)));
  }
}
