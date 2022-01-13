import 'package:artHub/screen/productdetails.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:artHub/common/model.dart';

class Middle extends StatefulWidget {
  final ParsedDataProduct data;
  Middle(this.data);
  @override
  _MiddleState createState() => _MiddleState();
}

class _MiddleState extends State<Middle> {
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
              builder: (context) => ProductDetails(widget.data, user)));
    });
  }
}
