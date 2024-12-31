import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:laylah/components/card_horizonatl.dart';
import 'package:laylah/components/card_widget_vertical.dart';
import 'package:laylah/components/category_comp.dart';
import 'package:laylah/components/slider_comp.dart';
import 'package:laylah/provider/set_state_class.dart';
import 'package:laylah/screens/notification_screen.dart';
import 'package:laylah/screens/reward_screen.dart';
import 'package:laylah/screens/search_screen.dart';
import 'package:laylah/utils/colors.dart';
import 'package:provider/provider.dart';

import '../components/list_card.dart';

class HomeScreen extends StatefulWidget {
  var earn;
   HomeScreen({super.key,this.earn});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor:Colors.grey,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueGrey.shade50,
        flexibleSpace: Container(
            decoration: BoxDecoration(

            color: HexColor('#f8f2f6')
        )),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'images/logop.png',
              width: 130,
              height: 50,
              fit: BoxFit.fill,
            ),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchScreen()));
                  },
                  child: Image.asset(
                    'images/searchicon.png',
                    width: 30,
                    height: 30,
                    // color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotificationScreen()));
                  },
                  child: Image.asset(
                    'images/notificationicon.png',
                    width: 30,
                    height: 30,
                    // color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RewardScreen()));
                  },
                  child: Center(
                    child: Image.asset(
                      'images/giftboxicon.png',
                      width: 30,
                      height: 30,
                        // fit: BoxFit.fill,
                      // color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
              ],
            )
          ],
        ),
      ),
      // backgroundColor: HexColor('#f8f2f6'),
      body: SingleChildScrollView(
        child: Column(
          // shrinkWrap: true,
          children: [
            Consumer<SetStateClass>(
              builder: (context, myType, child) {

                return Container(
                    height: 56,
                    width: MediaQuery.of(context).size.width,
                    child: myType.connection == true
                        ? CategoryComp()
                        : Container(
                            height: 50,
                            margin: EdgeInsets.all(5),
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(6)),
                            child: Center(
                                child: Text(
                              'Connection Lost',
                              style: GoogleFonts.ptSerif(
                                  fontSize: 18, color: CustomColors.white),
                            )),
                          ));
              },
            ),
            Container(
              height: 160,
              child: SliderComp(),
            ),
            SizedBox(
              height: 5,
            ),
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
      ),
    );
  }
}
