import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:laylah/provider/AppFunctions.dart';
import 'package:laylah/screens/order_succesfull.dart';
import 'package:laylah/screens/signin.dart';
import 'package:laylah/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:laylah/provider/set_state_class.dart';
import 'package:sign_in_with_apple_js/sign_in_with_apple_js.dart';
import 'components/CustomCirve.dart';
import 'components/unlock_component.dart';
import 'firebase_options.dart';
import 'package:firebase_admin/firebase_admin.dart' as auth;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // initSignInWithApple(ClientConfigI(
  //   clientId: 'ZT8S3QMMTY', // required (Apple ServiceID)
  //   redirectURI:
  //       'https://laylah-cf6ac.firebaseapp.com/__/auth/handler', // required
  //   scope: 'name email', // space-delimited list (i.e. "name email")
  //   // state: [STATE],
  //   // nonce: [NONCE]
  //   usePopup: true, // defaults to false
  // ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
 
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<SetStateClass>(
            create: (context) => SetStateClass(),
          ),
          ChangeNotifierProvider<AppFunctions>(
            create: (context) => AppFunctions(),
          )
        ],
        child: MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: SplashScreen()));
  }
}
