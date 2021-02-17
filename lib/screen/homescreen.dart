import 'package:ArtHub/screen/freelanceartist/freelanceartistlist.dart';
import 'package:ArtHub/screen/purchasescreen.dart';
import 'package:ArtHub/screen/uploads.dart';
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
  String displayName = '';
  String customerType = '';
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
    DrawerOptions(option: 'Artworks', optionIcon: Icon(Icons.file_upload)),
    DrawerOptions(option: 'Upload', optionIcon: Icon(Icons.upload_file)),
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
      customerType = prefs.getString('customerType');
    });
    print(customerType);
    _welcome();
  }

  _welcome() {
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text('Welcome back, $displayName')));
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double fontSize = size.height * 0.025;
    return SafeArea(
      child: Scaffold(
          key: _scaffoldKey,
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: AppColors.purple,
            showUnselectedLabels: true,
            onTap: (index) {
              if (customerType == 'Customer') {
                _bottomNavCustomer(index);
              } else
                _bottomNavOthers(index);
            },
            items: customerType == 'Customer'
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
                  Container(
                    width: size.width * .7,
                    height: size.height * .08,
                    child: RaisedButton(
                      color: AppColors.purple,
                      onPressed: () => galleries(),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: Text(
                        'Galleries',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: fontSize),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: size.width * .7,
                    height: size.height * .08,
                    child: RaisedButton(
                      color: AppColors.red,
                      onPressed: () => freelancers(),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: Text(
                        'Freelance',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: fontSize),
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
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Galleries()));
  }

  void freelancers() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => FreeLanceArtist()));
  }

  Future<bool> _backFunction() {
    return showDialog(
        context: context,
        child: AlertDialog(
          title: Text('Are you sure?'),
          content: Text('You are going to exit the application!'),
          actions: [
            RaisedButton(
              onPressed: () => SystemNavigator.pop(),
              child: Text('Yes'),
            ),
            RaisedButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('No'),
            )
          ],
        ));
  }

  Widget _apptitleBar(String text) {
    final Size size = MediaQuery.of(context).size;

    double padding30 = size.height * 0.03755;
    return AppBar(
      actions: [
        Padding(
          padding: EdgeInsets.only(right: padding30),
          child: Row(
            children: [
              IconButton(
                padding: const EdgeInsets.only(right: 0),
                icon: Icon(Icons.exit_to_app),
                onPressed: () => _logout(),
              ),
              Text(
                'Log out',
                style: TextStyle(
                    color: AppColors.purple,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        )
      ],
      title: Padding(
        padding:  EdgeInsets.only(right: padding30),
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
    );
  }

  _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return showDialog(
        context: context,
        child: AlertDialog(
          title: Text(
            'Log Out',
            textAlign: TextAlign.center,
          ),
          scrollable: true,
          content: Text('Are you sure you want to log out?'),
          actions: [
            RaisedButton(
              onPressed: () async {
                var variable = await prefs.clear();
                if (variable == true) {
                  SystemNavigator.pop();
                }
              },
              child: Text('Yes'),
            ),
            RaisedButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('No'),
            )
          ],
        ));
  }

  _bottomNavCustomer(int index) {
    if (index == 2) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PurchaseScreen()));
    } else
      _comingSoon();
  }

  _bottomNavOthers(int index) {
    if (index == 4) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Uploads()));
    } else if (index == 2) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PurchaseScreen()));
    } else
      _comingSoon();
  }

  _comingSoon() {
    return showDialog(
        context: context,
        child: AlertDialog(
            title: Text(
              'Under Construction',
              textAlign: TextAlign.center,
            ),
            scrollable: true,
            content: Text('Coming soon!'),
            actions: [
              FlatButton(
                onPressed: null,
                child: Text('Ok'),
              ),
            ]));
  }
}
