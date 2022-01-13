import 'package:artHub/screen/gallery/galleryart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';

class GalleryList extends StatefulWidget {
  final data;
  GalleryList({this.data});
  @override
  _GalleryListState createState() => _GalleryListState(data: data);
}

class _GalleryListState extends State<GalleryList> {
  final data;
  _GalleryListState({this.data});
  List filtereddata = [];
  @override
  void initState() {
    super.initState();
    filtereddata = data;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fontSize30 = size.height * 0.03875;
    double fontSize13 = size.height * 0.01627;
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
                    child: index.isEven || index == 0
                        ? slide(
                            'left',
                            2,
                            InkWell(
                              onTap: () =>
                                  galleryart(filtereddata[index].works),
                              child: Material(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
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
                                    child: slide(
                                        'right',
                                        2,
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("${filtereddata[index].name}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white,
                                                    fontSize: fontSize30)),
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
                                                    Text(
                                                        '${filtereddata[index].address}',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize:
                                                                fontSize13)),
                                                    Text(
                                                        '${filtereddata[index].location} State',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize:
                                                                fontSize13)),
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
                                                Text(
                                                    '0${filtereddata[index].contact}',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: fontSize13))
                                              ],
                                            )
                                          ],
                                        )),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : slide(
                            'right',
                            2,
                            InkWell(
                              onTap: () =>
                                  galleryart(filtereddata[index].works),
                              child: Material(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
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
                                    child: slide(
                                        'left',
                                        2,
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("${filtereddata[index].name}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white,
                                                    fontSize: fontSize30)),
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
                                                    Text(
                                                        '${filtereddata[index].address}',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize:
                                                                fontSize13)),
                                                    Text(
                                                        '${filtereddata[index].location} State',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize:
                                                                fontSize13)),
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
                                                Text(
                                                    '0${filtereddata[index].contact}',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: fontSize13))
                                              ],
                                            )
                                          ],
                                        )),
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

  slide(String direction, int duration, Widget widget) {
    if (direction == 'left') {
      return SlideInLeft(
        preferences: AnimationPreferences(
          duration: Duration(seconds: duration),
        ),
        child: widget,
      );
    } else {
      return SlideInRight(
        preferences:
            AnimationPreferences(duration: Duration(seconds: duration)),
        child: widget,
      );
    }
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
