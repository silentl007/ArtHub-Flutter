import 'package:ArtHub/common/model.dart';
import 'package:ArtHub/screen/login.dart';
import 'package:flutter/material.dart';
import 'dart:async';

// Remove flutter rave dependency and replace with paystack
// return carpetino icons to v1.0.0
main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {'/loginscreen': (context) => LoginScreen()},
      theme: ThemeData(
        brightness: Brightness.light,
          appBarTheme: AppBarTheme(
        color: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.purple)
      )),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void startTimer() {
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacementNamed('/loginscreen');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
      child: Center(
        child: Text(
          'Loading Screen',
          style: TextStyle(fontSize: 60),
        ),
      ),
    ));
  }
}
