import 'package:asset_cache/asset_cache.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laylah/components/custom_button.dart';
import 'package:laylah/components/input_password.dart';
import 'package:laylah/components/input_text.dart';
import 'package:laylah/components/inputtextdecorated.dart';
import 'package:laylah/provider/set_state_class.dart';
import 'package:laylah/screens/signin.dart';
import 'package:laylah/utils/colors.dart';
import 'package:provider/provider.dart';

import '../provider/AppFunctions.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirm_password = TextEditingController();
var background;


  Future<void> loadImage(String imageUrl) async {
    try {
      // load network image example
      await precacheImage(AssetImage(imageUrl), context);
      // or
      // Load assets image example
      // await precacheImage(AssetImage(imagePath), context);
      print('Image loaded and cached successfully!');
    } catch (e) {
      print('Failed to load and cache the image: $e');
    }
  }

  @override
  void initState() {

   loadImage('images/signup.jpg');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    late ImageProvider _signup;
    precacheImage(AssetImage('images/signup.jpg'), context);
    _signup = AssetImage('images/signup.jpg');




    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill, image: _signup)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.all(12),
              alignment: Alignment.centerLeft,
              child: Text(
                'Sign Up',
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
                placeholder: 'Email Address',
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
              child: InputPassword(
                require: true,
                text: confirm_password,
                placeholder: 'Confirm Password',
              ),
            ),
            Container(
                margin: EdgeInsets.all(8),
                child: Consumer<SetStateClass>(
                  builder: (context, myType, child) {
                    return Row(children: [
                      Container(
                        child: InkWell(
                            onTap: () {
                              if (myType.check == false) {
                                myType.SetCheckBox(true);
                              } else {
                                myType.SetCheckBox(false);
                              }
                            },
                            child: myType.check == true
                                ? Icon(Icons.check_box)
                                : Icon(Icons.check_box_outline_blank_outlined)),
                      ),
                      Container(
                        child: Text(
                            'I agree to the terms & conditions and privacy policy.'),
                      )
                    ]);
                  },
                )),
            Container(
              height: 50,
              child: CustomButton(
                color: null,
                text: "Sign Up",
                text_color: null,
                onTap: ()async {
                  var provider =
                      Provider.of<SetStateClass>(context, listen: false);
                  if (password.text.isNotEmpty &&
                      confirm_password.text.isNotEmpty &&
                      email.text.isNotEmpty &&
                      provider.check == true) {
                    if (password.text == confirm_password.text) {
                      try {
                        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                            email:email.text,
                            password: password.text
                        ).then((value) async{
                          FirebaseFirestore.instance.collection('users').doc(value.user!.uid).set({
                            'displayName':value.user!.displayName,
                            'email':value.user!.email,
                            'photoUrl':value.user!.photoURL,
                            'uid':value.user!.uid

                          });
                      return   await Navigator.push(context, MaterialPageRoute(builder: (context)=>SignIn()));
                        });

                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: CustomColors.AppColor1,
                              content: Text(
                                  'your password length must be 6 or greater ')));
                        } else if (e.code == 'email-already-in-use') {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: CustomColors.AppColor1,
                              content: Text(
                                  'Email is already registered goto login ')));
                        }
                      } catch (e) {

                      }
                    }
                    else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: CustomColors.AppColor1,
                          content: Text(
                              ' Password and confirm password fields value must be matched')));
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
        Consumer<AppFunctions>(
        builder: (context, myType, child) {
           return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  child: InkWell(
                    onTap: (){
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
                    onTap:(){
                      myType.signInWithFacebook(context);
                    },
                    child:Icon(Icons.facebook,size: 50,color: Colors.blue,),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                InkWell(
                  onTap:(){
                    myType.AppleSignIn(context);
                  },
                  child: Container(

                    child: Icon(Icons.apple,size:55),
                  ),
                ),

              ],
            );})
          ],
        ),
      ),
    );
  }
}
