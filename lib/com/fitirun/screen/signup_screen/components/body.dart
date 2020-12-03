import 'package:fitirun/com/fitirun/screen/home_screen/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:fitirun/com/fitirun/screen/login_screen/login_screen.dart';
import 'background.dart';
import 'or_divider.dart';
import 'social_icon.dart';
import 'package:fitirun/com/fitirun/util/already_have_an_account_acheck.dart';
import 'package:fitirun/com/fitirun/util/rounded_button.dart';
import 'package:fitirun/com/fitirun/util/rounded_input_field.dart';
import 'package:fitirun/com/fitirun/util/rounded_password_field.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "SIGNUP",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            Image.asset(
              "assets/images/signup.png",
              width: size.width * 0.35,
            ),
            RoundedInputField(
              hintText: "Your Email",
              onChanged: (value) {},
            ),
            RoundedPasswordField(
              onChanged: (value) {},
            ),
            RoundedButton(
              text: "SIGNUP",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return HomeScreen();
                    },
                  ),
                );
              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
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
            )
          ],
        ),
      ),
    );
  }
}
