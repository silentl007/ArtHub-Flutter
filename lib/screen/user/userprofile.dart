import 'package:art_hub/screen/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:art_hub/common/model.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Widgets classWidget = Widgets();
  List cardDate = [];
  UpdateProfile update = UpdateProfile();
  final _formKey = GlobalKey<FormState>();
  final _cardKey = GlobalKey<FormState>();
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
  final cloudinary = CloudinaryPublic('mediacontrol', 'ArtHub', cache: false);
  // final client = CloudinaryClient(
  //     '915364875791742', 'xXs8EIDnGzWGCFVZpr4buRyDOQk', 'mediacontrol');
  final picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('inapp', true);
    setState(() {
      edit = 'profile';
      email = prefs.getString('email')!;
      avatar = prefs.getString('avatar')!;
      displayName = prefs.getString('displayName')!;
      accountType = prefs.getString('accountType')!;
      address = prefs.getString('address')!;
      state = prefs.getString('location')!;
      aboutme = prefs.getString('aboutme')!;
      number = prefs.getInt('number').toString();
      cardNumber = prefs.getString('cardNumber')!;
      cvvCode = prefs.getString('cvvCode')!;
      expiryDate = prefs.getString('expiryDate')!;
    });
  }

  _cardSaved() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: AppColors.purple,
        content: Text('Card details saved!')));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: Texts.textScale),
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
      ),
    ));
  }

  _profile() {
    final node = FocusScope.of(context);
    Sizes().heightSizeCalc(context);
    Sizes().widthSizeCalc(context);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (Route<dynamic> route) => false);
        return true;
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.only(left: Sizes.w40, right: Sizes.w40),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/appimages/welcomeback.png'),
              fit: BoxFit.cover),
        ),
        child: SingleChildScrollView(
          child: Column(children: [
            accountType == 'Freelancer'
                ? Container(
                    height: Sizes.h200,
                    width: Sizes.w150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(Sizes.w70)),
                      image: DecorationImage(
                        image: NetworkImage(avatar),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(Sizes.w70)),
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
                  )
                : Container(),
            TextFormField(
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
            TextFormField(
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
            TextFormField(
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
            TextFormField(
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
            BounceInDown(
              preferences: AnimationPreferences(offset: Duration(seconds: 2)),
              child: Pulse(
                preferences: AnimationPreferences(
                    autoPlay: AnimationPlayStates.Loop,
                    offset: Duration(seconds: 3)),
                child: ElevatedButton(
                  style: Decorations().buttonDecor(
                    context: context,
                  ),
                  child: Decorations().buttonText(
                      buttonText: 'Save payment details', context: context),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(Sizes.w20))),
                            content: StatefulBuilder(
                              builder: (context, StateSetter setState) {
                                return Container(
                                  height: Sizes.h600,
                                  width: Sizes.w250,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/appimages/welcomeback.png'),
                                        fit: BoxFit.cover),
                                  ),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        CreditCardWidget(
                                          cardNumber: cardNumber,
                                          expiryDate: expiryDate,
                                          cardHolderName: cardHolderName,
                                          cvvCode: cvvCode,
                                          showBackView: isCvvFocused,
                                          onCreditCardWidgetChange:
                                              (CreditCardBrand brand) {},
                                        ),
                                        CreditCardForm(
                                          formKey: _cardKey,
                                          themeColor: Colors.red,
                                          cardNumber: cardNumber,
                                          expiryDate: expiryDate,
                                          cardHolderName: cardHolderName,
                                          cvvCode: cvvCode,
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
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: BounceInDown(
                                            preferences: AnimationPreferences(
                                                offset: Duration(seconds: 1)),
                                            child: ElevatedButton(
                                              style: Decorations().buttonDecor(
                                                context: context,
                                              ),
                                              child: Decorations().buttonText(
                                                  buttonText: 'Save',
                                                  context: context),
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
    prefs.setInt('expiryMonth', int.tryParse(cardDate[0])!);
    prefs.setInt('expiryYear', int.tryParse(cardDate[1])!);
    Navigator.pop(context);
    _cardSaved();
  }

  _profileEdit() {
    final node = FocusScope.of(context);
    Sizes().heightSizeCalc(context);
    Sizes().widthSizeCalc(context);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (Route<dynamic> route) => false);
        return true;
      },
      child: Form(
        key: _formKey,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.only(left: Sizes.w40, right: Sizes.w40),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/appimages/welcomeback.png'),
                fit: BoxFit.cover),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
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
                      update.name = text;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'This field is empty';
                    }
                  },
                ),
                TextFormField(
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
                      update.number = int.tryParse(text!);
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'This field is empty';
                    } else if (value.length != 11) {
                      return 'The number is not complete';
                    }
                  },
                ),
                TextFormField(
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
                      update.address = text;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'This field is empty';
                    }
                  },
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
                          Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Update your avatar',
                                style: TextStyle(
                                    fontSize: Sizes.w15, color: Colors.black),
                              )),
                          SizedBox(
                            height: Sizes.h5,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _avatarFuture();
                            },
                            style: Decorations().buttonDecor(
                                context: context, borderRadius: Sizes.w150),
                            child: Row(
                              children: [
                                Icon(Icons.upload_file, color: Colors.white),
                                SizedBox(
                                  width: Sizes.w4,
                                ),
                                Decorations().buttonText(
                                    buttonText: 'Upload', context: context)
                              ],
                            ),
                          ),
                        ],
                      )
                    : Container(),
                Container(
                  alignment: Alignment.centerLeft,
                  child: DropdownButton<String>(
                    value: selectedState,
                    onChanged: (text) {
                      setState(() {
                        selectedState = text!;
                        update.location = selectedState;
                      });
                    },
                    items: states.map<DropdownMenuItem<String>>((text) {
                      return DropdownMenuItem(
                        child: Text(
                          text,
                          style: TextStyle(
                              color: _stateColor, fontSize: Sizes.w15),
                        ),
                        value: text,
                      );
                    }).toList(),
                  ),
                ),
                BounceInDown(
                  preferences:
                      AnimationPreferences(offset: Duration(seconds: 2)),
                  child: Pulse(
                    preferences: AnimationPreferences(
                        autoPlay: AnimationPlayStates.Loop,
                        offset: Duration(seconds: 3)),
                    child: ElevatedButton(
                      style: Decorations().buttonDecor(
                        context: context,
                      ),
                      child: Decorations()
                          .buttonText(buttonText: 'Update', context: context),
                      onPressed: () {
                        final key = _formKey.currentState;
                        if (key!.validate()) {
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
    Sizes().heightSizeCalc(context);
    Sizes().widthSizeCalc(context);
    return showDialog(
        context: context,
        builder: (context) {
          return FutureBuilder(
              future: update.updateUser(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData == false) {
                  return Container(
                    color: Colors.transparent,
                    child: AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(Sizes.w20))),
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
                        ? updateSuccess()
                        : updateFailed());
              });
        });
  }

  updateSuccess() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
    });
  }

  updateFailed() {
    Sizes().heightSizeCalc(context);
    Sizes().widthSizeCalc(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(Sizes.w20))),
      content: Text('Please check your internet connection'),
    );
  }

  _avatarFuture() {
    Sizes().heightSizeCalc(context);
    Sizes().widthSizeCalc(context);
    return showDialog(
        context: context,
        builder: (context) {
          return FutureBuilder(
            future: _avatarimagePicker(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Container(
                  color: Colors.transparent,
                  child: AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.all(Radius.circular(Sizes.w20))),
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
                      borderRadius:
                          BorderRadius.all(Radius.circular(Sizes.w20))),
                  content: Text('Avatar upload complete'),
                );
              } else
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(Sizes.w20))),
                  content: Text(
                      'Unable to upload connect, please check your connetion'),
                );
            },
          );
        });
  }

  _avatarimagePicker() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    try {
      var response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(image!.path, folder: 'arthub_folder'),
      );
      return response.secureUrl;
    } catch (exception) {
      print(exception);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('Something went wrong! Please try again!')));
    }
  }
}
