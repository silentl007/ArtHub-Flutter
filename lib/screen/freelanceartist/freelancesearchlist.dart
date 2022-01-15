import 'package:art_hub/common/model.dart';
import 'package:art_hub/screen/freelanceartist/freelanceartistprofile.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animator/flutter_animator.dart';

class FreelanceSearch extends StatefulWidget {
  final List? data;
  FreelanceSearch({this.data});
  @override
  _FreelanceSearchState createState() => _FreelanceSearchState(data!);
}

class _FreelanceSearchState extends State<FreelanceSearch> {
  final List data;
  _FreelanceSearchState(this.data);
  List filter = [];
  @override
  void initState() {
    super.initState();
    filter = data;
  }

  @override
  Widget build(BuildContext context) {
    Sizes().heightSizeCalc(context);
    Sizes().widthSizeCalc(context);
    filter.shuffle();
    return Container(
      padding: EdgeInsets.fromLTRB(Sizes.w20, Sizes.h15, Sizes.w10, 0),
      child: Column(
        children: [
          searchbar(),
          Expanded(
            child: GridView.builder(
              itemCount: filter.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: .8),
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                    padding: EdgeInsets.only(top: Sizes.h8),
                    child: InkWell(
                      onTap: () => profile(filter[index]),
                      child: Stack(
                        fit: StackFit.passthrough,
                        children: [
                          Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(Sizes.w70)),
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: filter[index].avatar,
                                placeholder: (context, url) => Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      CircularProgressIndicator(
                                        valueColor:
                                            new AlwaysStoppedAnimation<Color>(
                                                AppColors.purple),
                                        strokeWidth: 5.0,
                                      ),
                                    ],
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    new Icon(Icons.error),
                              ),
                            ),
                          ),
                          Pulse(
                            preferences: AnimationPreferences(
                                autoPlay: AnimationPlayStates.Loop,
                                offset: Duration(seconds: 2)),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: Sizes.h30,
                                width: double.infinity,
                                color: AppColors.purple,
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  runAlignment: WrapAlignment.center,
                                  children: [
                                    Text(
                                      '${filter[index].name}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: Sizes.w15),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ));
              },
            ),
          )
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
            filter = data
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
