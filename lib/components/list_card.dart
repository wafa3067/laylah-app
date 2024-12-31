import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens/detail_screen.dart';

class ListCard extends StatefulWidget {
  var section;
  var start;
  var comment;
  ListCard({super.key, this.section,this.start,this.comment});

  @override
  State<ListCard> createState() => _ListCardState();
}

class _ListCardState extends State<ListCard> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('listview').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              width: MediaQuery.of(context).size.width - 10,
              // height: 100,
              child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, int index) {
                    return Container(
                      margin: EdgeInsets.all(1),
                      child: widget.section ==
                              snapshot.data!.docs[index]['section']
                          ? InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetailScreen(
                                          comment: widget.comment,
                                          start: widget.start,
                                              library: snapshot.data!
                                                  .docs[index]['libraries'],
                                              id: snapshot.data!.docs[index]
                                                  ['id'],
                                              collection: 'listview',
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
                                      imageUrl:   '${snapshot.data!.docs[index]['cover']}',
                                      width: 100,
                                      height: 130,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                                Container(
                                  height: 125,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              160,
                                          child: Text(
                                            '${snapshot.data!.docs[index]['book_title']}',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.roboto(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              175,
                                          child: Text(
                                            '${snapshot.data!.docs[index]['descriptions']}',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.roboto(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          height: 30,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              160,
                                          child: ListView(
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                            children: [
                                              for (var i in snapshot
                                                  .data!.docs[index]['tags'])
                                                Container(
                                                  // width: 100,
                                                  margin: EdgeInsets.all(2),
                                                  padding: EdgeInsets.all(
                                                      6),
                                                  decoration: BoxDecoration(
                                                      color:
                                                          Colors.grey.shade300,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12)),
                                                  child: Text(
                                                    '${i}',
                                                    style: GoogleFonts.roboto(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 10
                                                        // fontWeight: FontWeight.w400,
                                                        ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        )
                                      ]),
                                )
                              ]),
                            )
                          : Container(),
                    );
                  }),
            );
          }
          return Container();
        });
  }
}
