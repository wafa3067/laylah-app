import 'package:cached_network_image/cached_network_image.dart';
import 'package:change_case/change_case.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laylah/screens/detail_screen.dart';
import 'package:laylah/utils/colors.dart';

class CardHorizontal extends StatefulWidget {
  var section;
  var start;
  var comment;
  CardHorizontal({super.key, required this.section,this.start,this.comment});

  @override
  State<CardHorizontal> createState() => _CardHorizontalState();
}

class _CardHorizontalState extends State<CardHorizontal> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('horizontal').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data?.docs.length,
                scrollDirection: Axis.horizontal,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return widget.section == snapshot.data!.docs[index]['section']
                      ? InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailScreen(
                                     comment:widget.comment,
                                        start: widget.start,
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
                          child: Container(
                            // color: Colors.grey,
                            margin: EdgeInsets.all(6),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          6.0), // Adjust the radius as per your needs
                                      child: CachedNetworkImage(
                                     imageUrl: '${snapshot.data!.docs[index]['cover']}', // '${Images[index]}',
                                        width: 100,
                                        height: 130,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(3),
                                    width: 110,
                                    height: 50,
                                    child: Text(
                                      '${snapshot.data!.docs[index]['book_title']}'.toCapitalCase(),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.roboto(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 80,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    padding: EdgeInsets.all(4),
                                    child: Text(
                                      '${snapshot.data!.docs[index]['genre']}',
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.workSans(
                                        fontSize: 10,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ]),
                          ),
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
