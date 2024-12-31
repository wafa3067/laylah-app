import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admin/firebase_admin.dart';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:laylah/ads/ads_class.dart';

import 'package:laylah/components/reward_card_design.dart';
import 'package:laylah/provider/AppFunctions.dart';
import 'package:laylah/provider/set_state_class.dart';
import 'package:laylah/screens/coins_screen.dart';

import 'package:laylah/screens/reader_screen.dart';
import 'package:laylah/screens/user_comment_screen.dart';
import 'package:laylah/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../components/custom_button.dart';

class RewardScreen extends StatefulWidget {
  const RewardScreen({super.key});

  @override
  State<RewardScreen> createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> {
  List Coins = [15, 29, 30, 34, 40, 6, 7];
  List Days = [1, 2, 3, 4, 5, 6, 7];
  RewardedAd? _rewardedAd;
  RewardedInterstitialAd? _rewardedInterstitialAd;
  void createRewardedAd() {
    final provider = Provider.of<SetStateClass>(context, listen: false);
    RewardedAd.load(
      adUnitId: AdsMob.RewardAd!,
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            _rewardedAd = ad;
          });
        },
        onAdFailedToLoad: (error) {
          setState(() {
            _rewardedAd = null;
          });
        },
      ),
      request: const AdRequest(),
    );
  }



  ShowRewardedAd() {
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        createRewardedAd();
      },
    );
    _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {},
    );
  }

  _createRewardIntertialAd() {
    RewardedInterstitialAd.load(
      adUnitId: AdsMob.RewardAdIntertial!,
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            _rewardedInterstitialAd = ad;
          });
          ad.fullScreenContentCallback = FullScreenContentCallback(
              // Called when the ad showed the full screen content.
              onAdShowedFullScreenContent: (ad) {},
              // Called when an impression occurs on the ad.
              onAdImpression: (ad) {},
              // Called when the ad failed to show full screen content.
              onAdFailedToShowFullScreenContent: (ad, err) {
                // Dispose the ad here to free resources.
                ad.dispose();
              },
              // Called when the ad dismissed full screen content.
              onAdDismissedFullScreenContent: (ad) {
                // Dispose the ad here to free resources.
                ad.dispose();
              },
              // Called when a click is recorded for an ad.
              onAdClicked: (ad) {});


        },
        onAdFailedToLoad: (error) {
          setState(() {
            _rewardedInterstitialAd = null;
          });
        },
      ),
      request: const AdRequest(),
    );
  }

  ShowRewardedAdInertial() {
    final myType=Provider.of<AppFunctions>(context,listen: false);
    if(myType.watch_length<7){

      _rewardedInterstitialAd?.fullScreenContentCallback =
          FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _createRewardIntertialAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {

              ad.dispose();
              _createRewardIntertialAd();
            },
          );
      _rewardedInterstitialAd?.show(
        onUserEarnedReward: (ad, reward)async {



          var date=DateTime.now();
          var storage=FlutterSecureStorage();
          var user_id=await storage.read(key:'uid');
          FirebaseFirestore.instance.collection('users').doc(user_id).collection('watch').get().then((value){
            if(value.docs.length<=7){
              var check_id=Uuid().v1();
              FirebaseFirestore.instance.collection('users').doc(user_id).collection('watch').doc(check_id).set({
                'id':check_id,
                'coins':3,
                'date':'${date.day}/${date.month}/${date.year}',
                'ad':1,
              }).then((value) {
                myType.GetTotal();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.pink,
                    content: Center(child: Text('You Have Earned 3 Coins'))));
              });
            }
            else{
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.pink,
                  content: Center(child: Text('You Have Earned All Coins'))));
            }
          });

        },
      );
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.pink,
          content: Text('You Have Earned All Coins')));
    }

  }



  // TODO: replace this test ad unit with your own ad unit.
  final adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/5224354917'
      : 'ca-app-pub-3940256099942544/1712485313';

  /// Loads a rewarded ad.
  void loadAd() {
    RewardedAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),

        rewardedAdLoadCallback: RewardedAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
              // Called when the ad showed the full screen content.
                onAdShowedFullScreenContent: (ad) {},
                // Called when an impression occurs on the ad.
                onAdImpression: (ad) {},
                // Called when the ad failed to show full screen content.
                onAdFailedToShowFullScreenContent: (ad, err) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                },
                // Called when the ad dismissed full screen content.
                onAdDismissedFullScreenContent: (ad) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                },
                // Called when a click is recorded for an ad.
                onAdClicked: (ad) {});

            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            _rewardedAd = ad;
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('RewardedAd failed to load: $error');
          },
        ));
  }


  @override
  void initState() {
    createRewardedAd();
    _createRewardIntertialAd();
    loadAd();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider=Provider.of<AppFunctions>(context,listen: false);
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      body: SafeArea(
          child: Container(
        decoration: BoxDecoration(
// gradient: LinearGradient(colors: [HexColor('#F9C9D7'),HexColor('#C27CAE'),],begin: Alignment.topCenter,end: Alignment.bottomCenter),
            image: DecorationImage(
                fit: BoxFit.fill, image: AssetImage('images/reward.jpeg'))),
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.topRight,
              margin: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width:90,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                            child: Image.asset(
                          'images/coin.png',
                          height: 40,
                          width: 40,
                        )),
                        SizedBox(
                          width: 3,
                        ),
                        Consumer<AppFunctions>(builder: (BuildContext context, value, Widget? child) {
                          return   Container(
                              height: 30,
                              child: Text('${value.check_in+value.watch+value.topUp+value.read+value.comment+value.new_user}',
                                  style: GoogleFonts.roboto(
                                      color: CustomColors.white, fontSize: 24)));
                        },),

                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                      child: Text('Bonus ',
                          style: GoogleFonts.inter(
                              color: CustomColors.white, fontSize: 16))),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
            Container(
                height: 250,
                child: Container(
                  margin: EdgeInsets.only(
                    left: 8,
                    right: 8,
                  ),
                  // padding: EdgeInsets.only(left: 5, right: 5),
                  // width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [CustomColors.white, CustomColors.white]),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 176,
                        child: Column(
                          children: [
                            Container(
                                alignment: Alignment.center,
                                height: 50,
                                child: Text('Check-in Streak',
                                    style: GoogleFonts.quicksand(
                                        fontSize: 25,
                                        color: HexColor('#D81B5E'),
                                        fontWeight: FontWeight.w700))),
                            Stack(alignment: Alignment.center, children: [
                              Container(
                                width:MediaQuery.of(context).size.width,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                        'images/coin.png',
                                        height: 35,
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      // decoration: BoxDecoration(
                                      //     border: Border.all(
                                      //         width: 3,
                                      //         color: CustomColors.lightoragne),
                                      //     color: CustomColors.blue100,
                                      //     borderRadius: BorderRadius.circular(24)),
                                      child: Image.asset(
                                        'images/coin.png',
                                        width: 35,
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                        'images/coin.png',
                                        width: 35,
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                        'images/coin.png',
                                        width: 35,
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                        'images/coin.png',
                                        width: 35,
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                        'images/coin.png',
                                        width: 35,
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                        'images/gif.png',
                                        width: 35,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ]),
                            SizedBox(
                              height: 10,
                            ),
                            Stack(alignment: Alignment.center, children: [
                              Container(
                                width:MediaQuery.of(context).size.width,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 20,
                                      alignment: Alignment.center,
                                      child: Text(
                                        '+15',
                                        style:
                                            GoogleFonts.trocchi(fontSize: 14.7),
                                      ),
                                    ),
                                    Container(
                                      width: 40,
                                      height: 20,
                                      alignment: Alignment.center,
                                      // decoration: BoxDecoration(
                                      //     border: Border.all(
                                      //         width: 3,
                                      //         color: CustomColors.lightoragne),
                                      //     color: CustomColors.blue100,
                                      //     borderRadius: BorderRadius.circular(24)),
                                      child: Text(
                                        '+15',
                                        style:
                                            GoogleFonts.trocchi(fontSize: 14.7),
                                      ),
                                    ),
                                    Container(
                                      width: 40,
                                      height: 20,
                                      alignment: Alignment.center,
                                      child: Text(
                                        '+15',
                                        style:
                                            GoogleFonts.trocchi(fontSize: 14.7),
                                      ),
                                    ),
                                    Container(
                                      width: 40,
                                      height: 20,
                                      alignment: Alignment.center,
                                      child: Text(
                                        '+15',
                                        style:
                                            GoogleFonts.trocchi(fontSize: 14.7),
                                      ),
                                    ),
                                    Container(
                                      width: 40,
                                      height: 20,
                                      alignment: Alignment.center,
                                      child: Text(
                                        '+15',
                                        style:
                                            GoogleFonts.trocchi(fontSize: 14.7),
                                      ),
                                    ),
                                    Container(
                                      width: 40,
                                      height: 20,
                                      alignment: Alignment.center,
                                      child: Text(
                                        '+15',
                                        style:
                                            GoogleFonts.trocchi(fontSize: 14.7),
                                      ),
                                    ),
                                    Container(
                                      width: 40,
                                      height: 20,
                                      alignment: Alignment.center,
                                      child: Text(
                                        '+15',
                                        style:
                                            GoogleFonts.trocchi(fontSize: 14.7),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ]),
                            Stack(alignment: Alignment.center, children: [
                              Container(
                                child: Divider(
                                  thickness: 4,
                                  color: HexColor('#F1EAEA'),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: HexColor('#F2AF3D'),
                                        borderRadius: BorderRadius.circular(40),

                                      ),
                                      width: 12,
                                      height: 12,
                                      alignment: Alignment.center,
                                      // child:Icon(Icons.done,size: 12,weight: 50,),
                                    ), Container(
                                      decoration: BoxDecoration(
                                        color: HexColor('#F2AF3D'),
                                        borderRadius: BorderRadius.circular(40)
                                      ),
                                      width: 12,
                                      height: 12,
                                      alignment: Alignment.center,

                                    ), Container(
                                      decoration: BoxDecoration(
                                        color: HexColor('#F2AF3D'),
                                        borderRadius: BorderRadius.circular(40)
                                      ),
                                      width: 12,
                                      height: 12,
                                      alignment: Alignment.center,

                                    ), Container(
                                      decoration: BoxDecoration(
                                        color: HexColor('#F2AF3D'),
                                        borderRadius: BorderRadius.circular(40)
                                      ),
                                      width: 12,
                                      height: 12,
                                      alignment: Alignment.center,

                                    ), Container(
                                      decoration: BoxDecoration(
                                        color: HexColor('#F2AF3D'),
                                        borderRadius: BorderRadius.circular(40)
                                      ),
                                      width: 12,
                                      height: 12,
                                      alignment: Alignment.center,

                                    ), Container(
                                      decoration: BoxDecoration(
                                        color: HexColor('#F2AF3D'),
                                        borderRadius: BorderRadius.circular(40)
                                      ),
                                      width: 12,
                                      height: 12,
                                      alignment: Alignment.center,

                                    ), Container(
                                      decoration: BoxDecoration(
                                        color: HexColor('#F2AF3D'),
                                        borderRadius: BorderRadius.circular(40)
                                      ),
                                      width: 12,
                                      height: 12,
                                      alignment: Alignment.center,

                                    ),

                                  ],
                                ),
                              )
                            ]),
                            Stack(alignment: Alignment.center, children: [
                              Container(
                                width:MediaQuery.of(context).size.width,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      width: 45,
                                      height: 20,
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Day 1',
                                        style: GoogleFonts.trocchi(
                                          fontSize: 8,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 45,
                                      height: 20,
                                      alignment: Alignment.center,
                                      // decoration: BoxDecoration(
                                      //     border: Border.all(
                                      //         width: 3,
                                      //         color: CustomColors.lightoragne),
                                      //     color: CustomColors.blue100,
                                      //     borderRadius: BorderRadius.circular(24)),
                                      child: Text(
                                        'Day 2',
                                        style:GoogleFonts.trocchi(
                                          fontSize: 8,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 45,
                                      height: 20,
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Day 3',
                                        style: GoogleFonts.trocchi(
                                          fontSize: 8,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 45,
                                      height: 20,
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Day 4',
                                        style: GoogleFonts.trocchi(
                                          fontSize: 8,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 45,
                                      height: 20,
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Day 5',
                                        style:GoogleFonts.trocchi(
                                          fontSize: 8,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 45,
                                      height: 20,
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Day 6',
                                        style:GoogleFonts.trocchi(
                                          fontSize: 8,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 45,
                                      height: 20,
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Day 7',
                                        style: GoogleFonts.trocchi(
                                          fontSize: 8,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ]),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Consumer<SetStateClass>(builder: (BuildContext context, myType, Widget? child) {
                        return Container(
                          child: CustomButton(
                            width: 120.0,
                            height: 35.0,
                            gr_color1: HexColor('#ed8ca8'),
                            gr_color2: HexColor('#ed8ca8'),
                            onTap: ()async {
                              final provider=Provider.of<AppFunctions>(context,listen: false);
                              var date=DateTime.now();
                              var storage=FlutterSecureStorage();
                              var user_id=await storage.read(key:'uid');
                              FirebaseFirestore.instance.collection('users').doc(user_id).collection('check_in').get().then((value){
                                if(value.docs.isNotEmpty){
                                  for(var data in value.docs){
                                    if(data.data()['date']=='${date.day}/${date.month}/${date.year}'){
                                     myType.SetDay(true);
                                      break;
                                    }
                                    else{
                                      myType.SetDay(false);
                                    }
                                  }
                                }
                                else{
                                  var check_id=Uuid().v1();
                                  FirebaseFirestore.instance.collection('users').doc(user_id).collection('check_in').doc(check_id).set({
                                    'id':check_id,
                                    'coins':15,
                                    'date':'${date.day}/${date.month}/${date.year}',
                                    'day':1,
                                  }).then((value) {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        backgroundColor: Colors.pink,
                                        content: Center(child: Text('You Have Earned 15 Coins'))));

                                  });

                                }

                                if(myType.day==false){
                                  if(value.docs.length<7){
                                    var check_id=Uuid().v1();
                                    FirebaseFirestore.instance.collection('users').doc(user_id).collection('check_in').doc(check_id).set({
                                      'id':check_id,
                                      'coins':15,
                                      'date':'${date.day}/${date.month}/${date.year}',
                                      'day':value.docs.length+1,
                                    }).then((value) {
                                      provider.GetTotal();
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          backgroundColor: Colors.pink,
                                          content: Center(child: Text('You Have Earned 15 Coins'))));

                                    });
                                  }
                                  else{
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        backgroundColor: Colors.pink,
                                        content: Center(child: Text('You Have Earned All Coins'))));
                                  }
                                }
                                if(myType.day==true){
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      backgroundColor: Colors.pink,
                                      content: Center(child: Text('You Have Earned Today Coins'))));
                                }
                              });
                            },
                            text: 'Check-In',
                            color: null,
                            style: GoogleFonts.trocchi(
                                fontSize: 18, color: Colors.white),
                            text_color: null,
                          ),
                        );
                      },)

                    ],
                  ),
                )),
            SizedBox(
              height: 15,
            ),
            Container(
                alignment: Alignment.topLeft,
                child: Image.asset(
                  'images/daily.png',
                  width: 140,
                  height: 40,
                  fit: BoxFit.fill,
                )),
            SizedBox(
              height: 15,
            ),
            //watch videos
            Container(
              margin: EdgeInsets.only(
                left: 8,
                right: 8,
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Consumer<AppFunctions>(builder: (BuildContext context, value, Widget? child) {
                    return    RewardCardDesign(
                      bouns_count: '(${value.watch_length}/7)',
                      button_icon: null,
                      button_text: 'Go',
                      button_border: 12.0,
                      button_width: 100.0,
                      buttonPressed: () {
                        _createRewardIntertialAd();
                        ShowRewardedAdInertial();


                      },
                      title: 'Watch video to earn bouns',
                      descriptions: 'Earn 3  bouns on each video ',
                    );
                  },)
               ,
                  RewardCardDesign(
                    bouns_count: 20,
                    button_icon: null,
                    button_border: 12.0,
                    button_width: 100.0,
                    button_text: 'Go',
                    buttonPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>CoinsScrren()));
                    },
                    title: 'Top Up',
                    descriptions: 'Earn 20 with first top up of the day ',
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color:Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 12, top: 5),
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Reading Task 0/80 mins',
                            style: GoogleFonts.workSans(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 250,
                              height: 40,
                              child:
                                  Stack(alignment: Alignment.center, children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Divider(
                                    thickness: 4,
                                    color: HexColor('#f1eaea'),
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            width: 40,
                                            height:40,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(24),
                                               ),
                                            child:Image.asset('images/circle.png'),
                                          ),
                                          Container(child:Text('5'))
                                        ],
                                      ),
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            width: 40,
                                            height:40,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(24),
                                               ),
                                            child:Image.asset('images/circle.png'),
                                          ),
                                          Container(child:Text('10'))
                                        ],
                                      ),
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            width: 40,
                                            height:40,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(24),
                                               ),
                                            child:Image.asset('images/circle.png'),
                                          ),
                                          Container(child:Text('15'))
                                        ],
                                      ),
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            width: 40,
                                            height:40,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(24),
                                               ),
                                            child:Image.asset('images/circle.png'),
                                          ),
                                          Container(child:Text('20'))
                                        ],
                                      ),
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            width: 40,
                                            height:40,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(24),

                                               ),
                                            child:Image.asset('images/circle.png',
                                         ),
                                          ),
                                          Container(child:Text('25'))
                                        ],
                                      ),
                                   
                                   
                                    ],
                                  ),
                                )
                              ]),
                            ),
                           Consumer<AppFunctions>(builder: (BuildContext context, value, Widget? child) {
                             return  Container(
                               width: 100,
                               height: 30,
                               margin: EdgeInsets.only(right: 8),
                               decoration: BoxDecoration(
                                   color: HexColor('#ed8ca8'),
                                   borderRadius: BorderRadius.circular(12)),
                               child: InkWell(
                                 onTap: () {
                                   if(value.read<80){
                                     Navigator.push(context, MaterialPageRoute(builder: (context)=>ReaderScreen()));
                                   }else{
                                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                         backgroundColor: Colors.pink,
                                         content: Text('You Have Earned All Coins')));
                                   }

                                 },
                                 child: Center(
                                     child: Text(
                                       'Go',
                                       style: GoogleFonts.roboto(
                                           color: CustomColors.white),
                                     )),
                               ),
                             );
                           },),

                          ],
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 20,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 250,
                                child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          '5min ',
                                          style: GoogleFonts.roboto(
                                              color: CustomColors.black,
                                             ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          '10min',
                                          style: GoogleFonts.roboto(
                                              color: CustomColors.black,
                                            ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          '20min',
                                          style: GoogleFonts.roboto(
                                              color: CustomColors.black,
                                              ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          '40min',
                                          style: GoogleFonts.roboto(
                                              color: CustomColors.black,
                                             ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          '80min',
                                          style: GoogleFonts.roboto(
                                              color: CustomColors.black,
                                             ),
                                        ),
                                      ),
                                    ]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  RewardCardDesign(
                    bouns_count: 1,
                    button_icon: null,
                    button_border: 12.0,
                    button_width: 100.0,
                    button_text: 'Go',
                    title: 'Comment',
                    descriptions: 'Earn 1 coin for each comment',
                    buttonPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>UserCommentScreen()));
                    },
                  ),
                ],
              ),
            ),
        provider.new_user==0 ?    Container(
                alignment: Alignment.topLeft,
                child: Image.asset(
                  'images/new.png',
                  width: 140,
                  height: 50,
                  fit: BoxFit.fill,
                )):Container(),
        provider.new_user==0 ?    Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
               color: Colors.white,
              ),
              // padding: EdgeInsets.only(top: 5),
              margin: EdgeInsets.all(8),
              // height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Container(
                    height:80,
                    child: RewardCardDesign(
                      bouns_count: null,
                      button_icon: null,
                      button_text: 'Go',
                      button_border: 12.0,
                      button_width: 100.0,
                      height: 40.0,
                      title: 'Login',
                      buttonPressed: ()async{
                        FirebaseFirestore.instance.collection('users').doc(provider.user_id).collection('new_user').doc(provider.user_id).set({
                          'id':provider.user_id,
                          'coins':10,
                          'new':false
                        }).then((value) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You Have Earned 10 Coins')));
                          provider.GetTotal();
                        });
                      },
                      descriptions: 'Login to earn 10 bonus coin',
                    ),
                  ),
                ],
              ),
            ):Container(),
            Container(

              margin: EdgeInsets.symmetric(vertical: 5),
              child: Center(child: Text('All the bonus coins has an expiry of seven days. ')),)
          ],
        ),
      )),
    );
  }
}
