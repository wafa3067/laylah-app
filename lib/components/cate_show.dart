import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import '../screens/detail_screen.dart';
import '../screens/notification_screen.dart';
import '../screens/reward_screen.dart';
import '../screens/search_screen.dart';
import '../utils/colors.dart';

class CateShow extends StatefulWidget {
  var genre;
  CateShow({super.key, required this.genre});

  @override
  State<CateShow> createState() => _CateShowState();
}

class _CateShowState extends State<CateShow> {
  List book_title = [];
  List cover = [];
  List id = [];
  List genre = [];
  List libraries = [];

  getBooks()async {


    FirebaseFirestore.instance.collection('vertical').get().then((value) {
      for (var book in value.docs) {
        if (widget.genre == book.data()['genre']  && book.data()['section']!='undefind') {
          setState(() {
            book_title.add(book.data()['book_title']);
            cover.add(book.data()['cover']);
            id.add(book.data()['id']);
            genre.add(book.data()['genre']);
            libraries.add(book.data()['genre']);
          });
        }
      }
    }); FirebaseFirestore.instance.collection('horizontal').get().then((value) {
      for (var book in value.docs) {
        if (widget.genre == book.data()['genre'] && book.data()['section']!='undefind') {
          setState(() {
            book_title.add(book.data()['book_title']);
            cover.add(book.data()['cover']);
            id.add(book.data()['id']);
            genre.add(book.data()['genre']);
            libraries.add(book.data()['genre']);
          });
        }
      }
    });
    await FirebaseFirestore.instance.collection('listview').get().then((value) {
      for (var book in value.docs) {
        if (widget.genre == book.data()['genre'] && book.data()['section']!='undefind') {
          setState(() {
            book_title.add(book.data()['book_title']);
            cover.add(book.data()['cover']);
            id.add(book.data()['id']);
            genre.add(book.data()['genre']);
            libraries.add(book.data()['genre']);
          });
        }
      }
    });

  }

  @override
  void initState() {
    getBooks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
        // StreamBuilder(
        //     stream: FirebaseFirestore.instance.collection('books').snapshots(),
        //     builder: (context, snapshot) {
        //       if (snapshot.hasData) {
        //         return
        Scaffold(
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
      body: Container(
          // height: 100,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: CustomColors.white,
              borderRadius: BorderRadius.circular(8)),
          margin: EdgeInsets.only(left: 6, right: 6),
          child: AlignedGridView.count(
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 10,
            reverse: false,
            shrinkWrap: true,
            itemCount: book_title.toSet().length,
            itemBuilder: (context, index) {
              if (book_title.isNotEmpty) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailScreen(
                                  library: libraries[index],
                                  id: id[index],
                                  collection: 'vertical',
                                )));
                  },
                  child: Row(children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            3.0), // Adjust the radius as per your needs
                        child: Image.network(
                          '${cover[index]}',
                          width: 60,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    Container(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 100,
                              child: Text(
                                '${book_title[index]}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.ptSerif(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              // width: 100,
                              margin: EdgeInsets.all(2),
                              padding: EdgeInsets.only(
                                  left: 6, right: 12, top: 2, bottom: 2),
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(12)),
                              child: Text(
                                '${genre[index]}',
                                style: GoogleFonts.ptSerif(
                                    fontWeight: FontWeight.w400
                                    // fontWeight: FontWeight.w400,
                                    ),
                              ),
                            ),
                          ]),
                    )
                  ]),
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          )),
    );
    //   }
    //   return Center(
    //     child: CircularProgressIndicator(),
    //   );
    // });
  }
}
