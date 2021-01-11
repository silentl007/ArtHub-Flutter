import 'package:flutter/material.dart';

class Data {
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

  List<Map> items = [
    {
      'name': 'Yerins Abraham',
      'avatar': 'assets/yerins/yerins.png',
      "code": "aw",
      'youtube': '',
      'aboutme': '',
      "address": "Block 5 off Lakers, Lagos Island",
      'works': [
        {
          'name': 'Yerins Abraham',
          'product': "Assassin's Creed Valhala",
          'cost': 370000,
          'type': 'painting',
          'avatar': 'assets/ac/test1.jpg',
          'desc': "Pictures of Assassin's Creed",
          'description': 'lorem ipsum dolor et vet heureux enfant',
          'available': true,
          'weight': 5,
          'dimension': '100 x 300',
          'material used': 'Wood, Oil, Paint',
          'images': [
            'assets/ac/t1.jpg',
            'assets/ac/t2.jpg',
            'assets/ac/t3.jpg'
          ],
        },
        {
          'name': 'Yerins Abraham',
          'product': 'Call of Duty',
          'cost': 500,
          'type': 'sculptor',
          'avatar': 'assets/cod/test1.jpg',
          'desc': 'Call of Duty illustrations on canvas',
          'description': 'lorem ipsum dolor et vet heureux enfant',
          'available': true,
          'weight': 5,
          'dimension': '150 x 300',
          'material used': 'Wood, Oil, Paint',
          'images': [
            'assets/cod/t1.jpg',
            'assets/cod/t2.jpg',
            'assets/cod/t3.jpg'
          ],
        },
      ],
    },
    {
      'name': 'Jenkins Wiggins',
      'youtube': '',
      "code": "aw",
      'aboutme': '',
      "address": "House 20, Satelite Avenue, Ring Road",
      'avatar': '',
      'works': [
        {
          'name': 'Jenkins Wiggins',
          'product': 'V for Vendetta',
          'cost': 360,
          'type': 'painting',
          'avatar': 'assets/v/test1.jpg',
          'desc': 'A logo of bad boy',
          'description': 'lorem ipsum dolor et vet heureux enfant',
          'available': true,
          'weight': 5,
          'dimension': '200 x 300',
          'material used': "Wood, Oil, Paint",
          'images': [
            'assets/v/t1.jpg',
            'assets/v/t2.jpg',
            'assets/v/t3.jpg',
            'assets/v/t4.jpg'
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
          'cost': 370,
          'type': 'painting',
          'avatar': 'assets/obeyi/work1.png',
          'desc': "Pictures of Assassin's Creed",
          'description': 'lorem ipsum dolor et vet heureux enfant',
          'available': true,
          'weight': 5,
          'dimension': '100 x 300',
          'material used': 'Wood, Oil, Paint',
          'images': [
            'assets/obeyi/work1.png',
            'assets/obeyi/work2.png',
            'assets/obeyi/work3.png',
            'assets/obeyi/work4.png'
          ],
        },
        {
          'name': 'Obeyi Kuzman',
          'product': 'Prisoner',
          'cost': 500,
          'type': 'sculptor',
          'avatar': 'assets/obeyi/work2.png',
          'desc': 'Call of Duty illustrations on canvas',
          'description': 'lorem ipsum dolor et vet heureux enfant',
          'available': true,
          'weight': 5,
          'dimension': '150 x 300',
          'material used': 'Wood, Oil, Paint',
          'images': [
            'assets/obeyi/work1.png',
            'assets/obeyi/work2.png',
            'assets/obeyi/work3.png',
            'assets/obeyi/work4.png'
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
          'product': "Index Numero Uno",
          'cost': 150000,
          'type': 'painting',
          'avatar': 'assets/yerins/index2.jpg',
          'desc': "Pictures of Assassin's Creed",
          'description': 'lorem ipsum dolor et vet heureux enfant',
          'available': true,
          'weight': 5,
          'dimension': '100 x 300',
          'material used': 'Wood, Oil, Paint',
          'images': [
            'assets/yerins/index1.jpg',
            'assets/yerins/index2.jpg',
            'assets/yerins/index3.jpg',
            'assets/yerins/index4.jpg'
          ],
        },
        {
          'name': 'Yerins Abraham',
          'product': 'Index II',
          'cost': 500,
          'type': 'sculptor',
          'avatar': 'assets/obeyi/work2.png',
          'desc': 'Call of Duty illustrations on canvas',
          'description': 'lorem ipsum dolor et vet heureux enfant',
          'available': true,
          'weight': 5,
          'dimension': '150 x 300',
          'material used': 'Wood, Oil, Paint',
          'images': [
            'assets/obeyi/work1.png',
            'assets/obeyi/work2.png',
            'assets/obeyi/work3.png',
            'assets/obeyi/work4.png'
          ],
        },
        {
          'name': 'Yerins Abraham',
          'product': 'Index II',
          'cost': 500,
          'type': 'sculptor',
          'avatar': 'assets/obeyi/work2.png',
          'desc': 'Call of Duty illustrations on canvas',
          'description': 'lorem ipsum dolor et vet heureux enfant',
          'available': true,
          'weight': 5,
          'dimension': '150 x 300',
          'material used': 'Wood, Oil, Paint',
          'images': [
            'assets/obeyi/work1.png',
            'assets/obeyi/work2.png',
            'assets/obeyi/work3.png',
            'assets/obeyi/work4.png'
          ],
        },
        {
          'name': 'Yerins Abraham',
          'product': "Index",
          'cost': 370,
          'type': 'painting',
          'avatar': 'assets/obeyi/work1.png',
          'desc': "Pictures of Assassin's Creed",
          'description': 'lorem ipsum dolor et vet heureux enfant',
          'available': true,
          'weight': 5,
          'dimension': '100 x 300',
          'material used': 'Wood, Oil, Paint',
          'images': [
            'assets/obeyi/work1.png',
            'assets/obeyi/work2.png',
            'assets/obeyi/work3.png',
            'assets/obeyi/work4.png'
          ],
        }
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
          'cost': 370,
          'type': 'painting',
          'avatar': 'assets/zakum/work1.png',
          'desc': "Pictures of Assassin's Creed",
          'description': 'lorem ipsum dolor et vet heureux enfant',
          'available': true,
          'weight': 5,
          'dimension': '100 x 300',
          'material used': 'Wood, Oil, Paint',
          'images': [
            'assets/zakum/work1.png',
            'assets/zakum/work2.png',
          ],
        },
        {
          'name': 'Zakum Smith',
          'product': 'Smith and Wesson II',
          'cost': 500,
          'type': 'sculptor',
          'avatar': 'assets/zakum/work2.png',
          'desc': 'Call of Duty illustrations on canvas',
          'description': 'lorem ipsum dolor et vet heureux enfant',
          'available': true,
          'weight': 5,
          'dimension': '150 x 300',
          'material used': 'Wood, Oil, Paint',
          'images': [
            'assets/obeyi/work1.png',
            'assets/obeyi/work2.png',
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
  ParsedDataGallery(this.name, this.code, this.address, this.location, this.contact);
}

class ParsedDataProduct {
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
      this.images);
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
