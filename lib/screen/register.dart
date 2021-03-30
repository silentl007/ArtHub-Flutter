import 'package:ArtHub/common/model.dart';
import 'package:ArtHub/screen/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary_client/cloudinary_client.dart';

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
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _check = false;
  bool showpassword = true;
  bool showpassword1 = true;
  Color _terms = AppColors.purple;
  Color _stateColor = Colors.black;
  Color _radiocolor = AppColors.purple;
  Color _avatarcolor = Colors.black;
  final client = CloudinaryClient(
      '915364875791742', 'xXs8EIDnGzWGCFVZpr4buRyDOQk', 'mediacontrol');
  final picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final node = FocusScope.of(context);
    double fontSize15 = size.height * 0.01870;
    double sizeHeight5 = size.height * 0.00625;
    double sizeHeight3 = size.height * 0.00375;
    double padding40 = size.height * 0.05;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: classWidget.apptitleBar(context, 'Register'),
        body: WillPopScope(
          onWillPop: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (Route<dynamic> route) => false);
          },
          child: Stack(
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
                  padding: EdgeInsets.only(left: padding40, right: padding40),
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        slide(
                            'left',
                            Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Account type',
                                  style: TextStyle(
                                      fontSize: fontSize15, color: _radiocolor),
                                ))),
                        SizedBox(
                          height: sizeHeight5,
                        ),
                        slide(
                            'left',
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
                            }).toList())),
                        slide(
                            'right',
                            TextFormField(
                              cursorColor: AppColors.purple,
                              textCapitalization: TextCapitalization.words,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => node.nextFocus(),
                              decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: AppColors.purple)),
                                  labelText: 'Full Name',
                                  icon: Icon(Icons.title,
                                      color: AppColors.purple)),
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
                            )),
                        slide(
                            'left',
                            TextFormField(
                              cursorColor: AppColors.purple,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => node.nextFocus(),
                              maxLength: 11,
                              decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: AppColors.purple)),
                                  labelText: 'Phone No.',
                                  icon: Icon(Icons.phone,
                                      color: AppColors.purple)),
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
                            )),
                        slide(
                            'right',
                            TextFormField(
                              cursorColor: AppColors.purple,
                              textCapitalization: TextCapitalization.words,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => node.nextFocus(),
                              decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: AppColors.purple)),
                                  labelText: 'Address',
                                  icon: Icon(Icons.gps_fixed,
                                      color: AppColors.purple)),
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
                            )),
                        accountchoice == 'Freelancer'
                            ? slide(
                                'right',
                                Column(
                                  children: [
                                    TextFormField(
                                      cursorColor: AppColors.purple,
                                      maxLines: 5,
                                      maxLength: 400,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: AppColors.purple)),
                                          labelText: 'About me',
                                          icon: Icon(Icons.text_fields,
                                              color: AppColors.purple)),
                                      onSaved: (text) {
                                        setState(() {
                                          return registerClass.aboutme = text;
                                        });
                                      },
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'This field is empty';
                                        }
                                      },
                                    ),
                                    SizedBox(
                                      height: sizeHeight5,
                                    ),
                                    Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Upload your avatar',
                                          style: TextStyle(
                                              fontSize: fontSize15,
                                              color: _avatarcolor),
                                        )),
                                    SizedBox(
                                      height: sizeHeight5,
                                    ),
                                    Row(
                                      children: [
                                        RaisedButton(
                                          onPressed: () => _avatarFuture(),
                                          color: AppColors.purple,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(150))),
                                          child: Row(
                                            children: [
                                              Icon(Icons.upload_file,
                                                  color: Colors.white),
                                              SizedBox(
                                                width: sizeHeight5,
                                              ),
                                              Text(
                                                'Upload',
                                                style: TextStyle(
                                                    fontSize: fontSize15,
                                                    color: Colors.white),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: sizeHeight3),
                                        RaisedButton(
                                          onPressed: () => removeavatar(),
                                          color: AppColors.purple,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(150))),
                                          child: Row(
                                            children: [
                                              Icon(Icons.cancel,
                                                  color: Colors.white),
                                              SizedBox(
                                                width: sizeHeight5,
                                              ),
                                              Text(
                                                'Remove',
                                                style: TextStyle(
                                                    fontSize: fontSize15,
                                                    color: Colors.white),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ))
                            : Container(),
                        SizedBox(
                          height: sizeHeight3,
                        ),
                        slide(
                            'left',
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
                                items: states
                                    .map<DropdownMenuItem<String>>((text) {
                                  return DropdownMenuItem(
                                    child: Text(
                                      text,
                                      style: TextStyle(
                                          color: _stateColor, fontSize: 18),
                                    ),
                                    value: text,
                                  );
                                }).toList(),
                              ),
                            )),
                        slide(
                            'right',
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
                                  icon: Icon(Icons.email,
                                      color: AppColors.purple)),
                              onSaved: (text) {
                                setState(() {
                                  return registerClass.email =
                                      text.toLowerCase();
                                });
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'This field is empty';
                                } else if (value.contains('@') == false) {
                                  return 'Not a valid email';
                                }
                              },
                            )),
                        slide(
                            'left',
                            TextFormField(
                              cursorColor: AppColors.purple,
                              obscureText: showpassword,
                              controller: passwordCtrl,
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
                                  return registerClass.password = text;
                                });
                              },
                              validator: (value) {
                                if (value.length < 6) {
                                  return 'Password is less than six (6) characters';
                                } else if (value.contains(RegExp(r'[0-9]')) ==
                                    false) {
                                  return 'Password does not contain a digit';
                                }
                              },
                            )),
                        slide(
                            'right',
                            TextFormField(
                              cursorColor: AppColors.purple,
                              obscureText: showpassword1,
                              textInputAction: TextInputAction.done,
                              onEditingComplete: () => node.unfocus(),
                              decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: AppColors.purple)),
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.remove_red_eye),
                                    color: AppColors.purple,
                                    onPressed: () {
                                      if (showpassword1 == true) {
                                        setState(() {
                                          showpassword1 = false;
                                        });
                                      } else {
                                        setState(() {
                                          showpassword1 = true;
                                        });
                                      }
                                    },
                                  ),
                                  labelText: 'Repeat Password',
                                  icon: Icon(Icons.repeat,
                                      color: AppColors.purple)),
                              validator: (text) {
                                if (text != passwordCtrl.text) {
                                  return 'Passwords do not match!';
                                }
                              },
                            )),
                        SizedBox(
                          height: sizeHeight3,
                        ),
                        slide(
                            'left',
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
                            )),
                        BounceInDown(
                            preferences: AnimationPreferences(
                                offset: Duration(seconds: 2)),
                            child: Pulse(
                              preferences: AnimationPreferences(
                                  autoPlay: AnimationPlayStates.Loop,
                                  offset: Duration(seconds: 3)),
                              child: RaisedButton(
                                color: AppColors.purple,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                child: Text(
                                  'Register',
                                  style: TextStyle(
                                      fontSize: fontSize15,
                                      color: Colors.white),
                                ),
                                onPressed: () {
                                  final keyForm = _key.currentState;

                                  if (keyForm.validate() == true) {
                                    if (_check == false) {
                                      setState(() {
                                        _terms = Colors.red;
                                      });
                                    } else if (selectedState ==
                                        'Select State') {
                                      setState(() {
                                        _stateColor = Colors.red;
                                      });
                                    } else if (defaultaccount == 0) {
                                      setState(() {
                                        _radiocolor = Colors.red;
                                      });
                                    } else {
                                      if (accountchoice == 'Freelancer') {
                                        if (registerClass.avatar == '') {
                                          setState(() {
                                            _avatarcolor = Colors.red;
                                          });
                                        } else {
                                          registerClass.location =
                                              selectedState;
                                          registerClass.account = accountchoice;
                                          keyForm.save();
                                          futureDiag(context);
                                        }
                                      } else {
                                        registerClass.location = selectedState;
                                        registerClass.account = accountchoice;
                                        keyForm.save();
                                        futureDiag(context);
                                      }
                                    }
                                  }
                                },
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
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
              return Container(
                child: snapshot.data == 200
                    ? _registerationSuccess()
                    : snapshot.data == 401
                        ? _registerationEmail()
                        : _registerationFailed(),
              );
            }));
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

  clearData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final keyForm = _key.currentState;
      keyForm.reset();
      setState(() {
        passwordCtrl.text = '';
        defaultaccount = 0;
        selectedState = states[0];
        _check = false;
        _terms = AppColors.purple;
        _stateColor = Colors.black;
        _radiocolor = AppColors.purple;
        _avatarcolor = Colors.black;
      });
    });
  }

  changeAvatarColor() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _avatarcolor = Colors.green;
      });
    });
  }

  removeavatar() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        registerClass.avatar = '';
        _avatarcolor = Colors.black;
      });
    });
  }

  _registerationSuccess() {
    clearData();
    return AlertDialog(
      content: Text(
          'A verification email is sent. Please verify your email to complete registration'),
    );
  }

  _registerationFailed() {
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

  _avatarimagePicker() async {
    if (registerClass.avatar != '') {
      return null;
    } else {
      var image = await picker.getImage(source: ImageSource.gallery);
      try {
        var response =
            await client.uploadImage(image.path, folder: 'arthub_folder');
        return response.secure_url;
      } catch (exception) {
        print(exception);
        _scaffoldKey.currentState.showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text('Something went wrong! Please try again!')));
      }
    }
  }

  _avatarFuture() {
    return showDialog(
        context: context,
        child: FutureBuilder(
          future: _avatarimagePicker(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (registerClass.avatar != '') {
              return AlertDialog(
                content: Text('Avatar already uploaded'),
              );
            } else if (snapshot.connectionState != ConnectionState.done) {
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
            } else if (snapshot.hasData) {
              changeAvatarColor();
              registerClass.avatar = snapshot.data;
              return AlertDialog(
                content: Text('Avatar upload complete'),
              );
            } else
              return AlertDialog(
                content: Text(
                    'Unable to upload connect, please check your connetion'),
              );
          },
        ));
  }
}

class AccountType {
  String type;
  int index;
  AccountType({this.index, this.type});
}
