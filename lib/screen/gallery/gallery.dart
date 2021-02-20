import 'package:ArtHub/screen/gallery/galleryart.dart';
import 'package:flutter/material.dart';
import 'package:ArtHub/common/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Galleries extends StatefulWidget {
  @override
  _GalleriesState createState() => _GalleriesState();
}

class _GalleriesState extends State<Galleries> {
  Widgets classWidget = Widgets();
  List<ParsedDataGallery> collecteddata = List();
  List<ParsedDataGallery> filtereddata = List();

  // Pseudo Future logic using initState
  // real life application use a future builder because of data fetching
  @override
  void initState() {
    super.initState();
    Data modeldata = Data();
    List result = modeldata.galleries;
    for (var data in result) {
      ParsedDataGallery parsed = ParsedDataGallery(
          data['name'], data['address'], data['location'], data['contact']);
      collecteddata.add(parsed);
    }
    filtereddata = collecteddata;
    getprefs();
  }

  getprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('inapp', true);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fontSize = size.height * 0.03875;
    double sizedBox9 = size.height * 0.01126;
    double sizedBox10 = size.height * 0.01252;
    double imageHeight20 = size.height * 0.025;
    double containerHeight = size.height * .20;
    double padding20 = size.height * 0.025;
    double padding50 = size.height * 0.06257;
    double padding25 = size.height * 0.031289;
    collecteddata.shuffle();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: classWidget.apptitleBar(context, 'Galleries'),
        body: Column(
          children: <Widget>[
            searchbar(),
            Expanded(
              child: ListView.builder(
                  itemCount: filtereddata.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        left: padding20,
                        right: padding20,
                      ),
                      child: InkWell(
                        onTap: () => galleryart(),
                        child: Material(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          child: Container(
                            height: containerHeight,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/appimages/gallerylistback.png'),
                                    fit: BoxFit.fill)),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: padding50, top: padding25),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${filtereddata[index].name}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          fontSize: fontSize)),
                                  SizedBox(
                                    height: sizedBox9,
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/appimages/addressicon.png',
                                        height: imageHeight20,
                                      ),
                                      SizedBox(
                                        width: sizedBox10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('${filtereddata[index].address}',
                                              style: TextStyle(
                                                color: Colors.white,
                                              )),
                                          Text(
                                              '${filtereddata[index].location} State',
                                              style: TextStyle(
                                                color: Colors.white,
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: sizedBox9,
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/appimages/callicon.png',
                                        height: imageHeight20,
                                      ),
                                      SizedBox(
                                        width: sizedBox10,
                                      ),
                                      Text('0${filtereddata[index].contact}',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ))
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  searchbar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0, top: 20, left: 20, right: 20),
      child: Material(
        color: Colors.white,
        elevation: 10.0,
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Color(0x55434343),
        child: TextField(
          textAlign: TextAlign.start,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            hintText: "Search...",
            prefixIcon: Icon(
              Icons.search,
              color: Colors.black54,
            ),
            border: InputBorder.none,
          ),
          onChanged: (text) {
            text = text.toLowerCase();
            setState(() {
              filtereddata = collecteddata
                  .where((items) => (items.name.toLowerCase().contains(text) ||
                      items.location.toLowerCase().contains(text)))
                  .toList();
            });
          },
        ),
      ),
    );
  }

  void galleryart() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => GalleryArt()));
  }
}
