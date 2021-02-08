import 'package:ArtHub/screen/homescreen.dart';
import 'package:ArtHub/screen/register.dart';
import 'package:ArtHub/screen/forgotpassword.dart';
import 'package:flutter/material.dart';
import 'package:ArtHub/common/model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Login loginClass = Login();
  Widgets classWidget = Widgets();
  final _key = GlobalKey<FormState>();
  final usernameControl = TextEditingController();
  final passwordControl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fontSize = size.height * 0.025;
    bool showpassword = true;
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
                      labelText: 'Email', icon: Icon(Icons.email)),
                  controller: usernameControl,
                  onSaved: (value) {
                    setState(() {
                      loginClass.userName = value;
                    });
                  },
                ),
                TextFormField(
                    controller: passwordControl,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(Icons.remove_red_eye),
                          onPressed: () {
                            print('object');
                            if (showpassword == true) {
                              setState(() {
                                showpassword = false;
                              });
                            } else
                              setState(() {
                                showpassword = true;
                              });
                          },
                        ),
                        labelText: 'Password',
                        icon: Icon(Icons.security)),
                    obscureText: showpassword,
                    onSaved: (value) {
                      setState(() {
                        loginClass.password = value;
                      });
                    },
                    validator: (value) {
                      if (value.length < 6) {
                        return 'Password is less than six (6) characters';
                      }
                    }),
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
          var keyState = _key.currentState;
          if (keyState.validate()) {
            keyState.save();
            _loginLogic(context);
          }
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => HomeScreen()));
        } else if (text == 'New user? Register') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => RegisterScreen()));
        } else
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ForgotPasswordScreen()));
      },
    );
  }

  _loginLogic(BuildContext context) {
    return showDialog(
      context: context,
      child: FutureBuilder(
        future: loginClass.login(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData == false) {
            return AlertDialog(
              content: LinearProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: new AlwaysStoppedAnimation<Color>(AppColors.purple),
              ),
            );
          }
          return snapshot.data == 200
              ? Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()))
              : AlertDialog(
                  title: Text('${snapshot.data}'),
                );
        },
      ),
    );
  }

  _loginSuccess() {
    return Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
    // return SafeArea(
    //   child: Scaffold(
    //     body: Center(
    //       child: Text('Hello World'),
    //     ),
    //   ),
    // );
  }
}
