import 'package:ArtHub/screen/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:ArtHub/common/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Widgets classWidget = Widgets();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<String> states = ['Select State', 'Lagos', 'Bayelsa'];
  String selectedState = 'Select State';
  String email = '';
  String displayName = '';
  String address = '41 Road B Close Block 1 Flat 14 Festac Town';
  String state = 'Lagos';
  String aboutme = 'Lorem ipsum dolor';
  String number = '08038474317';
  String customerType = '';
  String edit = '';
  String appbarTitle = 'Profile';
  Color _stateColor = Colors.black;
  Icon editIcon = Icon(Icons.edit);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();

    print('fetch, and read user data in pref');
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('inapp', true);
    setState(() {
      edit = 'profile';
      customerType = 'freelancer';
      displayName = prefs.getString('displayName');
      email = prefs.getString('email');
      // customerType = prefs.getString('customerType');
    });
  }

  _warning() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: AppColors.purple,
        content: Text('Please only edit fields you wish to change')));
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (edit == 'profile') {
            _warning();
            setState(() {
              edit = 'edit';
              appbarTitle = 'Edit Profile';
              editIcon = Icon(Icons.home);
            });
          } else {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          }
        },
        backgroundColor: AppColors.purple,
        child: editIcon,
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
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.only(left: padding40, right: padding40),
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/appimages/welcomeback.png'),
            fit: BoxFit.cover),
      ),
      child: Column(children: [
        customerType == 'freelancer'
            ? Container(
                // alignment: Alignment.topLeft,
                height: containerHeight,
                width: containerwidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(70)),
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://res.cloudinary.com/mediacontrol/image/upload/v1607425064/esr5yzvqa_ud1ibc.png'),
                    fit: BoxFit.cover,
                  ),
                ))
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
        TextFormField(
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
        customerType == 'freelancer'
            ? TextFormField(
                readOnly: true,
                cursorColor: AppColors.purple,
                initialValue: aboutme,
                maxLines: 3,
                maxLength: 400,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.purple)),
                    labelText: 'About me',
                    icon: Icon(Icons.text_fields, color: AppColors.purple)),
              )
            : Container()
      ]),
    );
  }

  _profileEdit() {
    Size size = MediaQuery.of(context).size;
    final node = FocusScope.of(context);
    double fontSize15 = size.height * 0.01870;
    double padding40 = size.height * 0.05;
    return Form(
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
                    // return registerClass.fullName = text;
                  });
                },
                validator: (value) {
                  if (value.isEmpty) {
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
                    // return registerClass.number = text;
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
                    // return registerClass.address = text;
                  });
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'This field is empty';
                  }
                },
              ),
              customerType == 'freelancer'
                  ? Column(
                      children: [
                        TextFormField(
                          cursorColor: AppColors.purple,
                          initialValue: aboutme,
                          maxLines: 5,
                          maxLength: 400,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColors.purple)),
                              labelText: 'About me',
                              icon: Icon(Icons.text_fields,
                                  color: AppColors.purple)),
                          onSaved: (text) {
                            setState(() {
                              // return registerClass.aboutme = text;
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
                            child: Text(
                              'Update your avatar',
                              style: TextStyle(
                                  fontSize: fontSize15, color: Colors.black),
                            )),
                        SizedBox(
                          height: 5,
                        ),
                        RaisedButton(
                          onPressed: () {},
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
                                    fontSize: fontSize15, color: Colors.white),
                              )
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
                      selectedState = text;
                      // registerClass.location = selectedState;
                    });
                  },
                  items: states.map<DropdownMenuItem<String>>((text) {
                    return DropdownMenuItem(
                      child: Text(
                        text,
                        style: TextStyle(color: _stateColor, fontSize: 18),
                      ),
                      value: text,
                    );
                  }).toList(),
                ),
              ),
              RaisedButton(
                color: AppColors.purple,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                child: Text(
                  'Update',
                  style: TextStyle(fontSize: fontSize15, color: Colors.white),
                ),
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
