import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:laylah/components/custom_button.dart';
import 'package:laylah/screens/signin.dart';
import 'package:laylah/screens/signup.dart';
import 'package:laylah/utils/colors.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {

    precacheImage(AssetImage('images/l.png'), context);
    precacheImage(AssetImage('images/laylah.png'), context);

    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [HexColor('#f8c8d6'), HexColor('#c580b1')],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
          ),
            // image: DecorationImage(
            //     image: _logo,
            //     fit: BoxFit.fill)
          ),
          child: SafeArea(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Container(
                  //   child: Image.asset('images/logo.jpeg'),
                  // ),
                  Container(
                    // height: MediaQuery.of(context).size.height/1.5,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                          // margin: EdgeInsets.only(left: 35),
                          // width: MediaQuery.of(context).size.width,
                          child: Center(
                              child: Image.asset(
                            'images/l.png',
                            width: 100,
                          )),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Text(
                                'Welcome to ',
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 25,
                                    color: CustomColors.black),
                              ),
                            ),
                            Container(
                              child: Image.asset(
                                width: 130,
                                height: 40,
                                'images/laylah.png',
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: EdgeInsets.all(2),
                          // padding: EdgeInsets.all(12),
                          child: Text(
                            'Create an account or sign in to unlock your pocket library',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: CustomColors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    // height: MediaQuery.of(context).size.height/3.5,
                    child: Column(children: [
                      CustomButton(
                        width: MediaQuery.of(context).size.width - 50,
                        color: null,
                        text: 'Sign Up',
                        text_color: null,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUp()));
                        },
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      CustomButton(
                        width: MediaQuery.of(context).size.width - 50,
                        gr_color1: CustomColors.white,
                        gr_color2: CustomColors.white,
                        color: Colors.red,
                        text: 'Sign In',
                        text_color: Colors.black,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignIn()));
                        },
                      ),
                    ]),
                  )
                ]),
          )),
    );
  }
}
