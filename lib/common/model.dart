import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// ------------ Misc classes ----------------

class Server {
  static const link = 'https://arthubserver.herokuapp.com';
}

class AppColors {
  static const red = Color.fromRGBO(239, 69, 58, 1);
  static const blue = Color.fromRGBO(58, 197, 240, 1);
  static const grey = Color.fromRGBO(232, 232, 232, 1);
  static const purple = Color.fromRGBO(69, 56, 133, 1);
}

class Widgets {
  Widget apptitleBar(BuildContext context, String text) {
    final Size size = MediaQuery.of(context).size;
    double padding30 = size.height * 0.03755;
    return AppBar(
      title: Padding(
        padding: EdgeInsets.only(right: padding30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SlideInLeft(
              preferences: AnimationPreferences(offset: Duration(seconds: 1)),
              child: Text(
                text,
                style: TextStyle(
                  color: AppColors.purple,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerOptions {
  String option;
  Icon optionIcon;
  int index;
  DrawerOptions({this.option, this.optionIcon, this.index});
}

// ------------ Data Parsers ----------------

class ParsedDataFreeLanceArts {
  String name;
  String youtube;
  String aboutme;
  String address;
  String avatar;
  List works;
  ParsedDataFreeLanceArts(
      {this.name,
      this.address,
      this.avatar,
      this.works,
      this.aboutme,
      this.youtube});
}

class ParsedDataGallery {
  String name;
  String address;
  String location;
  int contact;
  List works;
  ParsedDataGallery(
      this.name, this.address, this.location, this.contact, this.works);
}

class ParsedDataProduct {
  int id;
  String productID;
  String artistname;
  String productname;
  String artistemail;
  int cost;
  String accountType;
  String type;
  String avatar;
  String desc;
  String description;
  bool avail;
  double weight;
  String dimension;
  String materials;
  List images;
  ParsedDataProduct(
      {this.id,
      this.productID,
      this.artistname,
      this.productname,
      this.artistemail,
      this.accountType,
      this.cost,
      this.type,
      this.avatar,
      this.desc,
      this.description,
      this.avail,
      this.weight,
      this.dimension,
      this.materials,
      this.images});
}

class ParsedOrder {
  String orderID;
  String status;
  int itemnumber;
  String dateOrdered;
  int totalcost;
  int itemscost;
  List purchaseditems;
  ParsedOrder(
      {this.orderID,
      this.status,
      this.itemnumber,
      this.dateOrdered,
      this.totalcost,
      this.itemscost,
      this.purchaseditems});
}

// ------------ Endpoints ----------------

class Registeration {
  int failed = 400;
  int sameemail = 401;
  String fullName = '';
  String email = '';
  String password = '';
  String address = '';
  String avatar = '';
  String number = '';
  String location = '';
  String account = '';
  String aboutme = '';
  List orders = [];
  List works = [];
  List purchasedworks = [];

  Future register() async {
    String registerdbLink = '${Server.link}/apiS/register';
    Map<String, dynamic> dataBody = {
      'name': fullName,
      'email': email,
      'password': password,
      'address': address,
      'avatar': avatar,
      'number': number,
      'location': location,
      'accountType': account,
      'aboutme': aboutme,
      'works': works,
      'orders': orders,
      'purchasedworks': purchasedworks,
    };
    var encodedData = jsonEncode(dataBody);
    try {
      var datasend = await http.post(registerdbLink,
          body: encodedData,
          headers: {'Content-Type': 'application/json; charset=UTF-8'});
      if (datasend.statusCode == 200) {
        return datasend.statusCode;
      } else if (datasend.statusCode == 400) {
        return sameemail;
      }
    } catch (exception) {
      print('this error occured - $exception');
      return failed;
    }
  }
}

class Login {
  int internetNetwork = 500;
  String email;
  String password;
  Future login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('logged') == true) {
      email = prefs.getString('email');
      password = prefs.getString('password');
    }
    String loginLink = '${Server.link}/apiS/login';
    Map<String, String> loginData = {
      'email': email,
      'password': password,
    };

    try {
      var encodedData = jsonEncode(loginData);
      var datasend = await http.post(loginLink,
          body: encodedData,
          headers: {'Content-Type': 'application/json; charset=UTF-8'});
      if (datasend.statusCode == 200) {
        var json = jsonDecode(datasend.body);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (prefs.getBool('logged') == null) {
          prefs.setString('displayName', json['user']['name']);
          prefs.setString('id', json['user']['userID']);
          prefs.setString('accountType', json['user']['accountType']);
          prefs.setString('email', json['user']['email']);
          prefs.setString('password', json['user']['password']);
          prefs.setString('address', json['user']['address']);
          prefs.setString('location', json['user']['location']);
          prefs.setString('avatar', json['user']['avatar']);
          prefs.setString('aboutme', json['user']['aboutme']);
          prefs.setInt('number', json['user']['number']);
          prefs.setBool('logged', true);
        }
        prefs.setBool('inapp', false);
        return datasend.statusCode;
      } else if (datasend.statusCode == 401) {
        return datasend.statusCode;
      } else {
        return internetNetwork;
      }
    } catch (exception) {
      print('Error from login - $exception');
      return internetNetwork;
    }
  }
}

class ResetPassword {
  int datafailed = 400;
  String email;
  String password;
  Future reset() async {
    String resetLink = '${Server.link}/apiC/resetpassword';
    Map databody = {'email': email, 'password': password};
    try {
      var encodedData = jsonEncode(databody);
      var datasend = await http.put(resetLink,
          body: encodedData,
          headers: {'Content-Type': 'application/json; charset=UTF-8'});
      return datasend.statusCode;
    } catch (exception) {
      print('Error from reset password - $exception');
      return datafailed;
    }
  }
}

class UploadWorks {
  int failed = 400;
  String name = '';
  String productName = '';
  int cost = 0;
  String type = '';
  String avatar = '';
  String description = '';
  double height = 0;
  double width = 0;
  double weight = 0;
  String materials = '';
  List<String> images = [];
  Future upload() async {
    String uploadLink = '${Server.link}/apiS/uploadworks';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> uploadData = {
      'userID': prefs.getString('id'),
      'name': prefs.getString('displayName'),
      'email': prefs.getString('email'),
      'accountType': prefs.getString('accountType'),
      'product': productName,
      'cost': cost,
      'type': type,
      'avatar': avatar,
      'description': description,
      'dimension': '$height x $width',
      'weight': weight,
      'materials': materials,
      'images': images,
    };
    try {
      var encodedData = jsonEncode(uploadData);
      var datasend = await http.post(uploadLink,
          body: encodedData,
          headers: {'Content-Type': 'application/json; charset=UTF-8'});
      print('status code - ${datasend.statusCode}');
      return datasend.statusCode;
    } catch (exception) {
      print('Error from upload works - $exception');
      return failed;
    }
  }
}

class UpdateProfile {
  int failed = 500;
  String name;
  String address;
  int number;
  String location;
  String avatar = '';
  String aboutme = '';

  Future updateUser() async {
    String link = '${Server.link}/apiS/edit';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<dynamic, dynamic> body = {
      'userID': prefs.getString('id'),
      'accountType': prefs.getString('accountType'),
      'name': name,
      'address': address,
      'number': number,
      'location': location,
      'avatar': avatar,
      'aboutme': aboutme,
    };
    try {
      var encoded = jsonEncode(body);
      var update = await http.post(link,
          body: encoded,
          headers: {'Content-Type': 'application/json; charset=UTF-8'});
      if (update.statusCode == 200) {
        prefs.setString('displayName', name);
        prefs.setString('address', address);
        prefs.setString('location', location);
        prefs.setString('avatar', avatar);
        prefs.setString('aboutme', aboutme);
        prefs.setInt('number', number);
        return update.statusCode;
      }
      return update.statusCode;
    } catch (exception) {
      print('Error from update user - $exception');
      return failed;
    }
  }
}
