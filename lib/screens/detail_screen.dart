import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:change_case/change_case.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:laylah/screens/chapter_preview_screen.dart';
import 'package:laylah/screens/library_screen.dart';
import 'package:laylah/screens/splash_screen.dart';
import 'package:laylah/screens/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:laylah/components/card_horizonatl.dart';
import 'package:laylah/components/category_comp.dart';
import 'package:laylah/components/custom_button.dart';
import 'package:laylah/provider/set_state_class.dart';
import 'package:laylah/utils/colors.dart';
import 'package:uuid/uuid.dart';

class DetailScreen extends StatefulWidget {
  var id;
  var library;
  var collection;
  var start;
  var comment;
  DetailScreen(
      {super.key,
      required this.id,
      required this.library,
      required this.collection,
        this.start,this.comment});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  var storage = FlutterSecureStorage();
  var length = 0;

  GetLength() async {
    var user_id = await storage.read(key: 'uid');
    final provider = Provider.of<SetStateClass>(context, listen: false);
    FirebaseFirestore.instance
        .collection('books')
        .doc(widget.id)
        .collection('likes')
        .get()
        .then((value) {
      if (value.docs.isNotEmpty == false) {
        provider.setLikesLength(0);
      } else if (value.docs.isNotEmpty == true) {
        provider.setLikesLength(1);
        FirebaseFirestore.instance
            .collection('books')
            .doc(widget.id)
            .collection('likes')
            .get()
            .then((value) {
          for (var user in value.docs) {
            if (user.data()['id'] == user_id) {
              provider.setCurrentUser(true);
            } else {
              provider.setCurrentUser(false);
            }
          }
        });
      }
    });
  }

  var ids = '';
  bool isAvaible = false;

  LikedByCurrentUser() {
    final provider = Provider.of<SetStateClass>(context, listen: false);
    FirebaseFirestore.instance
        .collection('books')
        .doc(widget.id)
        .collection('likes')
        .get()
        .then((value) {
      if (value.docs.isNotEmpty == false) {
        provider.setLikesLength(0);
      } else if (value.docs.isNotEmpty == true) {
        provider.setLikesLength(1);
      }
    });
  }

  LibraryThisBook() async {
    final provider = Provider.of<SetStateClass>(context, listen: false);
    var user = await storage.read(key: 'uid');

    FirebaseFirestore.instance.collection('library').get().then((value) {

      if (value.docs.length == 0) {

        setState(() {
          isAvaible = false;
        });

      } else {
        value.docs.forEach((element) {
          if (element.data()['book_id'] == widget.id) {

            if (user == element.data()['user_id']) {

              setState(() {
                ids = element.data()['id'];
                isAvaible = true;
              });
            }
          }
        });
      }
    });
  }

  RewardedAd? _rewardedAd;

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
    GetLength();
    LibraryThisBook();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(''),

        flexibleSpace: Container(
            decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [CustomColors.white, CustomColors.white]),
        )),
        // backgroundColor: CustomColors.AppColor1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.pink,),
          tooltip: 'Back',

          onPressed: () {
            Navigator.pop(context);
          },
        ), //IconButton
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.bookmark,color:Colors.pink,),
            tooltip: 'BookMarked',
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LibraryScreen()));
            },
          ), //IconButton
          //IconButton
          IconButton(
            icon: Icon(Icons.share),color:Colors.pink,
            tooltip: 'Share',
            onPressed: () {},
          ), //IconButton
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                  colors: [
                    Colors.white,
                    Colors.white,
                  ]),
            ),
            width: MediaQuery.of(context).size.width,
            // color: CustomColors.AppColor1,
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection(widget.collection)
                    .doc(widget.id)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView(children: [
                      Container(
                        margin: EdgeInsets.all(12),
                        child: Row(children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  6.0), // Adjust the radius as per your needs
                              child: CachedNetworkImage(
                               imageUrl: '${snapshot.data!.data()!['cover']}',
                                width: 120,
                                height: 150,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(3),
                                  // height: 50,
                                  width:
                                      MediaQuery.of(context).size.width - 156,
                                  child: Text(
                                    "${snapshot.data!.data()!['book_title']}".toCapitalCase(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.roboto(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(3),
                                  // height: 50,
                                  child: Text(
                                    '${snapshot.data!.data()!['book_writer']}'.toCapitalCase(),
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.roboto(
                                      // fontSize: 17
                                      color: Colors.grey,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                                SizedBox(height:5),
                                Container(
                                  padding: EdgeInsets.all(3),
                                  // height: 50,
                                  child: Text(
                                    '${snapshot.data!.data()!['language']} | ${snapshot.data!.data()!['content_rating']} ',
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.roboto(
                                      // fontSize: 17,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                                SizedBox(height:5),
                                Container(
                                  padding: EdgeInsets.all(3),
                                  // height: 50,
                                  child: Text(
                                    'Words:${snapshot.data!.data()!['words']}| ${snapshot.data!.data()!['status']}',
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.roboto(
                                      // fontSize: 17,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                                SizedBox(height:5),
                                // new
                                Container(
                                  width:
                                  MediaQuery.of(context).size.width - 196,

                                  child: Row(children: [
                                    Container(

                                      child: Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              child: Text(
                                                '${snapshot.data!.data()!['view']} : ',
                                                style: GoogleFonts.roboto(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              child: Container(
                                                child: Icon(
                                                  MaterialCommunityIcons.eye,
                                                  color:Colors.grey,
                                                  size: 25,
                                                ),
                                              ),
                                            ),
                                          ]),
                                    ),
                                    SizedBox(width: 10,),
                                    Container(

                                      child: Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [

                                            StreamBuilder(
                                                stream: FirebaseFirestore.instance
                                                    .collection('books')
                                                    .doc(widget.id)
                                                    .collection('likes')
                                                    .snapshots(),
                                                builder: (context, likes) {
                                                  if (snapshot.hasData) {
                                                    return Container(
                                                      // margin:
                                                      // EdgeInsets.only(right: 45),
                                                      child: Text(
                                                        '| ${likes.data?.docs.length} : ',
                                                        style: GoogleFonts.roboto(
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                  return Center(
                                                    child:
                                                    CircularProgressIndicator(),
                                                  );
                                                }),
                                            Consumer<SetStateClass>(
                                              builder: (context, myType, child) {
                                                return InkWell(
                                                  onTap: () async {
                                                    var user_id = await storage.read(
                                                        key: 'uid');

                                                    if (myType.likes_length == 0) {
                                                      FirebaseFirestore.instance
                                                          .collection('books')
                                                          .doc(widget.id)
                                                          .collection('likes')
                                                          .doc(user_id)
                                                          .set({
                                                        'likes': 1,
                                                        'id': user_id,
                                                      });
                                                    } else if (myType.likes_length >
                                                        0) {
                                                      FirebaseFirestore.instance
                                                          .collection('books')
                                                          .doc(widget.id)
                                                          .collection('likes')
                                                          .get()
                                                          .then((value) {
                                                        if (myType.current_user ==
                                                            false) {
                                                          FirebaseFirestore.instance
                                                              .collection('books')
                                                              .doc(widget.id)
                                                              .collection('likes')
                                                              .doc(user_id)
                                                              .set({
                                                            'likes':
                                                            value.docs.length + 1,
                                                            'id': user_id
                                                          });
                                                        }
                                                      });
                                                    }

                                                  },
                                                  child:
                                                  Container(
                                                    // width: 100,
                                                    child: Icon(
                                                      AntDesign.like1,color:Colors.grey,size:20,
                                                    ),
                                                  ),
                                                );
                                              },
                                            )
                                          ]),
                                    ),
                                  ]),
                                ),
                              ],
                            ),
                          ),
                        ]),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24)),
                            color: Colors.white),
                        child: Column(children: [

                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            margin: EdgeInsets.all(12),
                            child: Text(
                              '${snapshot.data!.data()!['descriptions']}',
                              textAlign: TextAlign.justify,
                              style: GoogleFonts.roboto(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                              height: 35,
                              margin: EdgeInsets.all(5),
                              child: ListView.builder(
                                itemCount:
                                    snapshot.data!.data()!['tags']!.length,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemBuilder: (context, i) {
                                  return Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    margin: EdgeInsets.symmetric(horizontal: 8,vertical: 4),
                                    padding: EdgeInsets.symmetric(horizontal: 12,vertical: 5),
                                    child: Text(
                                        '${snapshot.data!.data()!['tags'][i]}',style: GoogleFonts.roboto(fontSize: 12),),
                                  );
                                },
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            margin:EdgeInsets.symmetric(horizontal: 12),
                            child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('books')
                                    .doc(widget.id)
                                    .collection('chapter')
                                    .snapshots(),
                                builder: (context, chp) {
                                  if (snapshot.hasData) {
                                    return Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: Text(
                                              '${chp.data?.docs.length}  Chapters',
                                              style: GoogleFonts.ptSerif(
                                                fontSize: 19,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Row(
                                              children: [
                                                Text(
                                                  'updated just now ',
                                                  style: GoogleFonts.ptSerif(
                                                    fontSize: 18,
                                                    color: Colors.black54,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Icon(
                                                  Icons
                                                      .arrow_forward_ios_outlined,
                                                  color: Colors.black54,
                                                  size: 18,
                                                )
                                              ],
                                            ),
                                          )
                                        ]);
                                  }
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: Text(
                              'You Might Like',
                              style: GoogleFonts.ptSerif(
                                fontSize: 19,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            height: 350,
                            child: CardHorizontal(
                              section: snapshot.data!.data()!['section'],
                            ),
                          )
                        ]),
                      ),
                    ]);
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          ),
          Container(
            child: Positioned(
                bottom: 0,
                left: 0,
                child: Consumer<SetStateClass>(
                  builder: (context, value, child) {

                    return Container(
                      color: CustomColors.white,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(6),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () async {
                                var user = await storage.read(key: 'uid');
                                final auth = FirebaseAuth.instance;
                                var id = Uuid().v1();
                                if (auth.currentUser != null) {
                                  if (isAvaible == true) {
                                    FirebaseFirestore.instance
                                        .collection('library')
                                        .doc(ids)
                                        .delete();
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                        backgroundColor: Colors.red,
                                        content:
                                        Text('Deleted')));
                                    setState(() {
                                      isAvaible=false;
                                    });
                                    LibraryThisBook();
                                  } else if (isAvaible == false) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                        backgroundColor: Colors.green,
                                        content:
                                        Text('Book Added')));
                                    FirebaseFirestore.instance
                                        .collection('library')
                                        .doc(id)
                                        .set({
                                      'id': id,
                                      'book_id': widget.id,
                                      'user_id': user,
                                    });
                                    LibraryThisBook();
                                    FirebaseFirestore.instance
                                        .collection('books')
                                        .doc(widget.id)
                                        .update({
                                      'libraries': widget.library + 1,
                                    });
                                  }
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => WelcomeScreen()));
                                }
                              },
                              child: Container(
                                  width: 100,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [
                                            Colors.pink,
                                            Colors.pink

                                          ],
                                          begin: Alignment.bottomLeft,
                                          end: Alignment.topCenter),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Icon(
                                    isAvaible == false
                                        ? MaterialCommunityIcons.bookmark
                                        : MaterialCommunityIcons
                                            .bookmark_check_outline,
                                    color: CustomColors.white,
                                  )),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Container(
                              child: CustomButton(
                                color: null,
                                text: 'Read',
                                text_color: null,
                                gr_color1:Colors.pink,
                                gr_color2:Colors.pink,
                                onTap: () {

                                
                                  final auth = FirebaseAuth.instance;
                                  var date=DateTime.now();
                                  var storage=FlutterSecureStorage();

                                  if (auth.currentUser != null) {
                                    FirebaseFirestore.instance
                                        .collection('books')
                                        .doc(widget.id)
                                        .collection('chapter')
                                        .get()
                                        .then((value)  async {
                                              if (value.docs.length > 0)
                                                {
                                                  if(widget.comment!=null){
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ChapterPreviewScreen(
                                                                comment:widget.comment,
                                                                    length: value
                                                                        .docs
                                                                        .length,
                                                                    index: 0,
                                                                    id: widget
                                                                        .id)));
                                    }
                                                  else{
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ChapterPreviewScreen(

                                                                    length: value
                                                                        .docs
                                                                        .length,
                                                                    index: 0,
                                                                    id: widget
                                                                        .id)));
                                                  }

                                                }
                                              else
                                                {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          backgroundColor:
                                                              CustomColors
                                                                  .AppColor1,
                                                          content: Text(
                                                              'This book Has 0 Chapter ')));
                                                }
                                            });
                                  }
                                  else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                WelcomeScreen()));
                                  }
                                },
                              ),
                            ),
                          ]),
                    );
                  },
                )),
          )
        ],
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //     showSelectedLabels: false,
      //     showUnselectedLabels: false,
      //     type: BottomNavigationBarType.fixed,
      //     items: [
      //       BottomNavigationBarItem(
      //           icon: InkWell(
      //             onTap: () {},
      //             child: Container(
      //                 height: 40,
      //                 alignment: Alignment.center,
      //                 decoration: BoxDecoration(
      //                   borderRadius: BorderRadius.circular(6),
      //                   gradient: LinearGradient(
      //                       begin: Alignment.topCenter,
      //                       end: Alignment.bottomCenter,
      //                       colors: [
      //                         CustomColors.AppColor1,
      //                         CustomColors.AppColor2
      //                       ]),
      //                 ),
      //                 width: 200,
      //                 child: Icon(
      //                   MaterialCommunityIcons.bookmark_check,
      //                   color: CustomColors.white,
      //                 )),
      //           ),
      //           label: ''),
      //       BottomNavigationBarItem(
      //           icon: InkWell(
      //             onTap: () {},
      //             child: Container(
      //                 height: 40,
      //                 alignment: Alignment.center,
      //                 decoration: BoxDecoration(
      //                   borderRadius: BorderRadius.circular(20),
      //                   gradient: LinearGradient(
      //                       begin: Alignment.topCenter,
      //                       end: Alignment.bottomCenter,
      //                       colors: [
      //                         CustomColors.AppColor1,
      //                         CustomColors.AppColor2
      //                       ]),
      //                 ),
      //                 width: 300,
      //                 child: Text(
      //                   'Read ',
      //                   style: GoogleFonts.ptSerif(
      //                     fontSize: 19,
      //                     color: Colors.white,
      //                     fontWeight: FontWeight.bold,
      //                   ),
      //                 )),
      //           ),
      //           label: ''),
      //     ]),
    );
  }
}
