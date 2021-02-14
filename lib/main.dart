import 'package:ArtHub/common/model.dart';
import 'package:ArtHub/screen/homescreen.dart';
import 'package:ArtHub/screen/login.dart';
import 'package:flutter/material.dart';

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
      theme: ThemeData(
          // brightness: Brightness.dark,
          appBarTheme: AppBarTheme(
              color: Colors.white,
              elevation: 0,
              iconTheme: IconThemeData(color: AppColors.purple))),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Login loginClass = Login();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: loginClass.login(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return _loadingScreen();
            } else if (snapshot.data == 200) {
              _loginSuccess();
              return Container();
            } else {
              _loginFailed();
              return Container();
            }
          },
        ),
      ),
    );
  }

  _loadingScreen() {
    return Stack(
      children: [
        Opacity(
          opacity: .25,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/appimages/splash.jpg'),
                  fit: BoxFit.cover),
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(AppColors.purple),
                strokeWidth: 9.0,
              ),
            ],
          ),
        ),
      ],
    );
  }

  _loginSuccess() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pop(context);
      return Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    });
  }

  _loginFailed() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pop(context);
      return Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    });
  }
}
