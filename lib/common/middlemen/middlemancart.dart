import 'package:artHub/screen/purchasescreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:artHub/common/model.dart';

class MiddleCart extends StatefulWidget {
  final homecheck;
  MiddleCart({this.homecheck});
  @override
  _MiddleCartState createState() => _MiddleCartState();
}

class _MiddleCartState extends State<MiddleCart> {
  List user = [];

  getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user.insert(0, prefs.getString('id'));
    user.insert(1, prefs.getString('accountType'));
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: FutureBuilder(
        future: getPrefs(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return loading();
          } else if (snapshot.data.length == 2) {
            productscreen(snapshot.data);
            return Container();
          } else {
            return Container();
          }
        },
      )),
    );
  }

  loading() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(AppColors.purple),
        strokeWidth: 9.0,
      ),
    );
  }

  productscreen(List data) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
       Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => PurchaseScreen(
                    userDetails: data,
                    homecheck: widget.homecheck,
                  )));
    });
  }
}
