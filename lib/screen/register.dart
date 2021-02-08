import 'package:ArtHub/common/model.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int defaultaccount = 0;
  final List<AccountType> accounts = [
    AccountType(type: 'Customer', index: 1),
    AccountType(type: 'Freelancer', index: 2),
    AccountType(type: 'Gallery', index: 3),
  ];
  String accountchoice;
  final List<String> states = ['Select State', 'Lagos', 'Bayelsa'];
  String selectedState = 'Select State';
  Widgets classWidget = Widgets();
  Registeration registerClass = Registeration();
  final _key = GlobalKey<FormState>();
  final passwordCtrl = TextEditingController();
  bool _check = false;
  Color _terms = AppColors.purple;
  Color _stateColor = Colors.black;
  Color _radiocolor = AppColors.purple;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fontSize15 = size.height * 0.01870;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: classWidget.apptitleBar('Register'),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/appimages/welcomeback.png'),
                      fit: BoxFit.cover)),
            ),
            Form(
              key: _key,
              child: Container(
                padding: EdgeInsets.only(left: 40, right: 40),
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            labelText: 'Full Name', icon: Icon(Icons.title)),
                        onSaved: (text) {
                          setState(() {
                            return registerClass.fullName = text;
                          });
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'This field is empty';
                          }
                        },
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        maxLength: 11,
                        decoration: InputDecoration(
                            labelText: 'Phone No.', icon: Icon(Icons.phone)),
                        onSaved: (text) {
                          setState(() {
                            return registerClass.number = text;
                          });
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'This field is empty';
                          } else if (value.length != 11) {
                            return 'The number is not complete';
                          }
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Address', icon: Icon(Icons.gps_fixed)),
                        onSaved: (text) {
                          setState(() {
                            return registerClass.address = text;
                          });
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'This field is empty';
                          }
                        },
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: DropdownButton<String>(
                          value: selectedState,
                          onChanged: (text) {
                            setState(() {
                              selectedState = text;
                              registerClass.location = selectedState;
                            });
                          },
                          items: states.map<DropdownMenuItem<String>>((text) {
                            return DropdownMenuItem(
                              child: Text(
                                text,
                                style: TextStyle(color: _stateColor),
                              ),
                              value: text,
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Account type',
                            style: TextStyle(
                                fontSize: fontSize15, color: _radiocolor),
                          )),
                      SizedBox(
                        height: 5,
                      ),
                      Column(
                          children: accounts.map((data) {
                        return RadioListTile(
                            activeColor: AppColors.purple,
                            title: Text('${data.type}'),
                            value: data.index,
                            groupValue: defaultaccount,
                            onChanged: (value) {
                              setState(() {
                                defaultaccount = data.index;
                                accountchoice = data.type;
                              });
                            });
                      }).toList()),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: 'E-mail', icon: Icon(Icons.email)),
                        onSaved: (text) {
                          setState(() {
                            return registerClass.email = text;
                          });
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'This field is empty';
                          }
                        },
                      ),
                      TextFormField(
                        obscureText: true,
                        controller: passwordCtrl,
                        decoration: InputDecoration(
                            labelText: 'Password', icon: Icon(Icons.security)),
                        onSaved: (text) {
                          setState(() {
                            return registerClass.password = text;
                          });
                        },
                        validator: (value) {
                          if (value.length < 6) {
                            return 'Password is less than six (6) characters';
                          }
                        },
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: 'Repeat Password',
                            icon: Icon(Icons.repeat)),
                        validator: (text) {
                          if (text != passwordCtrl.text) {
                            return 'Passwords do not match!';
                          }
                        },
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      CheckboxListTile(
                        value: _check,
                        checkColor: AppColors.purple,
                        activeColor: Colors.transparent,
                        onChanged: (bool val) {
                          setState(() {
                            _check = val;
                          });
                        },
                        title: InkWell(
                            onTap: () => _termsConditions(context),
                            child: Text(
                                'I have read and agreed to terms and conditions',
                                style: TextStyle(
                                  color: _terms,
                                ))),
                      ),
                      RaisedButton(
                        color: AppColors.purple,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        child: Text(
                          'Register',
                          style: TextStyle(
                              fontSize: fontSize15, color: Colors.white),
                        ),
                        onPressed: () {
                          final keyForm = _key.currentState;
                          if (keyForm.validate() == true) {
                            if (_check == false ||
                                selectedState == 'Select State' ||
                                defaultaccount == 0) {
                              setState(() {
                                _terms = Colors.red;
                                _stateColor = Colors.red;
                                _radiocolor = Colors.red;
                              });
                            } else {
                              registerClass.location = selectedState;
                              registerClass.account = accountchoice;
                              keyForm.save();
                              futureDiag(context);
                              setState(() {
                                defaultaccount = 0;
                                selectedState = states[0];
                                _check = false;
                              });
                            }
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  futureDiag(BuildContext context) {
    return showDialog(
        context: context,
        child: FutureBuilder(
            future: registerClass.register(),
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
                    ? _registerationSuccess()
                    : snapshot.data == 401
                        ? _registerationEmail()
                        : _registerationFailed(),
              );
            }));
  }

  _registerationSuccess() {
    return AlertDialog(
      content: Text(
          'A verification email is sent. Please verify your email to complete registration'),
    );
  }

  _registerationFailed() {
    print('hello');
    return AlertDialog(
      content: Text('Please check your internet connection'),
    );
  }

  _registerationEmail() {
    return AlertDialog(
      content: Text('This email has been used'),
    );
  }

  _termsConditions(BuildContext context) {
    return showDialog(
        context: context,
        child: AlertDialog(
          title: Text(
            'Terms and Conditions',
            textAlign: TextAlign.center,
          ),
          scrollable: true,
          content: Text('Give terms and conditions'),
          actions: [
            FlatButton(
              onPressed: null,
              child: Text('Agree'),
            )
          ],
        ));
  }

  comingSoon(BuildContext context) {
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
              child: Text('OK'),
            )
          ],
        ));
  }
}

class AccountType {
  String type;
  int index;
  AccountType({this.index, this.type});
}
