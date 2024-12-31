import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:laylah/components/input_text.dart';
import 'package:laylah/provider/AppFunctions.dart';
import 'package:laylah/utils/default_stlye.dart';
import 'package:provider/provider.dart';

import 'package:uuid/uuid.dart';

import '../components/CustomIconButton.dart';

import '../components/comment_screen.dart';
import '../utils/colors.dart';

class ChapterPreviewScreen extends StatefulWidget {
  var id;
  var length;
  var index;
  var start_minute;
  var start_hour;
  var read_id;
  var comment;
  ChapterPreviewScreen(
      {super.key,
      required this.id,
      this.index,
      this.length,
      this.start_minute,
      this.start_hour,
      this.read_id,
      this.comment});

  @override
  State<ChapterPreviewScreen> createState() => _ChapterPreviewScreenState();
}

class _ChapterPreviewScreenState extends State<ChapterPreviewScreen> {
  TextEditingController comment = TextEditingController();
  int minutesCount = 0;
  int secondsCount = 0;
  late Timer _timer;

  final GlobalKey _containerKey = GlobalKey();
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

  StartTime() async {
    if (widget.start_minute != null) {
      var date = DateTime.now();
      var storage = FlutterSecureStorage();
      var user_id = await storage.read(key: 'uid');
      FirebaseFirestore.instance
          .collection('users')
          .doc(user_id)
          .collection('read')
          .get()
          .then((value) {
        if (value.docs.length < 5) {
          var check_id = Uuid().v1();
          FirebaseFirestore.instance
              .collection('users')
              .doc(user_id)
              .collection('read')
              .doc(user_id)
              .update({
            'minutes': widget.read_id + (date.minute - widget.start_minute),
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.pink,
              content: Center(child: Text('You Have Earned All Coins'))));
        }
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        secondsCount++;
        if (secondsCount == 60) {
          secondsCount = 0;
          minutesCount++;
        }
      });
    });
  }

  @override
  void initState() {
    loadAd();
    _startTimer();
    // Load the image using precacheImage

    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late ImageProvider _imageProvider;
    precacheImage(AssetImage('images/unlock.png'), context);
    _imageProvider = AssetImage('images/unlock.png');

    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      body: WillPopScope(
        onWillPop: () async {
          final provider = Provider.of<AppFunctions>(context, listen: false);
          if (widget.start_minute != null) {
            var date = DateTime.now();
            var storage = FlutterSecureStorage();
            var user_id = await storage.read(key: 'uid');
            FirebaseFirestore.instance
                .collection('users')
                .doc(user_id)
                .collection('read')
                .get()
                .then((value) {
              if (value.docs.length < 5) {
                var check_id = Uuid().v1();
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(user_id)
                    .collection('read')
                    .doc(user_id)
                    .update({
                  'minutes': widget.read_id + (minutesCount),
                });
                provider.GetTotal();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.pink,
                    content: Center(child: Text('You Have Earned All Coins'))));
              }
            });
          }

          _timer.cancel();

          return true;
        },
        child: Container(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('books')
                      .doc(widget.id)
                      .collection('chapter')
                      .orderBy('update_date')
                      .snapshots(),
                  builder: (context, chapter) {
                    if (chapter.hasData) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: chapter.data!.docs.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, int index) {
                            return widget.index != null
                                ? Stack(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.all(12),
                                            // height: MediaQuery.of(context).size.height,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: Text(
                                                    'Chapter ${chapter.data!.docs[index]['chater_no']} [${chapter.data!.docs[index]['chapter_title']}]',
                                                    style: GoogleFonts.ptSerif(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  height: 30,
                                                  child: StreamBuilder(
                                                      stream: FirebaseFirestore
                                                          .instance
                                                          .collection('books')
                                                          .doc(widget.id)
                                                          .snapshots(),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot.hasData) {
                                                          return Container(
                                                            height: 30,
                                                            child: Text(
                                                              '${snapshot.data!.data()!['book_writer']}',
                                                              style: GoogleFonts
                                                                  .ptSerif(
                                                                      // fontWeight: FontWeight.bold,
                                                                      fontSize:
                                                                          16),
                                                            ),
                                                          );
                                                        }
                                                        return Container(
                                                          child: Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          ),
                                                        );
                                                      }),
                                                ),
                                                Container(
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width -
                                                            65,
                                                        // height: MediaQuery.of(context).size.height-140,
                                                        child: InkWell(
                                                          onLongPress: () {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return AlertDialog(
                                                                    title:
                                                                        Container(
                                                                      height:
                                                                          200,
                                                                      width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width,
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Container(
                                                                            // width: 200,
                                                                            child:
                                                                                InputText(
                                                                              placeholder: 'write comment here',
                                                                              name: 'Comment',
                                                                              require: true,
                                                                              text: comment,
                                                                              width: MediaQuery.of(context).size.width - 197,
                                                                            ),
                                                                          ),
                                                                          CustomIconButton(
                                                                            width:
                                                                                120,
                                                                            onTap:
                                                                                () async {
                                                                              var storage = FlutterSecureStorage();
                                                                              var user = await storage.read(key: 'uid');

                                                                              final date = DateTime.now();
                                                                              if (comment.text.isNotEmpty) {
                                                                                final provider = Provider.of<AppFunctions>(context, listen: false);
                                                                                var comment_id = Uuid().v1();
                                                                                FirebaseFirestore.instance.collection('books').doc(widget.id).collection('chapter').doc(chapter.data!.docs[index]['book_id']).collection('comments').doc(comment_id).set({
                                                                                  'id': comment_id,
                                                                                  'comment': comment.text,
                                                                                  'user_id': user,
                                                                                  'book_id': chapter.data!.docs[index]['book_id'],
                                                                                  'date': "${date.year}/${date.month}/${date.day}-${date.hour}:${date.minute}:${date.second}",
                                                                                  'like': 0,
                                                                                  'dislike': 0,
                                                                                }).then((value) {
                                                                                  if (widget.comment != null) {
                                                                                    FirebaseFirestore.instance.collection('users').doc(user).collection('comment').doc(comment_id).set({
                                                                                      'id': comment_id,
                                                                                      'coins': 1,
                                                                                    }).then((value) {
                                                                                      provider.GetTotal();
                                                                                    });
                                                                                  }

                                                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Comment added')));
                                                                                  Navigator.pop(context);
                                                                                  comment.clear();
                                                                                });
                                                                              } else {
                                                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('please write comment')));
                                                                              }
                                                                            },
                                                                            color1:
                                                                                CustomColors.pink1,
                                                                            color2:
                                                                                CustomColors.pink2,
                                                                            title:
                                                                                'Comment',
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  );
                                                                });
                                                          },
                                                          child: Text(
                                                            '${chapter.data?.docs[index]['description']}',
                                                            textAlign: TextAlign
                                                                .justify,
                                                            style: GoogleFonts.ptSerif(
                                                                color:
                                                                    CustomColors
                                                                        .grey200,
                                                                fontSize: 16),
                                                          ),
                                                        ),
                                                      ),
                                                      // Positioned(
                                                      //   bottom: 0,
                                                      //   child: Container(
                                                      //     decoration: BoxDecoration(
                                                      //     color: Colors.red,
                                                      //       borderRadius: BorderRadius.only(topRight: Radius.circular(70),topLeft: Radius.circular(50))
                                                      //
                                                      //     ),
                                                      //     height: 500,
                                                      //     width: MediaQuery.of(context).size.width-60,
                                                      //     child: Column(
                                                      //       crossAxisAlignment: CrossAxisAlignment.center,
                                                      //       mainAxisAlignment: MainAxisAlignment.center,
                                                      //       children: [
                                                      //         Container(
                                                      //           child: Text(
                                                      //               '35 ',style:GoogleFonts.roboto(color: Colors.white,fontSize: 50),),),
                                                      //         Row(
                                                      //           crossAxisAlignment: CrossAxisAlignment.center,
                                                      //           mainAxisAlignment: MainAxisAlignment.center,
                                                      //           children: [
                                                      //             Container(
                                                      //               child: Text(
                                                      //                   'coins / bouns  ',style: GoogleFonts.roboto(color: Colors.white),),),
                                                      //             Container(child: Image.asset('images/coins.png',width: 40,)),
                                                      //
                                                      //           ],
                                                      //         ),
                                                      //         Container(child: CustomIconButton(onTap: (){
                                                      //
                                                      //         }, title: 'Unlock',),),
                                                      //       SizedBox(height: 20,),
                                                      //         Container(child: Text('Balance: 5 coins',style: GoogleFonts.roboto(color: Colors.white),),)
                                                      //
                                                      //       ],
                                                      //     ),
                                                      //   ),
                                                      // )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          // comments of books
                                          Container(
                                            width: 41,
                                            height: 100,
                                            // height:MediaQuery.of(context).size.height,
                                            child: StreamBuilder(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection('books')
                                                    .doc(widget.id)
                                                    .collection('chapter')
                                                    .doc(chapter.data!
                                                        .docs[index]['book_id'])
                                                    .collection('comments')
                                                    .snapshots(),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    return Container(
                                                      // alignment: Alignment.center,
                                                      width: 50,
                                                      height: 60,
                                                      child: ListView.builder(
                                                          physics:
                                                              NeverScrollableScrollPhysics(),
                                                          itemCount: 1,
                                                          itemBuilder:
                                                              (context, int c) {
                                                            return (snapshot
                                                                            .data!
                                                                            .docs
                                                                            .isNotEmpty
                                                                        ? snapshot.data!.docs[c]
                                                                            [
                                                                            'book_id']
                                                                        : '12') ==
                                                                    chapter.data!
                                                                            .docs[index]
                                                                        [
                                                                        'book_id']
                                                                ? Container(
                                                                    height: 170,
                                                                    width: 50,
                                                                    child:
                                                                        Stack(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      children: [
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            showDialog(
                                                                                context: context,
                                                                                builder: (context) {
                                                                                  return AlertDialog(
                                                                                    icon: Container(
                                                                                        alignment: Alignment.topRight,
                                                                                        child: InkWell(
                                                                                            onTap: () {
                                                                                              Navigator.pop(context);
                                                                                            },
                                                                                            child: Icon(Icons.close))),
                                                                                    title: Container(
                                                                                      width: MediaQuery.of(context).size.width,
                                                                                      height: MediaQuery.of(context).size.height - 200,
                                                                                      child: StreamBuilder(
                                                                                          stream: FirebaseFirestore.instance.collection('books').doc(widget.id).collection('chapter').doc(chapter.data!.docs[index]['book_id']).collection('comments').snapshots(),
                                                                                          builder: (context, snapshot) {
                                                                                            if (snapshot.hasData) {
                                                                                              return ListView.builder(
                                                                                                  itemCount: snapshot.data!.docs.length,
                                                                                                  shrinkWrap: true,
                                                                                                  itemBuilder: (context, int index) {
                                                                                                    return Container(
                                                                                                      height: 30,
                                                                                                      child: Text(
                                                                                                        '${snapshot.data!.docs[c]['comment']}',
                                                                                                        style: GoogleFonts.inter(fontSize: 16),
                                                                                                      ),
                                                                                                    );
                                                                                                  });
                                                                                            }
                                                                                            return Container(
                                                                                              child: Center(
                                                                                                child: CircularProgressIndicator(),
                                                                                              ),
                                                                                            );
                                                                                          }),
                                                                                    ),
                                                                                  );
                                                                                });
                                                                          },
                                                                          child:
                                                                              Icon(
                                                                            FontAwesome5Solid.comment_alt,
                                                                            size:
                                                                                30,
                                                                            color:
                                                                                Colors.black54,
                                                                          ),
                                                                        ),
                                                                        InkWell(
                                                                          onTap:
                                                                              () async {
                                                                            var storage =
                                                                                FlutterSecureStorage();
                                                                            var user_id =
                                                                                await storage.read(key: 'uid');
                                                                            Navigator.push(context,
                                                                                MaterialPageRoute(builder: (context) => CommentScreen(id: widget.id, chapter_id: chapter.data!.docs[index]['book_id'], comment_id: snapshot.data!.docs[c]['id'], user_id: user_id)));
                                                                            // showDialog(
                                                                            //     context:
                                                                            //         context,
                                                                            //     builder:
                                                                            //         (context) {
                                                                            //       return AlertDialog(
                                                                            //         contentPadding: EdgeInsets.zero,
                                                                            //
                                                                            //         icon: Container(
                                                                            //
                                                                            //             alignment: Alignment.topRight,
                                                                            //             child: InkWell(
                                                                            //                 onTap: () {
                                                                            //                   Navigator.pop(context);
                                                                            //                 },
                                                                            //                 child: Icon(Icons.close))),
                                                                            //         // actionsPadding: EdgeInsets.zero,
                                                                            //         insetPadding: EdgeInsets.zero,
                                                                            //         content: StreamBuilder(
                                                                            //           // comments data
                                                                            //             stream: FirebaseFirestore.instance.collection('books').doc(widget.id).collection('chapter').doc(chapter.data!.docs[index]['book_id']).collection('comments').snapshots(),
                                                                            //             builder: (context, snapshot) {
                                                                            //               if (snapshot.hasData) {
                                                                            //                 return ListView.builder(
                                                                            //                     itemCount: snapshot.data!.docs.length,
                                                                            //                     shrinkWrap: true,
                                                                            //                     itemBuilder: (context, int index) {
                                                                            //                       if (snapshot.hasData) {
                                                                            //                         return Container(
                                                                            //                           width: MediaQuery.of(context).size.width,
                                                                            //                           height: MediaQuery.of(context).size.height ,
                                                                            //                           color: Colors.green,
                                                                            //                           // margin: EdgeInsets.all(12),
                                                                            //                           child: StreamBuilder(
                                                                            //                               stream: FirebaseFirestore.instance.collection('users').snapshots(),
                                                                            //                               builder: (context, user) {
                                                                            //                                 if (snapshot.hasData) {
                                                                            //                                   return Container(
                                                                            //                                     width: MediaQuery.of(context).size.width,
                                                                            //                                     height: MediaQuery.of(context).size.height ,
                                                                            //                                     child: ListView.builder(
                                                                            //                                         shrinkWrap: true,
                                                                            // itemCount: user.data!.docs.length,
                                                                            //                                         itemBuilder: (context, int u) {
                                                                            //                                           return   snapshot.data!.docs[index]['user_id'].contains(user.data!.docs[u]['uid'])
                                                                            //                                               ?
                                                                            //                                           Container(
                                                                            //                                             color: Colors.blueGrey.shade50,
                                                                            //                                             width: MediaQuery.of(context).size.width,
                                                                            //                                             child: Row(
                                                                            //                                               crossAxisAlignment: CrossAxisAlignment.start,
                                                                            //                                               mainAxisAlignment: MainAxisAlignment.start,
                                                                            //                                               children: [
                                                                            //                                                 Container(
                                                                            //                                                   margin: EdgeInsets.only(right: 10),
                                                                            //                                                   child: user.data!.docs[u]['photoUrl']!= null
                                                                            //                                                       ? ClipRRect(
                                                                            //                                                       borderRadius: BorderRadius.circular(50),
                                                                            //                                                       child:
                                                                            //                                                       // user.data!.docs[u]['photoUrl']!=null ?
                                                                            //                                                       Image.network(
                                                                            //                                                         '${user.data!.docs[u]['photoUrl']}',
                                                                            //                                                         width: 50,
                                                                            //                                                         height: 50,
                                                                            //                                                         fit: BoxFit.fill,
                                                                            //                                                       ))
                                                                            //                                                       : Container(
                                                                            //                                                     width: 50,
                                                                            //                                                     height: 50,
                                                                            //                                                     decoration: BoxDecoration(
                                                                            //                                                       color: Colors.white,
                                                                            //                                                       borderRadius: BorderRadius.circular(50),
                                                                            //                                                     ),
                                                                            //                                                     child: Center(
                                                                            //                                                         child: Text(
                                                                            //                                                           '${ user.data!.docs[u]['email'].split('@')[0][0]}'.toCapitalCase(),
                                                                            //                                                           style: TextStyle(fontSize: 40),
                                                                            //                                                         )),
                                                                            //                                                   ),
                                                                            //                                                 ),
                                                                            //                                                 Container(
                                                                            //                                                     child: Column(
                                                                            //                                                       crossAxisAlignment: CrossAxisAlignment.start,
                                                                            //                                                       mainAxisAlignment: MainAxisAlignment.start,
                                                                            //                                                       children: [
                                                                            //                                                         SizedBox(
                                                                            //                                                           height: 5,
                                                                            //                                                         ),
                                                                            //                                                         Container(
                                                                            //                                                           //${user.data!.docs[u]['displayName']!=null ? user.data!.docs[u]['displayName']:user.data!.docs[u]['email'].split('@')[0]}  ${snapshot.data!.docs[c]['date']}
                                                                            //                                                           width: MediaQuery.of(context).size.width - 178,
                                                                            //                                                           child: Text(
                                                                            //                                                             '${ user.data!.docs[u]['displayName']==null ?  user.data!.docs[u]['email'].split('@')[0]: user.data!.docs[u]['displayName']} ${snapshot.data!.docs[c]['date']}',
                                                                            //                                                             style: GoogleFonts.roboto(fontSize: 14),
                                                                            //                                                           ),
                                                                            //                                                         ),
                                                                            //                                                         SizedBox(
                                                                            //                                                           height: 5,
                                                                            //                                                         ),
                                                                            //                                                         Container(
                                                                            //                                                           // ${snapshot.data!.docs[c]['comment']}
                                                                            //                                                             width: MediaQuery.of(context).size.width - 70,
                                                                            //                                                             child: Text(
                                                                            //                                                               "${snapshot.data!.docs[c]['comment']}",
                                                                            //                                                               textAlign: TextAlign.justify,
                                                                            //                                                               style: GoogleFonts.roboto(fontSize: 18),
                                                                            //                                                             )),
                                                                            //                                                         SizedBox(
                                                                            //                                                           height: 5,
                                                                            //                                                         ),
                                                                            //                                                         Container(
                                                                            //                                                           width: MediaQuery.of(context).size.width - 60,
                                                                            //                                                           child: Row(
                                                                            //                                                             crossAxisAlignment: CrossAxisAlignment.center,
                                                                            //                                                             mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                            //                                                             children: [
                                                                            //                                                               Container(
                                                                            //                                                                 child: Row(
                                                                            //                                                                   children: [
                                                                            //                                                                     InkWell(
                                                                            //                                                                         onTap: () {},
                                                                            //                                                                         child: Icon(Icons.thumb_up_alt_outlined)),
                                                                            //                                                                     SizedBox(
                                                                            //                                                                       width: 5,
                                                                            //                                                                     ),
                                                                            //                                                                     Container(
                                                                            //                                                                       child: Text(
                                                                            //                                                                         '${snapshot.data!.docs[c]['like']}',
                                                                            //                                                                         style: GoogleFonts.roboto(color: Colors.black),
                                                                            //                                                                       ),
                                                                            //                                                                     )
                                                                            //                                                                   ],
                                                                            //                                                                 ),
                                                                            //                                                               ),
                                                                            //                                                               Container(
                                                                            //                                                                 child: Row(
                                                                            //                                                                   children: [
                                                                            //                                                                     InkWell(
                                                                            //                                                                         onTap: () {},
                                                                            //                                                                         child: Icon(Icons.thumb_down_alt_outlined)),
                                                                            //                                                                     SizedBox(
                                                                            //                                                                       width: 5,
                                                                            //                                                                     ),
                                                                            //                                                                     Container(
                                                                            //                                                                       child: Text(
                                                                            //                                                                         '${snapshot.data!.docs[c]['dislike']}',
                                                                            //                                                                         style: GoogleFonts.roboto(color: Colors.blueGrey),
                                                                            //                                                                       ),
                                                                            //                                                                     )
                                                                            //                                                                   ],
                                                                            //                                                                 ),
                                                                            //                                                               ),
                                                                            //                                                               Container(
                                                                            //                                                                 child: InkWell(
                                                                            //                                                                     onTap: () {}, child: Icon(Icons.comment_outlined)),
                                                                            //                                                               ),
                                                                            //                                                             ],
                                                                            //                                                           ),
                                                                            //                                                         )
                                                                            //                                                       ],
                                                                            //                                                     )),
                                                                            //                                               ],
                                                                            //                                             ),
                                                                            //                                           )
                                                                            //                                               : Container();
                                                                            //                                         }),
                                                                            //                                   );
                                                                            //                                 }
                                                                            //                                 return Container();
                                                                            //                               }),
                                                                            //                         );
                                                                            //                       }
                                                                            //                       return Container(
                                                                            //                         child: Center(child: CircularProgressIndicator()),
                                                                            //                       );
                                                                            //                     });
                                                                            //               }
                                                                            //               return Container(
                                                                            //                 child: Center(
                                                                            //                   child: CircularProgressIndicator(
                                                                            //                     color: Colors.pink,
                                                                            //                   ),
                                                                            //                 ),
                                                                            //               );
                                                                            //             }),
                                                                            //       );
                                                                            //     });
                                                                          },
                                                                          child: Align(
                                                                              alignment: Alignment.center,
                                                                              child: Container(
                                                                                child: Text(
                                                                                  '${snapshot.data!.docs.length}',
                                                                                  style: GoogleFonts.workSans(fontSize: 18, fontWeight: FontWeight.bold, color: CustomColors.white),
                                                                                ),
                                                                              )),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )
                                                                : Container();
                                                          }),
                                                    );
                                                  }
                                                  return Center();
                                                }),
                                          )
                                        ],
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: ClipRRect(
                                          // borderRadius: BorderRadius.only(topLeft: Radius.circular(150),topRight: Radius.circular(190)),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              // shape: BoxShape.values.setAll(index, iterable),
                                              // color: Colors.red,
                                              // borderRadius: BorderRadius.only(topLeft: Radius.circular(150),topRight: Radius.circular(200)),
                                              image:

                                              DecorationImage(
                                                  fit:BoxFit.fill,

                                                  image:  _imageProvider,

                                              ),
                                            ),
                                            height: 500,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  child: Text(
                                                    '35 ',
                                                    style: GoogleFonts.roboto(
                                                        color: Colors.white,
                                                        fontSize: 50),
                                                  ),
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      child: Text(
                                                        'coins / bouns  ',
                                                        style:
                                                            GoogleFonts.roboto(
                                                                color: Colors
                                                                    .white),
                                                      ),
                                                    ),
                                                    Container(
                                                        child: Image.asset(
                                                      'images/coins.png',
                                                      width: 40,
                                                    )),
                                                  ],
                                                ),
                                                Container(
                                                  child: CustomIconButton(
                                                    onTap: () {},
                                                    title: 'Unlock',
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Container(
                                                  child: Text(
                                                    'Balance: 5 coins',
                                                    style: GoogleFonts.roboto(
                                                        color: Colors.white),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Container();
                          });
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }
}

// hum ne muhammad  ko musa jesa nabi paya
//     or hum ne muhammad katuskra puraney kitabo main purha
