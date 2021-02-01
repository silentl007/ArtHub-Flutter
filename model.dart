import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Data {
  static List<String> states = ['Lagos', 'Abuja', 'Bayelsa', 'Benin'];
  List<Map> galleries = [
    {
      "name": "Art World",
      "code": "aw",
      "address": "Block 5 off Lakers, Lagos Island",
      "location": "Lagos State",
      "contact": "08038474317, 08033066026"
    },
    {
      "name": "World of Art",
      "code": "woa",
      "address": "House 20, Satelite Avenue, Ring Road",
      "location": "Benin State",
      "contact": "07063527397"
    },
    {
      "name": "Stooges Artistic Palace",
      "code": "sap",
      "address": "Off Houston Street, Lagos Island",
      "location": "Lagos State",
      "contact": "08038474317, 08033066026"
    },
    {
      "name": "Faux Leurve",
      "code": "fl",
      "address": "Palm Venue, Okaka, Yenagoa",
      "location": "Bayelsa State",
      "contact": "08038474317, 08033066026"
    },
  ];
  /* this item section represents a collection of galleries, first part of the map is the details of the
  gallery having name, address, and location. the second part with a list of works is what will be displayed
  if a gallery is selected. NB check the logic to specify only a gallery using name parameter.
  the logic for "items" below takes all the works and shows regardless of selected gallery. Note that */
  List<Map> items = [
    {
      'name': 'Name of the Gallery',
      'avatar': 'no avatar',
      "code": "aw", // under review or be replaced with id
      'youtube': '',
      'aboutme': '',
      "address":
          "Block 5 off Lakers, Lagos Island", // add location and contact key values, also add a list of sold items
      'works': [
        {
          'name': 'XX', // artist name
          'product': "Sunset Darkness",
          'cost': 37000,
          'type': 'painting',
          'avatar': 'assets/portraits/1/work1.jpg',
          'desc': "Pictures of Assassin's Creed",
          'description': 'lorem ipsum dolor et vet heureux enfant',
          'available': true,
          'weight': 5,
          'dimension': '100 x 300',
          'material used': 'Wood, Oil, Paint',
          'images': [
            'assets/portraits/1/work1.jpg',
            'assets/portraits/1/work2.jpg',
            'assets/portraits/1/work3.jpg',
            'assets/portraits/1/work4.jpg'
          ],
        },
        {
          'name': 'XX', // artist name
          'product': "In The Works",
          'cost': 5000,
          'type': 'painting',
          'avatar': 'assets/portraits/2/work1.jpg',
          'desc': "Pictures of Assassin's Creed",
          'description': 'lorem ipsum dolor et vet heureux enfant',
          'available': true,
          'weight': 5,
          'dimension': '100 x 300',
          'material used': 'Wood, Oil, Paint',
          'images': [
            'assets/portraits/2/work1.jpg',
            'assets/portraits/2/work2.jpg',
            'assets/portraits/2/work3.jpg',
            'assets/portraits/2/work4.jpg'
          ],
        },
        {
          'name': 'XX', // artist name
          'product': "Midnight Life",
          'cost': 6000,
          'type': 'painting',
          'avatar': 'assets/portraits/3/work1.jpg',
          'desc': "Pictures of Assassin's Creed",
          'description': 'lorem ipsum dolor et vet heureux enfant',
          'available': true,
          'weight': 5,
          'dimension': '100 x 300',
          'material used': 'Wood, Oil, Paint',
          'images': [
            'assets/portraits/3/work1.jpg',
            'assets/portraits/3/work2.jpg',
            'assets/portraits/3/work3.jpg',
            'assets/portraits/3/work4.jpg',
            'assets/portraits/3/work5.jpg'
          ],
        },
        {
          'name': 'XX', // artist name
          'product': "Meet Me Half-way",
          'cost': 7000,
          'type': 'painting',
          'avatar': 'assets/portraits/4/work1.jpg',
          'desc': "Pictures of Assassin's Creed",
          'description': 'lorem ipsum dolor et vet heureux enfant',
          'available': true,
          'weight': 5,
          'dimension': '100 x 300',
          'material used': 'Wood, Oil, Paint',
          'images': [
            'assets/portraits/4/work1.jpg',
            'assets/portraits/4/work2.jpg',
          ],
        },
        {
          'name': 'XX', // artist name
          'product': "Hello Death",
          'cost': 70000,
          'type': 'painting',
          'avatar': 'assets/portraits/5/work1.jpg',
          'desc': "Pictures of Assassin's Creed",
          'description': 'lorem ipsum dolor et vet heureux enfant',
          'available': true,
          'weight': 5,
          'dimension': '100 x 300',
          'material used': 'Wood, Oil, Paint',
          'images': [
            'assets/portraits/5/work1.jpg',
            'assets/portraits/5/work2.jpg',
            'assets/portraits/5/work3.jpg',
            'assets/portraits/5/work4.jpg'
          ],
        },
        {
          'name': 'XX',
          'product': 'Beauty in Lies',
          'cost': 4500,
          'type': 'sculptor',
          'avatar': 'assets/sculptors/1/work1.jpg',
          'desc': 'Call of Duty illustrations on canvas',
          'description': 'lorem ipsum dolor et vet heureux enfant',
          'available': true,
          'weight': 5,
          'dimension': '150 x 300',
          'material used': 'Wood, Oil, Paint',
          'images': [
            'assets/sculptors/1/work1.jpg',
            'assets/sculptors/1/work2.jpg',
            'assets/sculptors/1/work3.jpg',
            'assets/sculptors/1/work4.jpg'
          ],
        },
        {
          'name': 'XX',
          'product': 'All Around Me',
          'cost': 5800,
          'type': 'sculptor',
          'avatar': 'assets/sculptors/2/work1.jpg',
          'desc': 'Call of Duty illustrations on canvas',
          'description': 'lorem ipsum dolor et vet heureux enfant',
          'available': true,
          'weight': 5,
          'dimension': '150 x 300',
          'material used': 'Wood, Oil, Paint',
          'images': [
            'assets/sculptors/2/work1.jpg',
            'assets/sculptors/2/work2.jpg',
            'assets/sculptors/2/work3.jpg',
            'assets/sculptors/2/work4.jpg'
          ],
        },
        {
          'name': 'XX',
          'product': 'The Beginning',
          'cost': 3000,
          'type': 'sculptor',
          'avatar': 'assets/sculptors/3/work1.jpg',
          'desc': 'Call of Duty illustrations on canvas',
          'description': 'lorem ipsum dolor et vet heureux enfant',
          'available': true,
          'weight': 5,
          'dimension': '150 x 300',
          'material used': 'Wood, Oil, Paint',
          'images': [
            'assets/sculptors/3/work1.jpg',
            'assets/sculptors/3/work2.jpg',
            'assets/sculptors/3/work3.jpg',
            'assets/sculptors/3/work4.jpg'
          ],
        },
        {
          'name': 'XX',
          'product': 'Call of Duty',
          'cost': 9700,
          'type': 'sculptor',
          'avatar': 'assets/sculptors/4/work1.jpg',
          'desc': 'Call of Duty illustrations on canvas',
          'description': 'lorem ipsum dolor et vet heureux enfant',
          'available': true,
          'weight': 5,
          'dimension': '150 x 300',
          'material used': 'Wood, Oil, Paint',
          'images': [
            'assets/sculptors/4/work1.jpg',
            'assets/sculptors/4/work2.jpg',
            'assets/sculptors/4/work3.jpg',
            'assets/sculptors/4/work4.jpg',
            'assets/sculptors/4/work5.jpg'
          ],
        },
      ],
    },
  ];

  List<Map> artists = [
    {
      'name': 'Obeyi Kuzman',
      'avatar': 'assets/obeyi/avatar.png',
      'youtube': '',
      'aboutme':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt',
      "address": "41 Road B Close Block 1 Flat 14",
      'works': [
        {
          'name': 'Obeyi Kuzman',
          'product': "Essence of Life",
          'cost': 3700,
          'type': 'Painting',
          'avatar': 'assets/obeyi/1/work1.png',
          'desc': "Pictures of Assassin's Creed",
          'description': 'lorem ipsum dolor et vet heureux enfant',
          'available': true,
          'weight': 5,
          'dimension': '100 x 300',
          'material used': 'Wood, Oil, Paint',
          'images': [
            'assets/obeyi/1/work1.png',
            'assets/obeyi/1/work2.png',
            'assets/obeyi/1/work3.png',
            'assets/obeyi/1/work4.png'
          ],
        },
        {
          'name': 'Obeyi Kuzman',
          'product': 'Prisoner of Earth',
          'cost': 5000,
          'type': 'Painting',
          'avatar': 'assets/obeyi/2/work1.jpg',
          'desc': 'Call of Duty illustrations on canvas',
          'description': 'lorem ipsum dolor et vet heureux enfant',
          'available': true,
          'weight': 5,
          'dimension': '150 x 300',
          'material used': 'Wood, Oil, Paint',
          'images': [
            'assets/obeyi/2/work1.jpg',
            'assets/obeyi/2/work2.jpg',
            'assets/obeyi/2/work3.jpg',
            'assets/obeyi/2/work4.jpg'
          ],
        },
        {
          'name': 'Obeyi Kuzman',
          'product': 'Love Handle',
          'cost': 3500,
          'type': 'Painting',
          'avatar': 'assets/obeyi/3/work1.jpg',
          'desc': 'Call of Duty illustrations on canvas',
          'description': 'lorem ipsum dolor et vet heureux enfant',
          'available': true,
          'weight': 5,
          'dimension': '150 x 300',
          'material used': 'Wood, Oil, Paint',
          'images': [
            'assets/obeyi/3/work1.jpg',
            'assets/obeyi/3/work2.jpg',
            'assets/obeyi/3/work3.jpg'
          ],
        },
      ],
    },
    {
      'name': 'Yerins Abraham',
      'avatar': 'assets/yerins/avatar.png',
      'youtube': '',
      'aboutme':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt',
      "address": "House 32B Jibola Estate, Lagos Island",
      'works': [
        {
          'name': 'Yerins Abraham',
          'product': "Index",
          'cost': 15000,
          'type': 'Painting',
          'avatar': 'assets/yerins/1/index2.jpg',
          'desc': "Pictures of Assassin's Creed",
          'description': 'lorem ipsum dolor et vet heureux enfant',
          'available': true,
          'weight': 10,
          'dimension': '100 x 300',
          'material used': 'Wood, Oil, Paint',
          'images': [
            'assets/yerins/1/index1.jpg',
            'assets/yerins/1/index2.jpg',
            'assets/yerins/1/index3.jpg',
            'assets/yerins/1/index4.jpg',
          ],
        },
        {
          'name': 'Yerins Abraham',
          'product': "Index II",
          'cost': 7000,
          'type': 'Painting',
          'avatar': 'assets/yerins/2/work1.jpg',
          'desc': "Pictures of Assassin's Creed",
          'description': 'lorem ipsum dolor et vet heureux enfant',
          'available': true,
          'weight': 10,
          'dimension': '100 x 300',
          'material used': 'Wood, Oil, Paint',
          'images': [
            'assets/yerins/2/work1.jpg',
            'assets/yerins/2/work2.jpg',
            'assets/yerins/2/work3.jpg',
            'assets/yerins/2/work4.jpg',
            'assets/yerins/2/work5.jpg'
          ],
        },
      ],
    },
    {
      'name': 'Zakum Smith',
      'avatar': 'assets/zakum/avatar.png',
      'youtube': '',
      'aboutme':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt',
      "address": "House 32B Jibola Estate, Lagos Island",
      'works': [
        {
          'name': 'Zakum Smith',
          'product': "Smith and Wesson",
          'cost': 4270,
          'type': 'Sculptor',
          'avatar': 'assets/zakum/1/work1.jpg',
          'desc': "Pictures of Assassin's Creed",
          'description': 'lorem ipsum dolor et vet heureux enfant',
          'available': true,
          'weight': 5,
          'dimension': '100 x 300',
          'material used': 'Wood, Oil, Paint',
          'images': [
            'assets/zakum/1/work1.jpg',
            'assets/zakum/1/work2.jpg',
            'assets/zakum/1/work3.jpg'
                'assets/zakum/1/work4.jpg'
          ],
        },
        {
          'name': 'Zakum Smith',
          'product': 'Inception',
          'cost': 5000,
          'type': 'Painting',
          'avatar': 'assets/zakum/2/work1.jpg',
          'desc': 'Call of Duty illustrations on canvas',
          'description': 'lorem ipsum dolor et vet heureux enfant',
          'available': true,
          'weight': 5,
          'dimension': '150 x 300',
          'material used': 'Wood, Oil, Paint',
          'images': [
            'assets/zakum/2/work1.jpg',
            'assets/zakum/2/work2.jpg',
            'assets/zakum/2/work3.jpg',
            'assets/zakum/2/work4.jpg',
          ],
        },
        {
          'name': 'Zakum Smith',
          'product': 'Smith and Wesson II',
          'cost': 4500,
          'type': 'Sculptor',
          'avatar': 'assets/zakum/3/work1.jpg',
          'desc': 'Call of Duty illustrations on canvas',
          'description': 'lorem ipsum dolor et vet heureux enfant',
          'available': true,
          'weight': 5,
          'dimension': '150 x 300',
          'material used': 'Wood, Oil, Paint',
          'images': [
            'assets/zakum/3/work1.jpg',
            'assets/zakum/3/work2.jpg',
            'assets/zakum/3/work3.jpg',
            'assets/zakum/3/work4.jpg',
            'assets/zakum/3/work5.jpg',
          ],
        },
      ],
    }
  ];
}

class ParsedDataFreeLanceArts {
  String name;
  String youtube;
  String aboutme;
  String address;
  String avatar;
  List works;
  ParsedDataFreeLanceArts(
      {this.name,
      this.address,
      this.avatar,
      this.works,
      this.aboutme,
      this.youtube});
}

class ParsedDataGallery {
  String name;
  String code;
  String address;
  String location;
  String contact;
  ParsedDataGallery(
      this.name, this.code, this.address, this.location, this.contact);
}

class ParsedDataProduct {
  static const tableName = 'Cart';
  static const colID = 'id';
  static const colArtistName = 'artistname';
  static const colProductName = 'productname';
  static const colCost = 'cost';
  static const colType = 'type';
  static const colAvatar = 'avatar';
  static const colDesc = 'desc';
  static const colDescription = 'description';
  static const colAvail = 'avail';
  static const colWeight = 'weight';
  static const colDimension = 'dimension';
  static const colMaterials = 'materials';
  static const colImages = 'images';

  int id;
  String artistname;
  String productname;
  int cost;
  String type;
  String avatar;
  String desc;
  String description;
  bool avail;
  int weight;
  String dimension;
  String materials;
  List images;
  ParsedDataProduct(
      {this.id,
      this.artistname,
      this.productname,
      this.cost,
      this.type,
      this.avatar,
      this.desc,
      this.description,
      this.avail,
      this.weight,
      this.dimension,
      this.materials,
      this.images});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      colArtistName: artistname,
      colProductName: productname,
      colCost: cost,
      colType: type,
      colAvatar: avatar,
      colDesc: desc,
      colDescription: description,
      colWeight: weight,
      colDimension: dimension,
      colMaterials: materials,
    };
    if (id != null) map[colID] = id;
    return map;
  }

  ParsedDataProduct.fromMap(Map<String, dynamic> map) {
    id = map[colID];
    artistname = map[colArtistName];
    productname = map[colProductName];
    cost = map[colCost];
    type = map[colType];
    avatar = map[colAvatar];
    desc = map[colDesc];
    description = map[colDescription];
    weight = map[colWeight];
    dimension = map[colDimension];
    materials = map[colMaterials];
  }
}

class Selecteditems {
  List selecteditems = [];
}

class AppColors {
  static const red = Color.fromRGBO(239, 69, 58, 1);
  static const blue = Color.fromRGBO(58, 197, 240, 1);
  static const grey = Color.fromRGBO(232, 232, 232, 1);
  static const purple = Color.fromRGBO(69, 56, 133, 1);
  static const List hell = [];
}

class Widgets {
  Widget apptitleBar(String text) {
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.only(right: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              text,
              style: TextStyle(
                color: AppColors.purple,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerOptions {
  String option;
  Icon optionIcon;
  DrawerOptions({this.option, this.optionIcon});
}

class Registeration {
  String fullName = '';
  String email = '';
  String password = '';
  String address = '';
  String number = '';
  String location = '';
  String account = '';

  Future register(BuildContext context) async {
    String registerdbLink =
        'https://galleryapp-backend.herokuapp.com/api/signup';
    Map<String, dynamic> dataBody = {
      'name': fullName,
      'email': email,
      'password': password,
      'address': address,
      'number': number,
      'location': location,
      'account': account,
    };
    try {
      var datasend = await http.post(
        registerdbLink,
        body: dataBody,
      );
      print(datasend.statusCode);
      return showDialog(
          context: context,
          child: AlertDialog(
            content: Text('Success'),
          ));
    } catch (e) {
      print(e);
      return showDialog(
          context: context,
          child: AlertDialog(
            content: Text('Failed'),
          ));
    }
  }
}
