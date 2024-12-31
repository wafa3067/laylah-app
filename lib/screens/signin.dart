import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laylah/components/custom_button.dart';
import 'package:laylah/components/input_password.dart';
import 'package:laylah/components/input_text.dart';
import 'package:laylah/components/inputtextdecorated.dart';
import 'package:laylah/provider/set_state_class.dart';
import 'package:laylah/screens/home_screen.dart';
import 'package:laylah/screens/main_page.dart';
import 'package:laylah/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_apple/firebase_ui_oauth_apple.dart';
import 'package:sign_in_with_apple_js/sign_in_with_apple_js.dart';

import '../auth/apple_signUp.dart';
import '../provider/AppFunctions.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirm_password = TextEditingController();

  final AppleSignIn appleSignIn = AppleSignIn('com.app.laylah');

  @override
  Widget build(BuildContext context) {
    late ImageProvider _sign;
    precacheImage(AssetImage('images/signup.jpg'), context);
    _sign = AssetImage('images/signup.jpg');

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(fit: BoxFit.fill, image: _sign)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.all(12),
              alignment: Alignment.centerLeft,
              child: Text(
                'Sign In',
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: CustomColors.AppColor1),
              ),
            ),
            Container(
              child: InputTextDecorated(
                require: true,
                text: email,
                placeholder: ' Email Address',
              ),
            ),
            Container(
              child: InputPassword(
                require: true,
                text: password,
                placeholder: 'Password',
              ),
            ),
            Container(
              height: 50,
              child: CustomButton(
                color: null,
                text: "Sign In",
                text_color: null,
                onTap: () async {
                  var provider =
                      Provider.of<SetStateClass>(context, listen: false);
                  if (password.text.isNotEmpty && email.text.isNotEmpty) {
                    try {
                      UserCredential userCredential = await FirebaseAuth
                          .instance
                          .signInWithEmailAndPassword(
                              email: email.text, password: password.text);
                      var storage = FlutterSecureStorage();
                      await storage.write(
                          key: 'uid', value: userCredential.user!.uid);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MainPage()));
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: CustomColors.AppColor1,
                            content: Text('No user found for that email.')));
                      } else if (e.code == 'wrong-password') {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: CustomColors.AppColor1,
                            content: Text(
                                'Wrong password provided for that user.')));
                      }
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: CustomColors.AppColor1,
                        content: Text('Please enter email and password')));
                  }
                },
                width: MediaQuery.of(context).size.width - 50,
              ),
            ),
            Container(
              margin: EdgeInsets.all(5),
              child: Divider(
                thickness: 3,
                color: CustomColors.AppColor2,
              ),
            ),
            Consumer<AppFunctions>(builder: (context, myType, child) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    child: InkWell(
                      onTap: () {
                        myType.GoogleLogin(context);
                      },
                      child: Image.asset(
                        'images/google.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                    // height: 55,
                    width: 65,
                    child: InkWell(
                      onTap: () {
                        myType.signInWithFacebook(context);
                      },
                      child: Icon(
                        Icons.facebook,
                        size: 50,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
//                       Container(
//                         height: 50,
// width:60,
//                         child:   SignInWithAppleButton(
//                           borderRadius:BorderRadius.circular(50),
//                           height:50,
//
// iconAlignment:IconAlignment.left,
//                           onPressed: ()  {
//                            myType.AppleSignIn(context);
//
//                             // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
//                             // after they have been validated with Apple (see `Integration` section for more information on how to do this)
//                           },
//
//                         )
                  InkWell(
                    onTap: () async {
                      // myType.AppleSignIn(context);
                      SignInResponseI response = await signInWithApple();
                      print("response $response");
                    },
                    child: Container(
                      child: Icon(Icons.apple, size: 55),
                    ),
                  ),
                ],
              );
            })
          ],
        ),
      ),
    );
  }
}
