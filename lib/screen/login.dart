import 'package:ArtHub/screen/homescreen.dart';
import 'package:ArtHub/screen/register.dart';
import 'package:flutter/material.dart';
import 'package:ArtHub/common/model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Widgets classWidget = Widgets();
  final GlobalKey _key = GlobalKey<FormState>();
  final usernameControl = TextEditingController();
  final passwordControl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fontSize = size.height * 0.025;
    return SafeArea(
      child: Scaffold(
        appBar: classWidget.apptitleBar('Login'),
        body: Form(
          key: _key,
          child: Container(
            padding: EdgeInsets.only(left: 40, right: 40),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/appimages/welcomeback.png'),
                    fit: BoxFit.cover)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                      focusColor: AppColors.purple,
                      labelText: 'Username',
                      icon: Icon(Icons.person)),
                  controller: usernameControl,
                ),
                TextFormField(
                  controller: passwordControl,
                  decoration: InputDecoration(
                      labelText: 'Password', icon: Icon(Icons.security)),
                  obscureText: true,
                ),
                SizedBox(
                  height: 10,
                ),
                _ink(context, 'Login', fontSize),
                SizedBox(
                  height: 10,
                ),
                _ink(context, 'New user? Register', fontSize),
                SizedBox(
                  height: 10,
                ),
                _ink(context, 'Forgot Password?', fontSize),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _ink(BuildContext context, String text, double font) {
    return InkWell(
      child: Text(
        text,
        style: TextStyle(fontSize: font, color: AppColors.purple),
      ),
      onTap: () {
        if (text == 'Login') {
          print(usernameControl.text);
          print(passwordControl.text);
          if (passwordControl.text == 'pablo') {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          }
        } else if (text == 'New user? Register') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => RegisterScreen()));
        }
      },
    );
  }
}
