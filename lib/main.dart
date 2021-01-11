import 'package:ArtHub/common/model.dart';
import 'package:ArtHub/screen/homescreen.dart';
import 'package:flutter/material.dart';
import 'dart:async';

main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {'/homescreen': (context) => HomeScreen()},
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
      Navigator.of(context).pushReplacementNamed('/homescreen');
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
