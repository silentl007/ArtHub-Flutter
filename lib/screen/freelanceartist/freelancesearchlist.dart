import 'package:ArtHub/common/model.dart';
import 'package:ArtHub/screen/freelanceartist/freelanceartistprofile.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FreelanceSearch extends StatefulWidget {
  final List data;
  FreelanceSearch({this.data});
  @override
  _FreelanceSearchState createState() => _FreelanceSearchState(data);
}

class _FreelanceSearchState extends State<FreelanceSearch> {
  final List data;
  _FreelanceSearchState(this.data);
  List filter = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    filter = data;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double padding8 = size.height * 0.01001;
    double padding20 = size.height * 0.025;
    double padding15 = size.height * 0.01875;
    double padding10 = size.height * 0.01252;
    return Container(
      padding: EdgeInsets.fromLTRB(padding20, padding15, padding10, 0),
      child: Column(
        children: [
          searchbar(),
          Expanded(
            child: GridView.builder(
              itemCount: filter.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: .8),
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.only(top: padding8),
                  child: InkWell(
                    onTap: () => profile(filter[index]),
                    child: Container(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.only(topLeft: Radius.circular(70)),
                            child: CachedNetworkImage(
                              fit: BoxFit.fitWidth,
                              imageUrl: filter[index].avatar,
                              placeholder: (context, url) => new Center(
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
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: ListTile(
                              tileColor: AppColors.purple,
                              title: Text(
                                '${filter[index].name}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
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
