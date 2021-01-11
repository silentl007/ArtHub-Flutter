import 'package:ArtHub/screen/gallery/galleryart.dart';
import 'package:flutter/material.dart';
import 'package:ArtHub/common/model.dart';

class Galleries extends StatefulWidget {
  @override
  _GalleriesState createState() => _GalleriesState();
}

class _GalleriesState extends State<Galleries> {
  List<ParsedDataGallery> collecteddata = List();
  List<ParsedDataGallery> filtereddata = List();

  // Pseudo Future logic using initState
  @override
  void initState() {
    super.initState();
    Data modeldata = Data();
    List result = modeldata.galleries;
    for (var data in result) {
      ParsedDataGallery parsed = ParsedDataGallery(
          data['name'], data['code'], data['address'], data['location'], data['contact']);
      collecteddata.add(parsed);
    }
    filtereddata = collecteddata;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    collecteddata.shuffle();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Galleries',
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
        body: Column(
          children: <Widget>[
            searchbar(),
            Expanded(
              child: ListView.builder(
                  itemCount: filtereddata.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                      ),
                      child: InkWell(
                        onTap: () => galleryart(context, filtereddata[index].code),
                        child: Container(
                            height: size.height * .25,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/appimages/gallerylistback.png'),
                                    fit: BoxFit.cover)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 50.0, top: 40),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${filtereddata[index].name}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          fontSize: 31)),
                                  SizedBox(
                                    height: 9,
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/appimages/addressicon.png',
                                        height: 20,
                                      ),
                                      SizedBox(
                                        width: 10,
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
                                              '${filtereddata[index].location}',
                                              style: TextStyle(
                                                color: Colors.white,
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 9,
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/appimages/callicon.png',
                                        height: 20,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text('${filtereddata[index].contact}',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ))
                                    ],
                                  )
                                ],
                              ),
                            )),
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

  void galleryart(BuildContext context, String sorter) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => GalleryArt(sorter)));
  }
}
