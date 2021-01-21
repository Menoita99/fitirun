import 'package:fitirun/com/fitirun/util/costum_widget/rounded_input_field.dart';
import 'package:fitirun/com/fitirun/util/services/auth.dart';
import 'package:fitirun/com/fitirun/util/services/database.dart';
import 'package:flutter/material.dart';
import 'background.dart';
import 'file:///C:/Users/rui.menoita/StudioProjects/fitirun/lib/com/fitirun/util/costum_widget/already_have_an_account_acheck.dart';
import 'file:///C:/Users/rui.menoita/StudioProjects/fitirun/lib/com/fitirun/util/costum_widget/rounded_button.dart';
import 'file:///C:/Users/rui.menoita/StudioProjects/fitirun/lib/com/fitirun/util/costum_widget/rounded_password_field.dart';

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
              "SIGNUP",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              hintText: "Your Email",
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
            RoundedPasswordField(
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
            ),
            RoundedButton(
              text: "SIGNUP",
              press: () async {
                if (true) { // TODO: Check if the form is valid
                  print(email);
                  print(password);
                  dynamic user = await _authService.registerWithEmailAndPassword(email, password); // return UserModel if successful, returns null if not
                  if(user == null){
                    setState(() {
                      error = "Error creating account";
                    });
                  }else{
                    DatabaseService().addOrUpdateUser(user);
                    Navigator.popAndPushNamed(context, '/home');
                  }
                }
              },
            ),
            SizedBox(height: size.height * 0.03),
            Text(error, style: TextStyle(color: Colors.red, fontSize: 14.0),),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.popAndPushNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}
