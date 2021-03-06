import 'package:fitirun/com/fitirun/screen/login_screen/components/or_divider.dart';
import 'package:fitirun/com/fitirun/screen/login_screen/components/social_icon.dart';
import 'package:fitirun/com/fitirun/util/costum_widget/already_have_an_account_acheck.dart';
import 'package:fitirun/com/fitirun/util/costum_widget/rounded_button.dart';
import 'package:fitirun/com/fitirun/util/costum_widget/rounded_input_field.dart';
import 'package:fitirun/com/fitirun/util/costum_widget/rounded_password_field.dart';
import 'package:fitirun/com/fitirun/util/services/auth.dart';
import 'package:flutter/material.dart';
import 'background.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final AuthService _authService = AuthService();
  String email = '';
  String password = '';
  String error = '';

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
              onChanged: (value) {
                setState(
                    () => email = value
                );
              },
            ),
            RoundedPasswordField(
              onChanged: (value) {
                setState(
                        () => password = value
                );
              },
            ),
            RoundedButton(
              text: "LOGIN",
              press: () async {
                if (true) { // TODO: Validate the form
                  print(email);
                  print(password);
                  dynamic user = await _authService.loginWithEmailAndPassword(email, password); // return User if successful, returns null if not
                  if(user == null){
                    setState(() {
                      error = "Error login in";
                    });
                  }else{
                    Navigator.popAndPushNamed(context, '/home');
                    print(user.uid);
                  }
                }
              },
            ),
            SizedBox(height: size.height * 0.03),
            Text(error, style: TextStyle(color: Colors.red, fontSize: 14.0),),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.popAndPushNamed(context, '/signup');
              },
            ),
            OrDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SocalIcon(
                  iconSrc: "assets/icons/facebook.png",
                  press: () {},
                ),
                SocalIcon(
                  iconSrc: "assets/icons/twitter.png",
                  press: () {},
                ),
                SocalIcon(
                  iconSrc: "assets/icons/google-plus.png",
                  press: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}