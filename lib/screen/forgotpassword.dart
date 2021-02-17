import 'package:flutter/material.dart';
import 'package:ArtHub/common/model.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  Widgets classWidget = Widgets();

  ResetPassword resetClass = ResetPassword();

  var emailText = TextEditingController();

  final textKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: classWidget.apptitleBar(context, 'Forgot Password'),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/appimages/welcomeback.png'),
                  fit: BoxFit.cover)),
          child: Form(
            key: textKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    width: 300,
                    child: TextFormField(
                      controller: emailText,
                      decoration: InputDecoration(
                          labelText: 'Email', icon: Icon(Icons.email)),
                      validator: (text) {
                        if (text.length == 0) {
                          return 'This field is empty';
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(height: 5,),
                RaisedButton(
                  onPressed: () {
                    var keyform = textKey.currentState;
                    if (keyform.validate()) {
                      resetClass.email = emailText.text;
                      futureDiag(context);
                    }
                  },
                  child: Text(
                    'Reset',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                  color: AppColors.purple,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  futureDiag(BuildContext context) {
    return showDialog(
        context: context,
        child: FutureBuilder(
            future: resetClass.reset(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData == false) {
                return AlertDialog(
                  content: LinearProgressIndicator(
                    backgroundColor: Colors.white,
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(AppColors.purple),
                  ),
                );
              }
              return Container(
                child: snapshot.data == 200 ? _resetPass() : _resetFailed(),
              );
            }));
  }

  _resetPass() {
    return AlertDialog(
      content: Text('Password reset has been sent to your email'),
    );
  }

  _resetFailed() {
    return AlertDialog(
      content: Text('Unable to reset password'),
    );
  }
}
