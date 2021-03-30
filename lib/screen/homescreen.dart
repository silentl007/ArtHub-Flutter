import 'package:ArtHub/common/middlemen/middlemancart.dart';
import 'package:ArtHub/common/middlemen/middlemanuserartworks.dart';
import 'package:ArtHub/common/middlemen/middleorders.dart';
import 'package:ArtHub/screen/aboutus.dart';
import 'package:ArtHub/screen/freelanceartist/freelanceartistlist.dart';
import 'package:ArtHub/screen/login.dart';
import 'package:ArtHub/screen/uploads.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:ArtHub/screen/user/userprofile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'gallery/gallery.dart';
import 'package:ArtHub/common/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final Widgets classWidget = Widgets();
  int offsetDuration = 2;
  String displayName = '';
  String accountType = '';
  final List<DrawerOptions> options = [
    DrawerOptions(option: 'Profile', optionIcon: Icon(Icons.person)),
    DrawerOptions(option: 'Orders', optionIcon: Icon(Icons.menu)),
    DrawerOptions(option: 'Cart', optionIcon: Icon(Icons.shopping_cart)),
    DrawerOptions(option: 'Support', optionIcon: Icon(Icons.contact_support)),
  ];

  final List<DrawerOptions> options2 = [
    DrawerOptions(option: 'Profile', optionIcon: Icon(Icons.person)),
    DrawerOptions(option: 'Orders', optionIcon: Icon(Icons.menu)),
    DrawerOptions(option: 'Cart', optionIcon: Icon(Icons.shopping_cart)),
    DrawerOptions(option: 'Artworks', optionIcon: Icon(Icons.upload_file)),
    DrawerOptions(option: 'Upload', optionIcon: Icon(Icons.file_upload)),
    DrawerOptions(option: 'Support', optionIcon: Icon(Icons.contact_support)),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  getPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      displayName = prefs.getString('displayName');
      accountType = prefs.getString('accountType');
    });
    if (prefs.getBool('inapp') == true) {
      offsetDuration = 0;
    } else {
      _welcome();
    }
  }

  _welcome() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: AppColors.purple,
        content: Text('Welcome, $displayName')));
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double fontSize = size.height * 0.025;
    return SafeArea(
      child: Scaffold(
          key: _scaffoldKey,
          bottomNavigationBar: JackInTheBox(
            preferences:
                AnimationPreferences(offset: Duration(seconds: offsetDuration)),
            child: BottomNavigationBar(
              backgroundColor: AppColors.purple,
              showUnselectedLabels: true,
              onTap: (index) {
                if (accountType == 'Customer') {
                  _bottomNavCustomer(index);
                } else
                  _bottomNavOthers(index);
              },
              items: accountType == 'Customer'
                  ? options
                      .map((element) => BottomNavigationBarItem(
                          backgroundColor: AppColors.purple,
                          icon: element.optionIcon,
                          label: element.option))
                      .toList()
                  : options2
                      .map((element) => BottomNavigationBarItem(
                          backgroundColor: AppColors.purple,
                          icon: element.optionIcon,
                          label: element.option))
                      .toList(),
            ),
          ),
          appBar: _apptitleBar('Home'),
          body: WillPopScope(
            onWillPop: () => _backFunction(),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/appimages/welcomeback.png'),
                      fit: BoxFit.cover)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Pulse(
                    preferences: AnimationPreferences(
                        autoPlay: AnimationPlayStates.Loop),
                    child: BounceInLeft(
                      preferences: AnimationPreferences(
                          offset: Duration(seconds: offsetDuration)),
                      child: Container(
                        width: size.width * .7,
                        height: size.height * .08,
                        child: RaisedButton(
                          color: AppColors.purple,
                          onPressed: () => galleries(),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          child: Text(
                            'Galleries',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: fontSize),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Pulse(
                    preferences: AnimationPreferences(
                        autoPlay: AnimationPlayStates.Loop),
                    child: BounceInRight(
                      preferences: AnimationPreferences(
                          offset: Duration(seconds: offsetDuration)),
                      child: Container(
                        width: size.width * .7,
                        height: size.height * .08,
                        child: RaisedButton(
                          color: AppColors.red,
                          onPressed: () => freelancers(),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          child: Text(
                            'Freelance',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: fontSize),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  void galleries() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Galleries()));
  }

  void freelancers() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => FreeLanceArtist()));
  }

  Future<bool> _backFunction() {
    return showDialog(
        context: context,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          title: Text('Are you sure?'),
          content: Text('You are going to exit the application!'),
          actions: [
            RaisedButton(
              color: AppColors.purple,
              onPressed: () => SystemNavigator.pop(),
              child: Text('Yes'),
            ),
            RaisedButton(
              color: AppColors.purple,
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('No'),
            )
          ],
        ));
  }

  Widget _apptitleBar(String text) {
    final Size size = MediaQuery.of(context).size;
    final double fontSize = size.height * 0.025;
    double padding30 = size.height * 0.03755;
    return AppBar(
      actions: [
        Padding(
          padding: EdgeInsets.only(right: padding30),
          child: SlideInLeft(
            preferences:
                AnimationPreferences(offset: Duration(seconds: offsetDuration)),
            child: Row(
              children: [
                IconButton(
                  padding: const EdgeInsets.only(right: 0),
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () => _logout(),
                ),
                InkWell(
                  onTap: () => _logout(),
                  child: Text(
                    'Log out',
                    style: TextStyle(
                        color: AppColors.purple,
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
      title: Padding(
        padding: EdgeInsets.only(right: padding30),
        child: SlideInRight(
          preferences:
              AnimationPreferences(offset: Duration(seconds: offsetDuration)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                text,
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
    );
  }

  _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return showDialog(
        context: context,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          title: Text(
            'Log Out',
            textAlign: TextAlign.center,
          ),
          scrollable: true,
          content: Text('Are you sure you want to log out?'),
          actions: [
            RaisedButton(
              color: AppColors.purple,
              onPressed: () async {
                var variable = await prefs.clear();
                if (variable == true) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      (Route<dynamic> route) => false);
                }
              },
              child: Text('Yes'),
            ),
            RaisedButton(
              color: AppColors.purple,
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('No'),
            )
          ],
        ));
  }

  _bottomNavCustomer(int index) {
    if (index == 0) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Profile()));
    } else if (index == 1) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MiddleOrders()));
    } else if (index == 2) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MiddleCart()));
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AboutUs()));
    }
  }

  _bottomNavOthers(int index) {
    if (index == 0) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Profile()));
    } else if (index == 1) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MiddleOrders()));
    } else if (index == 2) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MiddleCart(homecheck: 'home',)));
    } else if (index == 3) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => MiddleUserArtWorks()));
    } else if (index == 4) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Uploads()));
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AboutUs()));
    }
  }
}
