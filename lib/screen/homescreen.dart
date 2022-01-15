import 'package:art_hub/common/middlemen/middlemancart.dart';
import 'package:art_hub/common/middlemen/middlemanuserartworks.dart';
import 'package:art_hub/common/middlemen/middleorders.dart';
import 'package:art_hub/screen/aboutus.dart';
import 'package:art_hub/screen/freelanceartist/freelanceartistlist.dart';
import 'package:art_hub/screen/login.dart';
import 'package:art_hub/screen/uploads.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:art_hub/screen/user/userprofile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'gallery/gallery.dart';
import 'package:art_hub/common/model.dart';
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
    super.initState();
    getPref();
  }

  getPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      displayName = prefs.getString('displayName')!;
      accountType = prefs.getString('accountType')!;
    });
    if (prefs.getBool('inapp') == true) {
      offsetDuration = 0;
    } else {
      _welcome();
    }
  }

  _welcome() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: AppColors.purple,
        content: Text('Welcome, $displayName')));
  }

  @override
  Widget build(BuildContext context) {
    Sizes().heightSizeCalc(context);
    Sizes().widthSizeCalc(context);
    return SafeArea(
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: Texts.textScale),
        // data: MediaQuery.of(context).copyWith(textScaleFactor: Texts.textScale),
        child: Scaffold(
            key: _scaffoldKey,
            bottomNavigationBar: BottomNavigationBar(
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
                          icon: element.optionIcon!,
                          label: element.option))
                      .toList()
                  : options2
                      .map((element) => BottomNavigationBarItem(
                          backgroundColor: AppColors.purple,
                          icon: element.optionIcon!,
                          label: element.option))
                      .toList(),
            ),
            appBar: _apptitleBar('Home'),
            // appBar: AppBar(
            //   toolbarTextStyle: TextStyle(),
            //   foregroundColor: Colors.red,
            //   backgroundColor: Colors.red,
            // ),
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
                      child: Container(
                        width: Sizes.w300,
                        height: Sizes.h65,
                        child: ElevatedButton(
                            onPressed: () => galleries(),
                            style: Decorations().buttonDecor(context: context),
                            child: Decorations().buttonText(
                                context: context,
                                buttonText: 'Galleries',
                                fontweight: FontWeight.w900,
                                fontsize: Sizes.w20)),
                      ),
                    ),
                    SizedBox(
                      height: Sizes.h15,
                    ),
                    Pulse(
                      preferences: AnimationPreferences(
                          autoPlay: AnimationPlayStates.Loop),
                      child: Container(
                        width: Sizes.w300,
                        height: Sizes.h65,
                        child: ElevatedButton(
                          onPressed: () => freelancers(),
                          style: Decorations().buttonDecor(
                              context: context, buttoncolor: AppColors.red),
                          child: Decorations().buttonText(
                              context: context,
                              buttonText: 'Freelancers',
                              fontweight: FontWeight.w900,
                              fontsize: Sizes.w20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
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

  _backFunction() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            title: Text('Are you sure?'),
            content: Text('You are going to exit the application!'),
            actions: [
              ElevatedButton(
                style: Decorations()
                    .buttonDecor(context: context, noBorder: false),
                onPressed: () => SystemNavigator.pop(),
                child: Decorations()
                    .buttonText(buttonText: 'Yes', context: context),
              ),
              ElevatedButton(
                style: Decorations()
                    .buttonDecor(context: context, noBorder: false),
                onPressed: () => Navigator.of(context).pop(false),
                child: Decorations()
                    .buttonText(buttonText: 'No', context: context),
              )
            ],
          );
        });
  }

  _apptitleBar(String text) {
    Sizes().heightSizeCalc(context);
    Sizes().widthSizeCalc(context);
    return AppBar(
       toolbarHeight: Sizes.h30,
      actions: [
        Padding(
          padding: EdgeInsets.only(right: Sizes.w30),
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
                        fontSize: Sizes.w20),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
      title: Padding(
        padding: EdgeInsets.only(right: Sizes.w30),
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
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            title: Text(
              'Log Out',
              textAlign: TextAlign.center,
            ),
            scrollable: true,
            content: Text('Are you sure you want to log out?'),
            actions: [
              ElevatedButton(
                style: Decorations()
                    .buttonDecor(context: context, noBorder: false),
                onPressed: () async {
                  var variable = await prefs.clear();
                  if (variable == true) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                        (Route<dynamic> route) => false);
                  }
                },
                child: Decorations()
                    .buttonText(buttonText: 'Yes', context: context),
              ),
              ElevatedButton(
                style: Decorations()
                    .buttonDecor(context: context, noBorder: false),
                onPressed: () => Navigator.of(context).pop(false),
                child: Decorations()
                    .buttonText(buttonText: 'No', context: context),
              )
            ],
          );
        });
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
          context,
          MaterialPageRoute(
              builder: (context) => MiddleCart(
                    homecheck: 'home',
                  )));
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
