import 'package:ArtHub/screen/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:ArtHub/common/model.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary_client/cloudinary_client.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:credit_card/flutter_credit_card.dart';
import 'package:credit_card/credit_card_form.dart';
import 'package:credit_card/credit_card_model.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Widgets classWidget = Widgets();
  List cardDate = [];
  UpdateProfile update = UpdateProfile();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<String> states = ['Select State', 'Lagos', 'Bayelsa'];
  String selectedState = 'Select State';
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  String avatar = '';
  String email = '';
  String displayName = '';
  String address = '';
  String state = '';
  String aboutme = '';
  String number = '';
  String accountType = '';
  String edit = '';
  String appbarTitle = 'Profile';
  Color _stateColor = Colors.black;
  Icon editIcon = Icon(Icons.edit);
  final client = CloudinaryClient(
      '915364875791742', 'xXs8EIDnGzWGCFVZpr4buRyDOQk', 'mediacontrol');
  final picker = ImagePicker();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('inapp', true);
    setState(() {
      edit = 'profile';
      email = prefs.getString('email');
      avatar = prefs.getString('avatar');
      displayName = prefs.getString('displayName');
      accountType = prefs.getString('accountType');
      address = prefs.getString('address');
      state = prefs.getString('location');
      aboutme = prefs.getString('aboutme');
      number = prefs.getInt('number').toString();
      cardNumber = prefs.getString('cardNumber');
      cvvCode = prefs.getString('cvvCode');
      expiryDate = prefs.getString('expiryDate');
    });
  }

  _cardSaved() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: AppColors.purple,
        content: Text('Card details saved!')));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      key: _scaffoldKey,
      floatingActionButton: BounceInDown(
        preferences: AnimationPreferences(offset: Duration(seconds: 2)),
        child: FloatingActionButton(
          onPressed: () {
            if (edit == 'profile') {
              setState(() {
                edit = 'edit';
                appbarTitle = 'Edit Profile';
                editIcon = Icon(Icons.home);
              });
            } else {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                  (Route<dynamic> route) => false);
            }
          },
          backgroundColor: AppColors.purple,
          child: editIcon,
        ),
      ),
      appBar: classWidget.apptitleBar(context, appbarTitle),
      body: edit == 'profile' ? _profile() : _profileEdit(),
    ));
  }

  _profile() {
    Size size = MediaQuery.of(context).size;
    final node = FocusScope.of(context);
    double containerHeight = size.height * 0.25;
    double containerwidth = size.width * 0.355;
    double padding40 = size.height * 0.05;
    return WillPopScope(
      onWillPop: () {
        return Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (Route<dynamic> route) => false);
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.only(left: padding40, right: padding40),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/appimages/welcomeback.png'),
              fit: BoxFit.cover),
        ),
        child: SingleChildScrollView(
                  child: Column(children: [
              accountType == 'Freelancer'
                  ? BounceInDown(
            preferences:
                AnimationPreferences(offset: Duration(seconds: 2)),
            child: Container(
              height: containerHeight,
              width: containerwidth,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.only(topLeft: Radius.circular(70)),
                image: DecorationImage(
                  image: NetworkImage(avatar),
                  fit: BoxFit.cover,
                ),
              ),
              child: ClipRRect(
                borderRadius:
                    BorderRadius.only(topLeft: Radius.circular(70)),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: avatar,
                  placeholder: (context, url) => new Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              AppColors.purple),
                          strokeWidth: 5.0,
                        ),
                      ],
                    ),
                  ),
                  errorWidget: (context, url, error) =>
                      new Icon(Icons.error),
                ),
              ),
            ),
          )
                  : Container(),
              SlideInLeft(
                preferences: AnimationPreferences(duration: Duration(seconds: 4)),
                child: TextFormField(
                  readOnly: true,
                  initialValue: email,
                  cursorColor: AppColors.purple,
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => node.nextFocus(),
                  decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.purple)),
            labelText: 'Email',
            icon: Icon(Icons.email, color: AppColors.purple)),
                ),
              ),
              SlideInRight(
                preferences: AnimationPreferences(duration: Duration(seconds: 4)),
                child: TextFormField(
                  readOnly: true,
                  initialValue: displayName,
                  cursorColor: AppColors.purple,
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => node.nextFocus(),
                  decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.purple)),
            labelText: 'Full Name',
            icon: Icon(Icons.title, color: AppColors.purple)),
                ),
              ),
              SlideInLeft(
                preferences: AnimationPreferences(duration: Duration(seconds: 4)),
                child: TextFormField(
                  readOnly: true,
                  initialValue: number,
                  cursorColor: AppColors.purple,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => node.nextFocus(),
                  maxLength: 11,
                  decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.purple)),
            labelText: 'Phone No.',
            icon: Icon(Icons.phone, color: AppColors.purple)),
                ),
              ),
              SlideInRight(
                preferences: AnimationPreferences(duration: Duration(seconds: 4)),
                child: TextFormField(
                  readOnly: true,
                  initialValue: address,
                  cursorColor: AppColors.purple,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => node.nextFocus(),
                  decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.purple)),
            labelText: 'Address',
            icon: Icon(Icons.gps_fixed, color: AppColors.purple)),
                ),
              ),
              SlideInLeft(
                preferences: AnimationPreferences(duration: Duration(seconds: 4)),
                child: TextFormField(
                  readOnly: true,
                  initialValue: state,
                  cursorColor: AppColors.purple,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => node.nextFocus(),
                  decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.purple)),
            labelText: 'State',
            icon: Icon(Icons.location_city, color: AppColors.purple)),
                ),
              ),
              BounceInDown(
                preferences: AnimationPreferences(offset: Duration(seconds: 2)),
                child: Pulse(
                  preferences: AnimationPreferences(
                        autoPlay: AnimationPlayStates.Loop,
                        offset: Duration(seconds: 3)),
                    child: RaisedButton(
          color: AppColors.purple,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50))),
          child: Text('Save payment details',
              style: TextStyle(color: Colors.white)),
          onPressed: () {
            return showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.all(Radius.circular(20))),
                    content: StatefulBuilder(
                      builder: (context, StateSetter setState) {
                        return Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/appimages/welcomeback.png'),
                                fit: BoxFit.cover),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SlideInLeft(
                                  preferences: AnimationPreferences(
                                      offset: Duration(seconds: 1)),
                                  child: CreditCardWidget(
                                    cardNumber: cardNumber == null
                                        ? ''
                                        : cardNumber,
                                    expiryDate: expiryDate == null
                                        ? ''
                                        : expiryDate,
                                    cardHolderName: cardHolderName == null
                                        ? ''
                                        : cardHolderName,
                                    cvvCode:
                                        cvvCode == null ? '' : cvvCode,
                                    showBackView: isCvvFocused,
                                  ),
                                ),
                                SlideInRight(
                                  preferences: AnimationPreferences(
                                      offset: Duration(seconds: 1)),
                                  child: CreditCardForm(
                                    themeColor: Colors.red,
                                    onCreditCardModelChange:
                                        (CreditCardModel
                                            creditCardModel) {
                                      setState(() {
                                        cardNumber =
                                            creditCardModel.cardNumber;
                                        expiryDate =
                                            creditCardModel.expiryDate;
                                        cardHolderName = creditCardModel
                                            .cardHolderName;
                                        cvvCode = creditCardModel.cvvCode;
                                        isCvvFocused =
                                            creditCardModel.isCvvFocused;
                                      });
                                    },
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: BounceInDown(
                                    preferences: AnimationPreferences(
                                        offset: Duration(seconds: 1)),
                                    child: RaisedButton(
                                      color: AppColors.purple,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50))),
                                      child: Text('Save',
                                          style: TextStyle(
                                              color: Colors.white)),
                                      onPressed: () {
                                        saveCard();
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                });
          },
                  ),
                ),
              ),
            ]),
        ),
      ),
    );
  }

  saveCard() async {
    cardDate = expiryDate.split('/');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('cardNumber', cardNumber);
    prefs.setString('expiryDate', expiryDate);
    prefs.setString('cvvCode', cvvCode);
    prefs.setInt('expiryMonth', num.tryParse(cardDate[0]));
    prefs.setInt('expiryYear', num.tryParse(cardDate[1]));
    Navigator.pop(context);
    _cardSaved();
  }

  _profileEdit() {
    Size size = MediaQuery.of(context).size;
    final node = FocusScope.of(context);
    double fontSize15 = size.height * 0.01870;
    double padding40 = size.height * 0.05;
    return WillPopScope(
      onWillPop: () {
        return Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (Route<dynamic> route) => false);
      },
          child: Form(
        key: _formKey,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.only(left: padding40, right: padding40),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/appimages/welcomeback.png'),
                fit: BoxFit.cover),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SlideInLeft(
                  preferences:
                      AnimationPreferences(duration: Duration(seconds: 4)),
                  child: TextFormField(
                    initialValue: displayName,
                    cursorColor: AppColors.purple,
                    textCapitalization: TextCapitalization.words,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => node.nextFocus(),
                    decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.purple)),
                        labelText: 'Full Name',
                        icon: Icon(Icons.title, color: AppColors.purple)),
                    onSaved: (text) {
                      setState(() {
                        return update.name = text;
                      });
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'This field is empty';
                      }
                    },
                  ),
                ),
                SlideInRight(
                  preferences:
                      AnimationPreferences(duration: Duration(seconds: 4)),
                  child: TextFormField(
                    initialValue: number,
                    cursorColor: AppColors.purple,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => node.nextFocus(),
                    maxLength: 11,
                    decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.purple)),
                        labelText: 'Phone No.',
                        icon: Icon(Icons.phone, color: AppColors.purple)),
                    onSaved: (text) {
                      setState(() {
                        return update.number = num.tryParse(text);
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
                ),
                SlideInLeft(
                  preferences:
                      AnimationPreferences(duration: Duration(seconds: 4)),
                  child: TextFormField(
                    initialValue: address,
                    cursorColor: AppColors.purple,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => node.nextFocus(),
                    decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.purple)),
                        labelText: 'Address',
                        icon: Icon(Icons.gps_fixed, color: AppColors.purple)),
                    onSaved: (text) {
                      setState(() {
                        return update.address = text;
                      });
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'This field is empty';
                      }
                    },
                  ),
                ),
                accountType == 'Freelancer'
                    ? Column(
                        children: [
                          // TextFormField(
                          //   cursorColor: AppColors.purple,
                          //   initialValue: aboutme,
                          //   maxLines: 5,
                          //   maxLength: 400,
                          //   textInputAction: TextInputAction.next,
                          //   decoration: InputDecoration(
                          //       focusedBorder: UnderlineInputBorder(
                          //           borderSide:
                          //               BorderSide(color: AppColors.purple)),
                          //       labelText: 'About me',
                          //       icon: Icon(Icons.text_fields,
                          //           color: AppColors.purple)),
                          //   onSaved: (text) {
                          //     setState(() {
                          //       return update.aboutme = text;
                          //     });
                          //   },
                          //   validator: (value) {
                          //     if (value.isEmpty) {
                          //       return 'This field is empty';
                          //     }
                          //   },
                          // ),
                          SlideInRight(
                            preferences: AnimationPreferences(
                                duration: Duration(seconds: 4)),
                            child: Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Update your avatar',
                                  style: TextStyle(
                                      fontSize: fontSize15, color: Colors.black),
                                )),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SlideInLeft(
                            preferences: AnimationPreferences(
                                duration: Duration(seconds: 4)),
                            child: RaisedButton(
                              onPressed: () {
                                _avatarFuture();
                              },
                              color: AppColors.purple,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(150))),
                              child: Row(
                                children: [
                                  Icon(Icons.upload_file, color: Colors.white),
                                  SizedBox(
                                    width: 3,
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
                          ),
                        ],
                      )
                    : Container(),
                SlideInRight(
                  preferences:
                      AnimationPreferences(duration: Duration(seconds: 4)),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: DropdownButton<String>(
                      value: selectedState,
                      onChanged: (text) {
                        setState(() {
                          selectedState = text;
                          update.location = selectedState;
                        });
                      },
                      items: states.map<DropdownMenuItem<String>>((text) {
                        return DropdownMenuItem(
                          child: Text(
                            text,
                            style: TextStyle(
                                color: _stateColor, fontSize: fontSize15),
                          ),
                          value: text,
                        );
                      }).toList(),
                    ),
                  ),
                ),
                BounceInDown(
                  preferences: AnimationPreferences(offset: Duration(seconds: 2)),
                  child: Pulse(
                    preferences: AnimationPreferences(
                        autoPlay: AnimationPlayStates.Loop,
                        offset: Duration(seconds: 3)),
                    child: RaisedButton(
                      color: AppColors.purple,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: Text(
                        'Update',
                        style:
                            TextStyle(fontSize: fontSize15, color: Colors.white),
                      ),
                      onPressed: () {
                        final key = _formKey.currentState;
                        if (key.validate()) {
                          if (selectedState == 'Select State') {
                            setState(() {
                              _stateColor = Colors.red;
                            });
                          } else {
                            update.avatar = avatar;
                            key.save();
                            updateProfile();
                          }
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  updateProfile() {
    return showDialog(
        context: context,
        child: FutureBuilder(
            future: update.updateUser(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData == false) {
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
              }
              return Container(
                  child:
                      snapshot.data == 200 ? updateSuccess() : updateFailed());
            }));
  }

  updateSuccess() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
    });
  }

  updateFailed() {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      content: Text('Please check your internet connection'),
    );
  }

  _avatarFuture() {
    return showDialog(
        context: context,
        child: FutureBuilder(
          future: _avatarimagePicker(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
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
            } else if (snapshot.hasData) {
              avatar = snapshot.data;
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                content: Text('Avatar upload complete'),
              );
            } else
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                content: Text(
                    'Unable to upload connect, please check your connetion'),
              );
          },
        ));
  }

  _avatarimagePicker() async {
    var image = await picker.getImage(source: ImageSource.gallery);
    try {
      var response =
          await client.uploadImage(image.path, folder: 'arthub_folder');
      return response.secure_url;
    } catch (exception) {
      print(exception);
      return _scaffoldKey.currentState.showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('Something went wrong! Please try again!')));
    }
  }
}
