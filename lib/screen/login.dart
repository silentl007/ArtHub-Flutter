import 'package:ArtHub/screen/homescreen.dart';
import 'package:ArtHub/screen/register.dart';
import 'package:ArtHub/screen/forgotpassword.dart';
import 'package:flutter/material.dart';
import 'package:ArtHub/common/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Login loginClass = Login();
  Widgets classWidget = Widgets();
  final _key = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final usernameControl = TextEditingController();
  final passwordControl = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLogin();
  }

  getLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('logged') == true) {
      _sneakerAlert();
    }
  }

  _sneakerAlert() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
            'Something went wrong, please try again')));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fontSize = size.height * 0.025;
    bool showpassword = true;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: classWidget.apptitleBar(context, 'Login'),
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
                      loginClass.userName = value.toLowerCase();
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
                _ink('Login', fontSize),
                SizedBox(
                  height: 10,
                ),
                _ink('New user? Register', fontSize),
                SizedBox(
                  height: 10,
                ),
                _ink('Forgot Password?', fontSize),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _ink(String text, double font) {
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
            _loginLogic();
          }
        } else if (text == 'New user? Register') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => RegisterScreen()));
        } else
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ForgotPasswordScreen()));
      },
    );
  }

  _loginLogic() {
    return showDialog(
      context: context,
      child: FutureBuilder(
        future: loginClass.login(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Container(
              color: Colors.transparent,
              child: AlertDialog(
                content: LinearProgressIndicator(
                  backgroundColor: Colors.white,
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(AppColors.purple),
                ),
              ),
            );
          }
          if (snapshot.data == 500) {
            return AlertDialog(
              title: Text('Wrong email or password'),
            );
          }
          if (snapshot.data == 200) {
            _loginSuccess();
            return Container();
          }
          return AlertDialog(
            title: Text(
                'Unable to connect, please check your internet connection'),
          );
        },
      ),
    );
  }

  _loginSuccess() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pop(context);
      return Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    });
  }
}
