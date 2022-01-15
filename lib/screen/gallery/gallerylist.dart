import 'package:art_hub/common/model.dart';
import 'package:art_hub/screen/gallery/galleryart.dart';
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
    Sizes().heightSizeCalc(context);
    Sizes().widthSizeCalc(context);
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
                        left: Sizes.w20, right: Sizes.w20, bottom: Sizes.h10),
                    child: InkWell(
                      onTap: () => galleryart(filtereddata[index].works),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Sizes.w35),
                        child: Container(
                            height: Sizes.h160,
                            width: double.infinity,
                            // color: Colors.purple,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/appimages/gallerylistback.jpg'),
                                    fit: BoxFit.fill)),
                            child: Padding(
                                padding: EdgeInsets.only(
                                    left: Sizes.w50,
                                    top: Sizes.h30,
                                    bottom: Sizes.w12),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("${filtereddata[index].name}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                              fontSize: Sizes.w30)),
                                      SizedBox(
                                        height: Sizes.h8,
                                      ),
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/appimages/addressicon.png',
                                            height: Sizes.h20,
                                          ),
                                          SizedBox(
                                            width: Sizes.w10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  '${filtereddata[index].address}',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: Sizes.w13)),
                                              Text(
                                                  '${filtereddata[index].location} State',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: Sizes.w13)),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: Sizes.h8,
                                      ),
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/appimages/callicon.png',
                                            height: Sizes.h20,
                                          ),
                                          SizedBox(
                                            width: Sizes.h10,
                                          ),
                                          Text('0${filtereddata[index].contact}',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: Sizes.w13))
                                        ],
                                      )
                                    ]))),
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
      padding: EdgeInsets.only(
          bottom: 0, top: Sizes.h20, left: Sizes.w20, right: Sizes.w20),
      child: Material(
        color: Colors.white,
        elevation: 10.0,
        borderRadius: BorderRadius.circular(Sizes.w30),
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
