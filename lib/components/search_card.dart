import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens/detail_screen.dart';
import '../utils/colors.dart';

class SearchCard extends StatefulWidget {
  var search;
  SearchCard({super.key, required this.search});

  @override
  State<SearchCard> createState() => _SearchCardState();
}

class _SearchCardState extends State<SearchCard> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('books').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data?.docs.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return snapshot.data!.docs[index]['book_title']
                          .toLowerCase()
                          .contains(widget.search.toLowerCase())
                      ? InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailScreen(
                                        collection: 'horizontal',
                                        library: snapshot.data!.docs[index]
                                            ['libraries'],
                                        id: snapshot.data!.docs[index]
                                            ['id']))).then((value) {
                              FirebaseFirestore.instance
                                  .collection('books')
                                  .doc(snapshot.data!.docs[index]['id'])
                                  .update({
                                'view': snapshot.data!.docs[index]['view'] + 1
                              });
                            });
                          },
                          child: widget.search != ''
                              ? Container(
                                  // color: Colors.grey,
                                  margin: EdgeInsets.all(6),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                6.0), // Adjust the radius as per your needs
                                            child: Image.network(
                                              '${snapshot.data!.docs[index]['cover']}',
                                              // '${Images[index]}',
                                              width: 100,
                                              height: 130,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(3),
                                          width: 100,
                                          height: 50,
                                          child: Text(
                                            '${snapshot.data!.docs[index]['book_title']}',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.roboto(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 100,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: Colors.grey.shade300,
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          padding: EdgeInsets.all(4),
                                          child: Text(
                                            '${snapshot.data!.docs[index]['genre']}',
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.roboto(
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ]),
                                )
                              : Container(),
                        )
                      : Container();
                });
          }
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: CustomColors.AppColor1,
              color: CustomColors.blue50,
            ),
          );
        });
  }
}
