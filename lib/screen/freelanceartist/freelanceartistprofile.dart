import 'package:art_hub/common/model.dart';
import 'package:art_hub/common/middlemen/middlemanproductdetails.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animator/flutter_animator.dart';

class FreeLanceProfile extends StatefulWidget {
  final ParsedDataFreeLanceArts artistdata;
  FreeLanceProfile(this.artistdata);

  @override
  _FreeLanceProfileState createState() => _FreeLanceProfileState();
}

class _FreeLanceProfileState extends State<FreeLanceProfile> {
  final Widgets classWidget = Widgets();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fontSize40 = size.height * 0.05;
    double padding22 = size.height * 0.0275;
    double padding18 = size.height * 0.02253;
    double padding8 = size.height * 0.01001;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: classWidget.apptitleBar(context, '${widget.artistdata.name}'),
        floatingActionButton: classWidget.floatingHome(context),
        body: Padding(
          padding: EdgeInsets.all(padding22),
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: double.infinity,
                          child: BounceInLeft(
                            preferences: AnimationPreferences(
                                offset: Duration(seconds: 1)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(100)),
                              child: CachedNetworkImage(
                                fit: BoxFit.fitHeight,
                                imageUrl: widget.artistdata.avatar!,
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
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: BounceInDown(
                            preferences: AnimationPreferences(
                                offset: Duration(seconds: 1)),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                child: Padding(
                                  padding: EdgeInsets.only(left: padding18),
                                  child: Text(
                                    '${widget.artistdata.name}',
                                    style: TextStyle(
                                        fontSize: fontSize40,
                                        color: AppColors.purple,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.justify,
                                  ),
                                ),
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.only(top: padding8),
                  child: widget.artistdata.works!.length == 0
                      ? Center(
                          child: Text('Sorry, no item available!'),
                        )
                      : GridView.builder(
                          itemCount: widget.artistdata.works!.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20),
                          itemBuilder: (BuildContext context, int index) {
                            return BounceInUp(
                              preferences: AnimationPreferences(
                                  offset: Duration(seconds: 2)),
                              child: Pulse(
                                preferences: AnimationPreferences(
                                  autoPlay: AnimationPlayStates.Loop,
                                ),
                                child: InkWell(
                                  onTap: () => details(
                                      context, widget.artistdata.works![index]),
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: widget.artistdata.works![index]
                                          ['avatar'],
                                      placeholder: (context, url) => new Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            CircularProgressIndicator(
                                              valueColor:
                                                  new AlwaysStoppedAnimation<
                                                      Color>(AppColors.purple),
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
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void details(BuildContext context, Map element) {
    String wString = element['weight'].toString();
    double weight = double.tryParse(wString)!;
    ParsedDataProduct details = ParsedDataProduct(
        artistname: element['name'],
        productname: element['product'],
        productID: element['productID'],
        accountType: element['accountType'],
        artistemail: element['email'],
        cost: element['cost'],
        type: element['type'],
        avatar: element['avatar'],
        desc: element['desc'],
        description: element['description'],
        avail: element['available'],
        weight: weight,
        dimension: element['dimension'],
        materials: element['materials'],
        images: element['images']);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Middle(details)));
  }
}
