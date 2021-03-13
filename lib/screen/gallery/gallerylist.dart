import 'package:ArtHub/screen/gallery/galleryart.dart';
import 'package:flutter/material.dart';

class GalleryList extends StatefulWidget {
  final data;
  GalleryList({this.data});
  @override
  _GalleryListState createState() => _GalleryListState(data: data);
}

class _GalleryListState extends State<GalleryList> {
  final data;
  String link = '';
  _GalleryListState({this.data});
  List filtereddata = List();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    filtereddata = data;
    print('initState GL');
    print('init filtereddata $filtereddata');
  }

 

  @override
  Widget build(BuildContext context) {
    print('Build GL');
    print('Build filtereddata $filtereddata');
    Size size = MediaQuery.of(context).size;
    double fontSize = size.height * 0.03875;
    double sizedBox9 = size.height * 0.01127;
    double sizedBox10 = size.height * 0.01252;
    double imageHeight20 = size.height * 0.025;
    double containerHeight = size.height * .20;
    double padding20 = size.height * 0.025;
    double padding50 = size.height * 0.06257;
    double padding25 = size.height * 0.031289;
    return Container(
      child: Column(
        children: [
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
                      onTap: () => galleryart(filtereddata[index].works),
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
                                left: padding50,
                                top: padding25 / 2,
                                bottom: padding25 / 2),
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
            print('setState search bar');
            print('setState search bar filtereddata $filtereddata');
            text = text.toLowerCase();
            setState(() {
              filtereddata = data
                  .where((items) => (items.name.toLowerCase().contains(text) ||
                      items.location.toLowerCase().contains(text)))
                  .toList();
            });
          },
        ),
      ),
    );
  }

  void galleryart(List works) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => GalleryArt(works)));
  }
}
