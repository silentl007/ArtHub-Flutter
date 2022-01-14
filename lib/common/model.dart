import 'dart:ui';

import 'package:art_hub/screen/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// ------------ Misc classes ----------------

class Sizes {
  static double? size;
  // height
  static double h220 = 0;
  static double h40 = 0;
  static double h24 = 0;
  static double h16 = 0;
  static double h18 = 0;
  static double h80 = 0;
  static double h45 = 0;
  static double h8 = 0;
  static double h32 = 0;
  static double h30 = 0;
  static double h200 = 0;
  static double h10 = 0;
  static double h5 = 0;
  static double h20 = 0;
  static double h35 = 0;
  static double h22 = 0;
  static double h120 = 0;
  static double h350 = 0;
  static double h250 = 0;
  static double h100 = 0;
  static double h60 = 0;
  static double h2 = 0;
  static double h38 = 0;
  static double h50 = 0;
  static double h400 = 0;
  static double h150 = 0;
  static double h15 = 0;
  static double h1 = 0;
  static double h500 = 0;
  static double h65 = 0;
  static double h110 = 0;
  static double h130 = 0;
  static double h300 = 0;
  static double h25 = 0;
  static double h13 = 0;
  static double h17 = 0;
  static double h70 = 0;
  static double h12 = 0;
  static double h355 = 0;
  static double h180 = 0;
  static double h3 = 0;
  static double h7 = 0;
  static double h600 = 0;
  static double h44 = 0;
  static double h165 = 0;
  static double h330 = 0;
  static double h360 = 0;
  // Width
  static double w40 = 0;
  static double w180 = 0;
  static double w24 = 0;
  static double w16 = 0;
  static double w18 = 0;
  static double w80 = 0;
  static double w45 = 0;
  static double w8 = 0;
  static double w32 = 0;
  static double w30 = 0;
  static double w200 = 0;
  static double w10 = 0;
  static double w5 = 0;
  static double w20 = 0;
  static double w35 = 0;
  static double w22 = 0;
  static double w120 = 0;
  static double w350 = 0;
  static double w250 = 0;
  static double w100 = 0;
  static double w60 = 0;
  static double w2 = 0;
  static double w38 = 0;
  static double w50 = 0;
  static double w400 = 0;
  static double w150 = 0;
  static double w15 = 0;
  static double w1 = 0;
  static double w500 = 0;
  static double w65 = 0;
  static double w110 = 0;
  static double w130 = 0;
  static double w300 = 0;
  static double w25 = 0;
  static double w13 = 0;
  static double w17 = 0;
  static double w70 = 0;
  static double w7 = 0;
  static double w12 = 0;
  static double w211 = 0;
  static double w4 = 0;
  static double w230 = 0;
  static double w317 = 0;
  static double w90 = 0;
  void widthSizeCalc(BuildContext context) {
    // most of the smaller numbers are for font sizes, bigger numbers for height of widgets
    size = MediaQuery.of(context).size.width;
    w4 = size! * .00945;
    w211 = size! * .5;
    w230 = size! * .5437;
    w40 = size! * .0945;
    w16 = size! * .0378;
    w18 = size! * .0425;
    w80 = size! * .1891;
    w45 = size! * .10638;
    w8 = size! * .0189;
    w32 = size! * .0756;
    w30 = size! * .0709;
    w70 = size! * .16548;
    w7 = size! * .016548;
    w200 = size! * .47281;
    w10 = size! * .0236;
    w5 = size! * .0118;
    w20 = size! * .04728;
    w24 = size! * .0567;
    w35 = size! * .0827;
    w180 = size! * .42533;
    w22 = size! * .052;
    w120 = size! * .28368;
    w350 = size! * .82742;
    w250 = size! * .591;
    w100 = size! * .2364;
    w60 = size! * .1418;
    w2 = size! * .0047;
    w38 = size! * .0898;
    w50 = size! * .1182;
    w400 = size! * .9456;
    w150 = size! * .3546;
    w15 = size! * .03546;
    w1 = size! * .002364;
    w500 = size! * 1.1820;
    w65 = size! * .15366;
    w110 = size! * .26;
    w130 = size! * .3073;
    w300 = size! * .7092;
    w25 = size! * .0591;
    w13 = size! * .0307;
    w17 = size! * .04018;
    w70 = size! * .16548;
    w12 = size! * .0283;
    w317 = size! * .75;
    w90 = size! * .2123;
  }

  void heightSizeCalc(BuildContext context) {
    size = MediaQuery.of(context).size.height;
    h220 = size! * 0.275;
    h600 = size! * 0.7509;
    h40 = size! * .05;
    h24 = size! * .03;
    h16 = size! * .02;
    h18 = size! * .0225;
    h80 = size! * .1;
    h45 = size! * .05632;
    h8 = size! * .01;
    h32 = size! * .04;
    h30 = size! * .0375;
    h70 = size! * .08761;
    h200 = size! * .25;
    h10 = size! * .0125;
    h5 = size! * .00625;
    h20 = size! * .025;
    h24 = size! * .03;
    h35 = size! * .0438;
    h22 = size! * .02753;
    h120 = size! * .15;
    h350 = size! * .438;
    h250 = size! * .313;
    h100 = size! * .125;
    h60 = size! * .0751;
    h2 = size! * .0025;
    h38 = size! * .0476;
    h50 = size! * .0626;
    h400 = size! * .5;
    h150 = size! * .1877;
    h15 = size! * .0187;
    h1 = size! * .00125156;
    h500 = size! * .626;
    h65 = size! * .0814;
    h110 = size! * .13767;
    h130 = size! * .1627;
    h300 = size! * .375469;
    h25 = size! * .031289;
    h13 = size! * .01627;
    h17 = size! * .0212765;
    h70 = size! * .087609;
    h12 = size! * .015018;
    h355 = size! * .444305;
    h180 = size! * .225;
    h7 = size! * .008761;
    h3 = size! * .00375;
    h44 = size! * .05506;
    h165 = size! * .2065;
    h330 = size! * .4130162;
    h360 = size! * .45;
  }
}

class Server {
  static const link = 'https://arthubserver.herokuapp.com';
}

class Texts {
  static const textScale = .9;
  static const publicKey = 'pk_test_317423d856fb6d9a2201e6b5540a0ad74904da87';
}

class AppColors {
  static const red = Color.fromRGBO(239, 69, 58, 1);
  static const blue = Color.fromRGBO(58, 197, 240, 1);
  static const grey = Color.fromRGBO(232, 232, 232, 1);
  static const purple = Color.fromRGBO(69, 56, 133, 1);
}

class Decorations {
  buttonDecor(
      {required BuildContext context,
      Color? buttoncolor,
      bool? noBorder,
      double? borderRadius,
      double? elevation}) {
    Sizes().widthSizeCalc(context);
    return ElevatedButton.styleFrom(
        elevation: elevation ?? 10,
        primary: buttoncolor ?? AppColors.purple,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(noBorder == true ? 0 : borderRadius ??  Sizes.w50))));
  }

  buttonText(
      {required String buttonText,
      required BuildContext context,
      FontWeight? fontweight,
      double? fontsize,
      Color? textColor}) {
    Sizes().widthSizeCalc(context);
    return Text(
      buttonText,
      style: TextStyle(
          fontSize: fontsize ?? Sizes.w15,
          color: textColor ?? Colors.white,
          fontWeight: fontweight ?? FontWeight.w400),
    );
  }
}

class Widgets {
  apptitleBar(BuildContext context, String text) {
    final Size size = MediaQuery.of(context).size;
    double padding30 = size.height * 0.03755;
    return AppBar(
      title: Padding(
        padding: EdgeInsets.only(right: padding30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SlideInLeft(
              preferences: AnimationPreferences(offset: Duration(seconds: 2)),
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

  Widget floatingHome(
    BuildContext context,
  ) {
    return BounceInDown(
      preferences: AnimationPreferences(offset: Duration(seconds: 1)),
      child: FloatingActionButton(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
              (Route<dynamic> route) => false);
        },
        child: Pulse(
            preferences:
                AnimationPreferences(autoPlay: AnimationPlayStates.Loop),
            child: Icon(Icons.home)),
        backgroundColor: AppColors.purple,
      ),
    );
  }
}

class DrawerOptions {
  String? option;
  Icon? optionIcon;
  int? index;
  DrawerOptions({this.option, this.optionIcon, this.index});
}

// ------------ Data Parsers ----------------

class ParsedDataFreeLanceArts {
  String? name;
  String? youtube;
  String? aboutme;
  String? address;
  String? avatar;
  List? works;
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
  int? id;
  String? productID;
  String? artistname;
  String? productname;
  String? artistemail;
  int? cost;
  String? accountType;
  String? type;
  String? avatar;
  String? desc;
  String? description;
  bool? avail;
  double? weight;
  String? dimension;
  String? materials;
  List? images;
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
  String? orderID;
  String? status;
  int? itemnumber;
  String? dateOrdered;
  int? totalcost;
  int? itemscost;
  List? purchaseditems;
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
  int? failed = 400;
  int? sameemail = 401;
  String? fullName = '';
  String? email = '';
  String? password = '';
  String? address = '';
  String? avatar = '';
  String? number = '';
  String? location = '';
  String? account = '';
  String? aboutme = '';
  List? orders = [];
  List? works = [];
  List? purchasedworks = [];

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
      Uri link = Uri.parse(registerdbLink);
      var datasend = await http.post(link,
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
  String? email;
  String? password;
  Future login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('logged') == true) {
      email = prefs.getString('email');
      password = prefs.getString('password');
    }
    String loginLink = '${Server.link}/apiS/login';
    Map<String, String> loginData = {
      'email': email!,
      'password': password!,
    };

    try {
      Uri link = Uri.parse(loginLink);
      var encodedData = jsonEncode(loginData);
      var datasend = await http.post(link,
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
  String? email;
  String? password;
  Future reset() async {
    String resetLink = '${Server.link}/apiC/resetpassword';
    Map databody = {'email': email, 'password': password};
    try {
      Uri link = Uri.parse(resetLink);
      var encodedData = jsonEncode(databody);
      var datasend = await http.put(link,
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
      Uri link = Uri.parse(uploadLink);
      var encodedData = jsonEncode(uploadData);
      var datasend = await http.post(link,
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
  String? name;
  String? address;
  int? number;
  String? location;
  String avatar = '';
  String aboutme = '';

  Future updateUser() async {
    Uri link = Uri.parse('${Server.link}/apiS/edit');
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
        prefs.setString('displayName', name!);
        prefs.setString('address', address!);
        prefs.setString('location', location!);
        prefs.setString('avatar', avatar);
        prefs.setString('aboutme', aboutme);
        prefs.setInt('number', number!);
        return update.statusCode;
      }
      return update.statusCode;
    } catch (exception) {
      print('Error from update user - $exception');
      return failed;
    }
  }
}
