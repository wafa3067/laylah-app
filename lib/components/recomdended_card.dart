import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens/detail_screen.dart';
import '../utils/colors.dart';
import 'package:change_case/change_case.dart';


class RecomdedCard extends StatefulWidget {
  const RecomdedCard({super.key});

  @override
  State<RecomdedCard> createState() => _RecomdedCardState();
}

class _RecomdedCardState extends State<RecomdedCard> {
  Widget build(BuildContext context) {
    return Container(
      height: 219,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('books').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data?.docs.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailScreen(
                                        collection: 'listview',
                                        library: snapshot.data!.docs[index]
                                            ['libraries'],
                                        id: snapshot.data!.docs[index]['id'])))
                            .then((value) {
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
                                    borderRadius: BorderRadius.circular(12)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      6.0), // Adjust the radius as per your needs
                                  child: Image.network(
                                    '${snapshot.data!.docs[index]['cover']}', // '${Images[index]}',
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
                                  '${snapshot.data!.docs[index]['book_title']}'.toCapitalCase(),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.roboto(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Container(
                                width: 80,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(12)),
                                padding: EdgeInsets.all(4),
                                child: Text(
                                  '${snapshot.data!.docs[index]['genre']}',
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.ptSerif(
                                    fontSize: 10,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    );
                  });
            }
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: CustomColors.AppColor1,
                color: CustomColors.blue50,
              ),
            );
          }),
    );
  }
}
