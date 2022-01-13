import 'package:art_hub/screen/login.dart';
import 'package:flutter/material.dart';
import 'package:art_hub/common/model.dart';
import 'package:flutter_animator/flutter_animator.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  Widgets classWidget = Widgets();
  ResetPassword resetClass = ResetPassword();
  var emailText = TextEditingController();
  final textKey = GlobalKey<FormState>();
  bool showpassword = true;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final node = FocusScope.of(context);
    double padding40 = size.height * 0.05;
    double sizeHeight5 = size.height * 0.00625;
    return SafeArea(
      child: Scaffold(
        appBar: classWidget.apptitleBar(context, 'Forgot Password'),
        body: WillPopScope(
          onWillPop: () async {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (Route<dynamic> route) => false);
            return true;
          },
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/appimages/welcomeback.png'),
                    fit: BoxFit.cover)),
            child: Form(
              key: textKey,
              child: Container(
                padding: EdgeInsets.only(left: padding40, right: padding40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    slide(
                        'left',
                        TextFormField(
                          cursorColor: AppColors.purple,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => node.nextFocus(),
                          decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColors.purple)),
                              labelText: 'E-mail',
                              icon: Icon(Icons.email, color: AppColors.purple)),
                          onSaved: (text) {
                            setState(() {
                              resetClass.email = text!.toLowerCase();
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'This field is empty';
                            }
                          },
                        )),
                    SizedBox(
                      height: sizeHeight5,
                    ),
                    slide(
                        'right',
                        TextFormField(
                          cursorColor: AppColors.purple,
                          obscureText: showpassword,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => node.nextFocus(),
                          decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColors.purple)),
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
                              helperText:
                                  'must at least be six (6) characters and has at least a digit',
                              icon: Icon(Icons.security,
                                  color: AppColors.purple)),
                          onSaved: (text) {
                            setState(() {
                              resetClass.password = text;
                            });
                          },
                          validator: (value) {
                            if (value!.length < 6) {
                              return 'Password is less than six (6) characters';
                            } else if (value.contains(RegExp(r'[0-9]')) ==
                                false) {
                              return 'Password does not contain a digit';
                            }
                          },
                        )),
                    SizedBox(
                      height: sizeHeight5,
                    ),
                    BounceInDown(
                      preferences:
                          AnimationPreferences(offset: Duration(seconds: 2)),
                      child: Pulse(
                        preferences: AnimationPreferences(
                            autoPlay: AnimationPlayStates.Loop,
                            offset: Duration(seconds: 3)),
                        child: ElevatedButton(
                          onPressed: () {
                            var keyform = textKey.currentState;
                            if (keyform!.validate()) {
                              keyform.save();
                              futureDiag();
                            }
                          },
                          child: Decorations().buttonText(
                              buttonText: 'Reset', context: context),
                          style: Decorations().buttonDecor(context: context),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  slide(String direction, Widget widget) {
    int duration = 4;
    if (direction == 'left') {
      return SlideInLeft(
        preferences: AnimationPreferences(
          duration: Duration(seconds: duration),
        ),
        child: widget,
      );
    } else {
      return SlideInRight(
        preferences:
            AnimationPreferences(duration: Duration(seconds: duration)),
        child: widget,
      );
    }
  }

  futureDiag() {
    return showDialog(
        context: context,
        builder: (context) {
          return FutureBuilder(
              future: resetClass.reset(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData == false) {
                  return AlertDialog(
                    content: LinearProgressIndicator(
                      backgroundColor: Colors.white,
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(AppColors.purple),
                    ),
                  );
                }
                return Container(
                  child: snapshot.data == 200
                      ? _resetPass()
                      : snapshot.data == 401
                          ? _resetEmail()
                          : _resetFailed(),
                );
              });
        });
  }

  _resetPass() {
    clearData();
    return AlertDialog(
      content: Text('Password reset has been sent to your email'),
    );
  }

  _resetEmail() {
    return AlertDialog(
      content: Text('Email not found!'),
    );
  }

  _resetFailed() {
    return AlertDialog(
      content: Text('Unable to reset password'),
    );
  }

  clearData() {
    var keyform = textKey.currentState;
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      keyform!.reset();
      setState(() {});
    });
  }
}
