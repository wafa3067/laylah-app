import 'package:change_case/change_case.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:laylah/components/feed_back.dart';
import 'package:laylah/components/upload_book.dart';
import 'package:laylah/provider/AppFunctions.dart';
import 'package:laylah/screens/chat_screen.dart';
import 'package:laylah/screens/coins_screen.dart';
import 'package:laylah/screens/notification_screen.dart';
import 'package:laylah/screens/payment_screen.dart';
import 'package:laylah/screens/reward_screen.dart';
import 'package:laylah/screens/setting_screen.dart';
import 'package:laylah/screens/user_detail.dart';
import 'package:laylah/screens/welcome_screen.dart';
import 'package:laylah/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';



class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    Provider.of<AppFunctions>(context, listen: false).profileDetails();
    super.initState();
  }

  _launchFacebook() async {
    final facebookUrl =
        'https://www.facebook.com/wafaabbas.chakrani.7?mibextid=ZbWKwL'; // Replace {page_username_or_id} with the actual username or ID of the Facebook page or profile
    if (await canLaunch(facebookUrl)) {
      await launch(facebookUrl);
    } else {
      throw 'Could not launch $facebookUrl';
    }
  }

  final Uri facebook = Uri.parse(
      'https://www.facebook.com/wafaabbas.chakrani.7?mibextid=ZbWKwL');
  final Uri insta = Uri.parse('https://web.facebook.com/wafaabbas.chakrani.7');

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'awafa3067@gmail.com',
  );
  Future<void> _launchUrl(_url) async {
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,

        flexibleSpace: Container(
            decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [HexColor('#f8f2f6'),HexColor('#f8f2f6')]),
        )),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'images/logop.png',
            width: 130,
            ),
            InkWell(
              onTap: () {
                final auth = FirebaseAuth.instance;
                if (auth.currentUser != null) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RewardScreen()));
                } else {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => WelcomeScreen()));
                }
              },
              child: Image.asset(
                'images/giftboxicon.png',
                width: 30,
                height: 30,
                // color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color:   CustomColors.white,

        ),
        child: ListView(shrinkWrap: true, children: [
          Container(
            margin: EdgeInsets.all(12),
            child: Column(
              children: [
                Consumer<AppFunctions>(
                  builder: (context, myType, child) {
                    return InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>UserDetail(user_id:myType.user_id)));
                      },
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                                color: CustomColors.lightyellow, blurRadius: 1),
                          ],
                        ),
                        child:myType.profile != 'null' ? ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child:
                          Image.network(
                            '${myType.profile}',
                            fit: BoxFit.cover,
                          ),
                        ):Center(child: Text('${myType.no_photo}'.toCapitalCase(),style: GoogleFonts.roboto(fontSize: 72),)),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Consumer<AppFunctions>(
                  builder: (context, myType, child) {

                    return InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>UserDetail(user_id:myType.user_id)));
                      },
                      child: Container(
                        child: Text(
                          '${myType.displayName}'.toCapitalCase(),
                          style: GoogleFonts.roboto(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: 20,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    // gradient: LinearGradient(
                    //     colors: [CustomColors.white, CustomColors.white],
                    //     begin: Alignment.bottomLeft,
                    //     end: Alignment.topCenter)
                  ),
                  height: 110,
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                            },
                            child: Container(
                              height: 80,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),

                                    gradient: LinearGradient(
                                        colors: [
                                          CustomColors.AppColor1,
                                          CustomColors.darkpink
                                        ],
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topCenter)),
                              width: MediaQuery.of(context).size.width / 2.2,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Followers',
                                      style: GoogleFonts.ptSerif(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      '0',
                                      style: GoogleFonts.ptSerif(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ]),
                            ),
                          ),
                          InkWell(
                            onTap: () {

                            },
                            child: Container(
                              height: 80,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: LinearGradient(
                                      colors: [
                                        CustomColors.AppColor1,
                                        CustomColors.darkpink
                                      ],
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.topCenter)),
                              width: MediaQuery.of(context).size.width / 2.2,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Following',
                                      style: GoogleFonts.ptSerif(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      '0',
                                      style: GoogleFonts.ptSerif(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ]),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.only(left: 15, top: 20, right: 15),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                          colors: [  CustomColors.white,
                            CustomColors.white],
                          begin: Alignment.bottomLeft,
                          end: Alignment.topCenter)),
                  height: 81,
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              final auth = FirebaseAuth.instance;
                              if (auth.currentUser != null) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CoinsScrren()));
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WelcomeScreen()));
                              }
                            },
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: LinearGradient(
                                      colors: [
                                        CustomColors.darkpink,
                                        CustomColors.darkpink
                                      ],
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.topCenter)),
                              width: MediaQuery.of(context).size.width / 2.5,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Top up',
                                      style: GoogleFonts.ptSerif(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ]),
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>PaymentScreen()));
                            },
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: LinearGradient(
                                      colors: [
                                        CustomColors.darkpink,
                                        CustomColors.darkpink
                                      ],
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.topCenter)),
                              width: MediaQuery.of(context).size.width / 2.5,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'wallet',
                                      style: GoogleFonts.ptSerif(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ]),
                            ),
                          ),

                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                          colors: [
                            CustomColors.AppColor1,
                            CustomColors.darkpink
                          ],
                          begin: Alignment.bottomLeft,
                          end: Alignment.topCenter)),
                  child: Column(children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NotificationScreen()));
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 12),
                                child: Row(children: [
                                  Container(
                                      margin: EdgeInsets.only(right: 12),
                                      child: Icon(
                                        Icons.notifications,
                                        color: Colors.white,
                                      )),
                                  Text(
                                    'Notifications',
                                    style: GoogleFonts.ptSerif(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ]),
                              ),
                              Container(
                                  margin: EdgeInsets.only(right: 12),
                                  child: Icon(Icons.arrow_forward))
                            ],
                          )),
                    ),
                    InkWell(
                      onTap: () {
                        final auth = FirebaseAuth.instance;
                        if (auth.currentUser != null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatScreen()));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WelcomeScreen()));
                        }
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 12),
                                child: Row(children: [
                                  Container(
                                      margin: EdgeInsets.only(right: 12),
                                      child: Icon(
                                        Icons.chat,
                                        color: Colors.white,
                                      )),
                                  Text(
                                    'Chat',
                                    style: GoogleFonts.ptSerif(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ]),
                              ),
                              Container(
                                  margin: EdgeInsets.only(right: 12),
                                  child: Icon(Icons.arrow_forward))
                            ],
                          )),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UploadBook()));
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 12),
                                child: Row(children: [
                                  Container(
                                      margin: EdgeInsets.only(right: 12),
                                      child: Icon(
                                        MaterialCommunityIcons.fountain_pen,
                                        color: Colors.white,
                                      )),
                                  Text(
                                    'Become a writer',
                                    style: GoogleFonts.ptSerif(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ]),
                              ),
                              Container(
                                  margin: EdgeInsets.only(right: 12),
                                  child: Icon(Icons.arrow_forward))
                            ],
                          )),
                    ),
                    InkWell(
                      onTap: () {
                        final auth = FirebaseAuth.instance;
                        if (auth.currentUser != null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FeedBack()));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WelcomeScreen()));
                        }
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 12),
                                child: Row(children: [
                                  Container(
                                      margin: EdgeInsets.only(right: 12),
                                      child: Icon(
                                        Icons.feedback_outlined,
                                        color: Colors.white,
                                      )),
                                  Text(
                                    'Feedback',
                                    style: GoogleFonts.ptSerif(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ]),
                              ),
                              Container(
                                  margin: EdgeInsets.only(right: 12),
                                  child: Icon(Icons.arrow_forward))
                            ],
                          )),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>SettingScreen()));
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 12),
                                child: Row(children: [
                                  Container(
                                      margin: EdgeInsets.only(right: 12),
                                      child: Icon(
                                        Icons.settings,
                                        color: Colors.white,
                                      )),
                                  Text(
                                    'Setting',
                                    style: GoogleFonts.ptSerif(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ]),
                              ),
                              Container(
                                  margin: EdgeInsets.only(right: 12),
                                  child: Icon(Icons.arrow_forward))
                            ],
                          )),
                    ),
                  ]),
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    _launchUrl(insta);
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.amber,
                          gradient: LinearGradient(
                              colors: [
                                CustomColors.AppColor1,
                                CustomColors.AppColor2
                              ],
                              begin: Alignment.bottomLeft,
                              end: Alignment.topCenter)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 12),
                            child: Row(children: [
                              Container(
                                  margin: EdgeInsets.only(right: 12),
                                  child: Icon(
                                    AntDesign.instagram,
                                    color: HexColor('#E4405F'),
                                  )),
                              Text(
                                'Follow us on Instagram',
                                style: GoogleFonts.ptSerif(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ]),
                          ),
                          Container(
                              margin: EdgeInsets.only(right: 12),
                              child: Icon(Icons.arrow_forward))
                        ],
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    _launchFacebook();
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                              colors: [
                                CustomColors.mixpink,
                                CustomColors.darkpink
                              ],
                              begin: Alignment.bottomLeft,
                              end: Alignment.topCenter)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 12),
                            child: Row(children: [
                              Container(
                                  margin: EdgeInsets.only(right: 12),
                                  child: Icon(
                                    AntDesign.facebook_square,
                                    color: HexColor('#1877F2'),
                                  )),
                              Text(
                                'Follow us on Facebook',
                                style: GoogleFonts.ptSerif(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ]),
                          ),
                          Container(
                              margin: EdgeInsets.only(right: 12),
                              child: Icon(Icons.arrow_forward))
                        ],
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    _launchUrl(emailLaunchUri);
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                              colors: [
                                CustomColors.pink1,
                                CustomColors.darkbrown
                              ],
                              begin: Alignment.bottomLeft,
                              end: Alignment.topCenter)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 12),
                            child: Row(children: [
                              Container(
                                  margin: EdgeInsets.only(right: 12),
                                  child: Icon(
                                    Icons.email,
                                    color: Color.fromARGB(255, 237, 86, 75),
                                  )),
                              Text(
                                'Contact our Support system',
                                style: GoogleFonts.ptSerif(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ]),
                          ),
                          Container(
                              margin: EdgeInsets.only(right: 12),
                              child: Icon(Icons.arrow_forward))
                        ],
                      )),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
