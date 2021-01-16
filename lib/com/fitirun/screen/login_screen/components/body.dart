import 'package:fitirun/com/fitirun/util/services/auth.dart';
import 'package:flutter/material.dart';
import 'background.dart';
import 'package:fitirun/com/fitirun/util/already_have_an_account_acheck.dart';
import 'package:fitirun/com/fitirun/util/rounded_button.dart';
import 'package:fitirun/com/fitirun/util/rounded_input_field.dart';
import 'package:fitirun/com/fitirun/util/rounded_password_field.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "LOGIN",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              hintText: "Your Email",
              onChanged: (value) {},
            ),
            RoundedPasswordField(
              onChanged: (value) {},
            ),
            RoundedButton(
              text: "LOGIN",
              press: () async {
                dynamic result = await _authService.signInAnon();
                if(result == null){
                  print("error signing in annon");
                }else {
                  print("Signed in");
                  print(result);
                }
                Navigator.popAndPushNamed(context, '/home');
              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.popAndPushNamed(context, '/signup');
              },
            ),
          ],
        ),
      ),
    );
  }
}