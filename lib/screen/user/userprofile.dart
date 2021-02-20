import 'package:ArtHub/screen/user/editprofile.dart';
import 'package:flutter/material.dart';
import 'package:ArtHub/common/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Widgets classWidget = Widgets();
  final List<String> states = ['Select State', 'Lagos', 'Bayelsa'];
  String selectedState = 'Select State';
  String displayName = '';
  String address = '41 Road B Close Block 1 Flat 14 Festac Town';
  String number = '08038474317';
  String edit = 'profile';
  String appbarTitle = 'Profile';
  Color _stateColor = Colors.black;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    print('fetch, and read user data in pref');
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      displayName = prefs.getString('displayName');
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            edit = 'edit';
            appbarTitle = 'Edit Profile';
          });
        },
        backgroundColor: AppColors.purple,
        child: Icon(Icons.edit),
      ),
      appBar: classWidget.apptitleBar(context, appbarTitle),
      body: edit == 'profile' ? _profile() : _profileEdit(),
    ));
  }

  _title(String title) {
    return Text(title);
  }

  _content(String content) {
    return Text(content);
  }

  _profile() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/appimages/welcomeback.png'),
            fit: BoxFit.cover),
      ),
      child: Column(
        children: [
          _title('Full Name'),
          _content(displayName),
          _title('Address'),
          _content(address),
          _title('Number'),
          _content(number),
        ],
      ),
    );
  }

  _profileEdit() {
    Size size = MediaQuery.of(context).size;
    final node = FocusScope.of(context);
    double fontSize15 = size.height * 0.01870;
    double padding40 = size.height * 0.05;
    return Form(
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
            ],
          ),
        ),
      ),
    );
  }
}
