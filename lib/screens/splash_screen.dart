import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:laylah/provider/AppFunctions.dart';
import 'package:laylah/screens/home_screen.dart';
import 'package:laylah/screens/main_page.dart';
import 'package:laylah/screens/signup.dart';
import 'package:laylah/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var storage = FlutterSecureStorage();
  UserCheck() async {
    var user_id = await storage.read(key: 'uid');
    final provider = Provider.of<AppFunctions>(context, listen: false);
    provider.GetUserId();


    Future.delayed(Duration(seconds: 3), () {
      if (user_id != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MainPage()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
      }
    });
  }

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
    UserCheck();
    loadImage('images/l.png');
    loadImage('images/laylah.png');
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return  SafeArea(child:
    Scaffold(
      body: Container(
        width:  MediaQuery.of(context).size.width,
        decoration: BoxDecoration(gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [HexColor('#f7c6d6'),HexColor('#c581b1')])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: 100,
                child: Center(child: Image.asset('images/l.png',fit: BoxFit.fill,))),
            SizedBox(height: 15,),
            Container(
                width:300,
                margin: EdgeInsets.symmetric(horizontal: 30),
                // width: 100,
                child: Center(child: Image.asset('images/laylah.png',fit: BoxFit.fill,))),
            SizedBox(height: 15,),
            Container(child: Text('Read Anytime, AnyWhere'.toUpperCase(),style: GoogleFonts.roboto(color: Colors.white,fontSize: 14),),)
          ],
        ),
      ),
    ));
  }
}
