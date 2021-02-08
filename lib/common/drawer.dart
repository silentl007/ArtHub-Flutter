import 'package:flutter/material.dart';
import 'package:ArtHub/common/model.dart';

class DrawerWidget extends StatelessWidget {
  final String userName;
  DrawerWidget({this.userName});
  List<DrawerOptions> options = [
    DrawerOptions(option: 'Profile', optionIcon: Icon(Icons.person)),
    DrawerOptions(option: 'Orders', optionIcon: Icon(Icons.shopping_cart)),
    DrawerOptions(option: 'Settings', optionIcon: Icon(Icons.settings)),
    DrawerOptions(option: 'Contact Us', optionIcon: Icon(Icons.contact_phone)),
    DrawerOptions(option: 'About Us', optionIcon: Icon(Icons.help_outline)),
  ];
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: Column(
          children: [
            DrawerHeader(child: null),
            Divider(height: 5, color: AppColors.purple,),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(100),
                ),
                image: DecorationImage(
                    image: AssetImage('assets/appimages/welcomeback.png'),
                    fit: BoxFit.cover),
              ),
              child: Column(
                children: options
                    .map((data) => ListTile(
                          tileColor: Colors.transparent,
                          title: Text(
                            data.option,
                            textAlign: TextAlign.justify,
                            style: TextStyle(fontSize: 20),
                          ),
                          leading: data.optionIcon,
                          onTap: ()=>purchase(context),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
  purchase(BuildContext context) {
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
