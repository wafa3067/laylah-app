import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/card_horizonatl.dart';
import '../components/card_widget_vertical.dart';
import '../components/list_card.dart';
import '../utils/colors.dart';

class ReaderScreen extends StatefulWidget {

  const ReaderScreen({super.key});

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:
      ListView(
        shrinkWrap: true,
        children: [
          Container(
            // height: MediaQuery.of(context).size.height,
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('section')
                    .orderBy('display')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        shrinkWrap: true,
                        reverse: false,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, int index) {
                          if (snapshot.data!.docs[index]['axis'] ==
                              'Horizontal') {
                            return snapshot.data!.docs[index]['count'] == 1
                                ? Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 8),
                                  child: Text(
                                    '${snapshot.data!.docs[index]['section']}',
                                    style: GoogleFonts.workSans(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                // snapshot.data!.docs[index]['axis'] ==
                                //         'Horizontal'
                                //     ?
                                Container(
                                  height: 228,
                                  width: MediaQuery.of(context)
                                      .size
                                      .width -
                                      10,
                                  margin: EdgeInsets.only(
                                      bottom: 12, left: 8, right: 8),
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      color: CustomColors.white,
                                      borderRadius:
                                      BorderRadius.circular(8)),
                                  child: CardHorizontal(
                                    start:'yes',
                                      section: snapshot.data!
                                          .docs[index]['id']),
                                )
                              ],
                            )
                                : Container();
                          }
                          if (snapshot.data!.docs[index]['axis'] ==
                              'Vertical') {
                            return snapshot.data!.docs[index]['count'] == 1
                                ? Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 8),
                                  child: Text(
                                    '${snapshot.data!.docs[index]['section']}',
                                    style: GoogleFonts.ptSerif(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),

                                Container(
                                  child: CardWidgetVertical(
                                    start:'yes',
                                    section: snapshot.data!.docs[index]
                                    ['id'],
                                  ),
                                ),
                              ],
                            )
                                : Container();
                          }
                          if (snapshot.data!.docs[index]['axis'] ==
                              'ListView') {
                            return snapshot.data!.docs[index]['count'] == 1
                                ? Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  child: Text(
                                    '${snapshot.data!.docs[index]['section']}',
                                    style: GoogleFonts.ptSerif(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      bottom: 12, left: 8, right: 8),
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      color: CustomColors.white,
                                      borderRadius:
                                      BorderRadius.circular(8)),
                                  child: ListCard(
                                    start:'yes',
                                    section: snapshot.data!.docs[index]
                                    ['id'],
                                  ),
                                )
                              ],
                            )
                                : Container();
                          }
                        });
                  }
                  if (snapshot.connectionState == ConnectionState.none) {
                    return Center(
                      child: Text('Connection Failled'),
                    );
                  }
                  if (snapshot.hasError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${snapshot.hashCode}')));
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
