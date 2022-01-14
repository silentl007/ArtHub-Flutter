import 'package:art_hub/screen/homescreen.dart';
import 'package:art_hub/screen/register.dart';
import 'package:art_hub/screen/forgotpassword.dart';
import 'package:flutter/material.dart';
import 'package:art_hub/common/model.dart';
import 'package:flutter_animator/flutter_animator.dart';
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
  int offsetduration = 1;
  int duration = 3;
  bool showpassword = true;
  String he = '';
  @override
  void initState() {
    super.initState();
    getLogin();
  }

  getLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('logged') == true) {
      offsetduration = 2;
      duration = 2;
      _sneakerAlert();
    }
  }

  _sneakerAlert() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content:
          Text('Could not autologin, please check connection and try again'),
      backgroundColor: AppColors.purple,
    ));
  }

  @override
  Widget build(BuildContext context) {
    Sizes().heightSizeCalc(context);
    Sizes().widthSizeCalc(context);
    final node = FocusScope.of(context);
    return SafeArea(
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: Texts.textScale),
        child: Scaffold(
          key: _scaffoldKey,
          appBar: classWidget.apptitleBar(context, 'Login'),
          body: Form(
            key: _key,
            child: Container(
              padding: EdgeInsets.only(left: Sizes.w40, right: Sizes.w40),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/appimages/welcomeback.png'),
                      fit: BoxFit.cover)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => node.nextFocus(),
                    cursorColor: AppColors.purple,
                    decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.purple)),
                        labelText: 'Email',
                        icon: Icon(Icons.email, color: AppColors.purple)),
                    controller: usernameControl,
                    onSaved: (value) {
                      setState(() {
                        loginClass.email = value!.toLowerCase();
                      });
                    },
                  ),
                  TextFormField(
                      cursorColor: AppColors.purple,
                      controller: passwordControl,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.purple)),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.remove_red_eye),
                          color: AppColors.purple,
                          onPressed: () {
                            if (showpassword == true) {
                              setState(() {
                                showpassword = false;
                              });
                            } else {
                              setState(() {
                                showpassword = true;
                              });
                            }
                          },
                        ),
                        labelText: 'Password',
                        icon: Icon(Icons.security, color: AppColors.purple),
                      ),
                      obscureText: showpassword,
                      onSaved: (value) {
                        setState(() {
                          loginClass.password = value;
                        });
                      },
                      validator: (value) {
                        if (value!.length < 6) {
                          return 'Password is less than six (6) characters';
                        }
                      }),
                  SizedBox(
                    height: Sizes.h10,
                  ),
                  Pulse(
                      preferences: AnimationPreferences(
                        autoPlay: AnimationPlayStates.Loop,
                      ),
                      child: _ink('Login', Sizes.w20)),
                  SizedBox(
                    height: Sizes.h10,
                  ),
                  Pulse(
                      preferences: AnimationPreferences(
                        autoPlay: AnimationPlayStates.Loop,
                      ),
                      child: _ink('New user? Register', Sizes.w20)),
                  SizedBox(
                    height: Sizes.h10,
                  ),
                  Pulse(
                      preferences: AnimationPreferences(
                        autoPlay: AnimationPlayStates.Loop,
                      ),
                      child: _ink('Forgot Password?', Sizes.w20)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  slide(String direction, Widget widget) {
    if (direction == 'left') {
      return SlideInLeft(
        preferences: AnimationPreferences(
            offset: Duration(seconds: offsetduration),
            duration: Duration(seconds: duration)),
        child: widget,
      );
    } else {
      return SlideInRight(
        preferences: AnimationPreferences(
            offset: Duration(seconds: offsetduration),
            duration: Duration(seconds: duration)),
        child: widget,
      );
    }
  }

  bounce(Widget widget) {
    return BounceInDown(
        preferences: AnimationPreferences(
            offset: Duration(seconds: offsetduration),
            duration: Duration(seconds: duration)),
        child: widget);
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
          if (keyState!.validate()) {
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
      builder: (context) {
        return FutureBuilder(
          future: loginClass.login(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Container(
                color: Colors.transparent,
                child: AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  content: LinearProgressIndicator(
                    backgroundColor: Colors.white,
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(AppColors.purple),
                  ),
                ),
              );
            } else if (snapshot.data == 401) {
              _wrongdetails();
              return Container();
            } else if (snapshot.data == 200) {
              _loginSuccess();
              return Container();
            } else {
              _internet();
              return Container();
            }
          },
        );
      },
    );
  }

  _loginSuccess() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Navigator.pop(context);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    });
  }

  _wrongdetails() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppColors.purple,
          content: Text('Wrong email or password')));
    });
  }

  _internet() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppColors.purple,
          content: Text(
              'Unable to connect, please check your internet connection')));
    });
  }
}
