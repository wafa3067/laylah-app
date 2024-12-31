import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens/detail_screen.dart';
import '../utils/colors.dart';

class CardWidgetVertical extends StatefulWidget {
  var section;
  var start;
  var comment;
  CardWidgetVertical({super.key, required this.section,this.start,this.comment});

  @override
  State<CardWidgetVertical> createState() => _CardWidgetVerticalState();
}

class _CardWidgetVerticalState extends State<CardWidgetVertical> {
  List book_title = [];
  List cover = [];
  List id = [];
  List genre = [];
  List libraries = [];

  getBooks() {
    FirebaseFirestore.instance.collection('vertical').get().then((value) {
      for (var book in value.docs) {
        if (widget.section == book.data()['section']) {
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

        Container(
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
              itemCount: book_title.length,
              itemBuilder: (context, index) {
                if (book_title.isNotEmpty) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailScreen(
                                comment: widget.comment,
                                start: widget.start,
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
                          child: CachedNetworkImage(
                            imageUrl: '${cover[index]}',
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
                                  style: GoogleFonts.roboto(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
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
                                  style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w400,
                                          fontSize:12,
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
            ));

  }
}
