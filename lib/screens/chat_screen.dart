import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:laylah/components/input_text.dart';
import 'package:laylah/provider/AppFunctions.dart';
import 'package:laylah/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../utils/colors.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController sms = TextEditingController();
  ScrollController _scrollController = ScrollController();

  var width = 0;


  @override
  Widget build(BuildContext context) {
    final provider=Provider.of<AppFunctions>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back,color: Colors.pink,),
          ),

          flexibleSpace: Container(
            decoration: BoxDecoration(
              color:  HexColor('#f8f2f6'),
                // gradient: LinearGradient(
                //     colors: [CustomColors.AppColor1, CustomColors.AppColor2])
        ),
          ),
          title: Text('Chat',style: GoogleFonts.roboto(color: Colors.pink),)),

      body: Container(
        color: Colors.blueGrey.shade50,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                // height: MediaQuery.of(context).size.height - 700,
                margin: EdgeInsets.only(bottom: 60),
                child: SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height - (180 + width),
                    child:    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('chat')
                            .orderBy('order_date')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return provider.chat_user==1 ?
                            ListView.builder(
                                // physics: NeverScrollableScrollPhysics(),
                                // controller: _scrollController,
                                // reverse: true,
                                shrinkWrap: true,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, int index) {
                                  return

                                    snapshot.data!.docs[index]['user_id']==provider.user_id
                                      ? Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(6)),
                                          padding: EdgeInsets.all(8),
                                          margin: snapshot.data!.docs[index]
                                                      ['user_id'] ==
                                                  provider.user_id
                                              ? EdgeInsets.only(
                                                  left: 30,
                                                  top: 5,
                                                  right: 5,
                                                  bottom: 5)
                                              : EdgeInsets.only(
                                                  right: 30,
                                                  bottom: 5,
                                                  top: 5,
                                                ),
                                          child: Column(
                                            children: [
                                              Container(
                                                alignment: Alignment.topLeft,
                                                child: SelectableText(
                                                  '${snapshot.data!.docs[index]['sms']}',
                                                  style: GoogleFonts.roboto(
                                                      color: CustomColors.black87,
                                                      fontSize: 18),
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.topRight,
                                                child: Text(
                                                  '${snapshot.data!.docs[index]['date_time']}',
                                                  style: GoogleFonts.roboto(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey,
                                                      fontSize: 12),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ):Container();

                                }):
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(child: Image.asset('images/sms1.png',height: 150,width: 150,fit: BoxFit.fill,),),
                                    Container(child: Text('No Messages Yet',style: GoogleFonts.inter(fontSize: 20),),),
                                    Container(
                                      margin:EdgeInsets.all(12),
                                      child: Text('No Messages in your inbox yet start chatting with admin',

                                        style: GoogleFonts.inter(
color: Colors.grey,
                                          fontSize: 18
                                        ),
                                      textAlign: TextAlign.center,
                                      ),

                                    )
                                  ],
                                );
                          }
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 60,
                // alignment: Alignment.bottomCenter,
                width: MediaQuery.of(context).size.width,
                // color: CustomColors.blue50,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [

                  CustomColors.AppColor1,
                  CustomColors.AppColor2
                ])),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          width = 250;
                        });
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width - 60,
                        child: TextFormField(
                          onTapOutside: (event) {
                            setState(() {
                              width = 0;
                            });
                          },
                          onTap: () {
                            setState(() {
                              width = 250;
                            });
                          },
                          controller: sms,
                          decoration: InputDecoration(
                              hintText: 'Type a message',
                              contentPadding: EdgeInsets.all(4),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none),
                              fillColor: CustomColors.white,
                              filled: true),
                        ),
                      ),
                    ),
                    Container(
                      child: MouseRegion(
                        onEnter: (e) {},
                        onExit: (e) {},
                        child: InkWell(
                          onTap: () async{
                        provider.checkChatUser(1);
                            var storage=FlutterSecureStorage();
                          var user_ids=  await storage.read(key: 'uid');
                          if(user_ids!=null){
                            if (sms.text.isNotEmpty) {
                              var date = DateTime.now();
                              var user_id = Uuid().v1();
                              FirebaseFirestore.instance
                                  .collection('chat')
                                  .doc(user_id)
                                  .set({
                                'sms': sms.text,
                                'id': user_id,
                                'user_id':user_ids,
                                'user': true,
                                'order_date': DateTime.now(),
                                'date_time':
                                "${date.year}-${date.month}-${date.day} ${date.hour}:${date.minute}"
                              }).then((value) {
                                sms.clear();
                              });
                            }
                          }else{
                         Navigator.push(context, MaterialPageRoute(builder: (context)=>SplashScreen()));
                          }

                          },
                          child: Icon(
                            Icons.send,
                            size: 45,
                            color: CustomColors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // bottomSheet: Container(
      //   height: 60,
      //   // alignment: Alignment.bottomCenter,
      //   width: MediaQuery.of(context).size.width,
      //   // color: CustomColors.blue50,
      //   decoration: BoxDecoration(
      //       gradient: LinearGradient(
      //           colors: [CustomColors.AppColor1, CustomColors.AppColor2])),
      //   child: Row(
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //     children: [
      //       Container(
      //         height: 50,
      //         width: MediaQuery.of(context).size.width - 60,
      //         child: TextFormField(
      //           controller: sms,
      //           decoration: InputDecoration(
      //               hintText: 'Type a message',
      //               contentPadding: EdgeInsets.all(4),
      //               border: OutlineInputBorder(
      //                   borderRadius: BorderRadius.circular(8),
      //                   borderSide: BorderSide.none),
      //               fillColor: CustomColors.white,
      //               filled: true),
      //         ),
      //       ),
      //       Container(
      //         child: MouseRegion(
      //           onEnter: (e) {},
      //           onExit: (e) {},
      //           child: InkWell(
      //             onTap: () {
      //               if (sms.text.isNotEmpty) {
      //                 var date = DateTime.now();
      //                 var user_id = Uuid().v1();
      //                 FirebaseFirestore.instance
      //                     .collection('chat')
      //                     .doc(user_id)
      //                     .set({
      //                   'sms': sms.text,
      //                   'id': user_id,
      //                   'user': true,
      //                   'order_date': DateTime.now(),
      //                   'date_time':
      //                       "${date.year}-${date.month}-${date.day} ${date.hour}:${date.minute}"
      //                 }).then((value) {
      //                   sms.clear();
      //                 });
      //               }
      //             },
      //             child: Icon(
      //               Icons.send,
      //               size: 45,
      //               color: CustomColors.white,
      //             ),
      //           ),
      //         ),
      //       )
      //     ],
      //   ),
      // ),

      // Container(
      //   color: CustomColors.blue50,
      //   child: Column(
      //     children: [
      //       Expanded(
      //         child: Container(
      //           height: MediaQuery.of(context).size.height - 180,
      //           child: StreamBuilder(
      //               stream: FirebaseFirestore.instance
      //                   .collection('chat')
      //                   .orderBy('order_date')
      //                   .snapshots(),
      //               builder: (context, snapshot) {
      //                 return ListView.builder(
      //                     controller: _scrollController,
      //                     // reverse: true,
      //                     shrinkWrap: true,
      //                     itemCount: snapshot.data!.docs.length,
      //                     itemBuilder: (context, int index) {
      //                       return snapshot.data!.docs.isNotEmpty
      //                           ? Container(
      //                               decoration: BoxDecoration(
      //                                   color: CustomColors.lightgreen,
      //                                   borderRadius: BorderRadius.circular(6)),
      //                               padding: EdgeInsets.all(8),
      //                               margin: snapshot.data!.docs[index]
      //                                           ['user'] ==
      //                                       true
      //                                   ? EdgeInsets.only(
      //                                       left: 30,
      //                                       top: 5,
      //                                       right: 5,
      //                                       bottom: 5)
      //                                   : EdgeInsets.only(
      //                                       right: 30,
      //                                       bottom: 5,
      //                                       top: 5,
      //                                     ),
      //                               child: Column(
      //                                 children: [
      //                                   Container(
      //                                     alignment: Alignment.topLeft,
      //                                     child: SelectableText(
      //                                       '${snapshot.data!.docs[index]['sms']}',
      //                                       style: GoogleFonts.ptSerif(
      //                                           color: CustomColors.white,
      //                                           fontSize: 18),
      //                                     ),
      //                                   ),
      //                                   Container(
      //                                     alignment: Alignment.topRight,
      //                                     child: Text(
      //                                       '${snapshot.data!.docs[index]['date_time']}',
      //                                       style: GoogleFonts.ptSerif(
      //                                           fontWeight: FontWeight.bold,
      //                                           color: CustomColors.black,
      //                                           fontSize: 18),
      //                                     ),
      //                                   ),
      //                                 ],
      //                               ),
      //                             )
      //                           : Container(
      //                               child: Text('Type a Sms '),
      //                             );
      //                     });
      //               }),
      //         ),
      //       ),
      //       Container(
      //         height: 60,
      //         // alignment: Alignment.bottomCenter,
      //         width: MediaQuery.of(context).size.width,
      //         // color: CustomColors.blue50,
      //         decoration: BoxDecoration(
      //             gradient: LinearGradient(colors: [
      //           CustomColors.AppColor1,
      //           CustomColors.AppColor2
      //         ])),
      //         child: Row(
      //           crossAxisAlignment: CrossAxisAlignment.center,
      //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //           children: [
      //             Container(
      //               height: 50,
      //               width: MediaQuery.of(context).size.width - 60,
      //               child: TextFormField(
      //                 controller: sms,
      //                 decoration: InputDecoration(
      //                     hintText: 'Type a message',
      //                     contentPadding: EdgeInsets.all(4),
      //                     border: OutlineInputBorder(
      //                         borderRadius: BorderRadius.circular(8),
      //                         borderSide: BorderSide.none),
      //                     fillColor: CustomColors.white,
      //                     filled: true),
      //               ),
      //             ),
      //             Container(
      //               child: MouseRegion(
      //                 onEnter: (e) {},
      //                 onExit: (e) {},
      //                 child: InkWell(
      //                   onTap: () {
      //                     if (sms.text.isNotEmpty) {
      //                       var date = DateTime.now();
      //                       var user_id = Uuid().v1();
      //                       FirebaseFirestore.instance
      //                           .collection('chat')
      //                           .doc(user_id)
      //                           .set({
      //                         'sms': sms.text,
      //                         'id': user_id,
      //                         'user': true,
      //                         'order_date': DateTime.now(),
      //                         'date_time':
      //                             "${date.year}-${date.month}-${date.day} ${date.hour}:${date.minute}"
      //                       }).then((value) {
      //                         sms.clear();
      //                       });
      //                     }
      //                     sendMessage();
      //                   },
      //                   child: Icon(
      //                     Icons.send,
      //                     size: 45,
      //                     color: CustomColors.white,
      //                   ),
      //                 ),
      //               ),
      //             )
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      // // bottomSheet: Container(
      // //   height: 60,
      // //   // alignment: Alignment.bottomCenter,
      // //   width: MediaQuery.of(context).size.width,
      // //   // color: CustomColors.blue50,
      // //   decoration: BoxDecoration(
      // //       gradient: LinearGradient(
      // //           colors: [CustomColors.AppColor1, CustomColors.AppColor2])),
      // //   child: Row(
      // //     crossAxisAlignment: CrossAxisAlignment.center,
      // //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      // //     children: [
      // //       Container(
      // //         height: 50,
      // //         width: MediaQuery.of(context).size.width - 60,
      // //         child: TextFormField(
      // //           controller: sms,
      // //           decoration: InputDecoration(
      // //               hintText: 'Type a message',
      // //               contentPadding: EdgeInsets.all(4),
      // //               border: OutlineInputBorder(
      // //                   borderRadius: BorderRadius.circular(8),
      // //                   borderSide: BorderSide.none),
      // //               fillColor: CustomColors.white,
      // //               filled: true),
      // //         ),
      // //       ),
      // //       Container(
      // //         child: MouseRegion(
      // //           onEnter: (e) {},
      // //           onExit: (e) {},
      // //           child: InkWell(
      // //             onTap: () {
      // //               if (sms.text.isNotEmpty) {
      // //                 var date = DateTime.now();
      // //                 var user_id = Uuid().v1();
      // //                 FirebaseFirestore.instance
      // //                     .collection('chat')
      // //                     .doc(user_id)
      // //                     .set({
      // //                   'sms': sms.text,
      // //                   'id': user_id,
      // //                   'user': true,
      // //                   'order_date': DateTime.now(),
      // //                   'date_time':
      // //                       "${date.year}-${date.month}-${date.day} ${date.hour}:${date.minute}"
      // //                 }).then((value) {
      // //                   sms.clear();
      // //                 });
      // //               }
      // //             },
      // //             child: Icon(
      // //               Icons.send,
      // //               size: 45,
      // //               color: CustomColors.white,
      // //             ),
      // //           ),
      // //         ),
      // //       )
      // //     ],
      // //   ),
      // // ),
    );
  }
}
