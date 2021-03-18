import 'package:ArtHub/common/model.dart';
import 'package:ArtHub/screen/freelanceartist/freelanceartistprofile.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FreelanceSearch extends StatefulWidget {
  final List data;
  FreelanceSearch(this.data);
  @override
  _FreelanceSearchState createState() => _FreelanceSearchState();
}

class _FreelanceSearchState extends State<FreelanceSearch> {
  List filteredartname = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    filteredartname = widget.data;
    filteredartname.forEach((item) {
      print(item.avatar);
      print(item.name);
    });
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
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.only(topLeft: Radius.circular(70)),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: filteredartname[index].avatar,
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
                                '${filteredartname[index].name}',
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
            filteredartname = widget.data
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
