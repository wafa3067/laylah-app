import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laylah/components/cate_show.dart';
import 'package:provider/provider.dart';
import 'package:laylah/provider/set_state_class.dart';

class CategoryComp extends StatefulWidget {
  const CategoryComp({super.key});

  @override
  State<CategoryComp> createState() => _CategoryCompState();
}

class _CategoryCompState extends State<CategoryComp> {
  // List cate = ['hot', 'Rank', 'New', 'Comic', 'Post'];
  List cate = ['Love', 'Comic', "Drama's", "Nature", 'Science', "Fiction"];

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.amber,
      height: 30,
      margin: EdgeInsets.all(12),
      child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Genre').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return Consumer<SetStateClass>(
                      builder: (context, value, child) {
                    return InkWell(
                      onTap: () {
                        value.setCateindex(index);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CateShow(
                                    genre: snapshot.data!.docs[index]
                                        ['genre'])));
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 30,
                            padding: EdgeInsets.only(left: 15, right: 15),
                            child: Text(
                              '${snapshot.data!.docs[index]['genre']}'
                                  .toUpperCase(),
                              style: GoogleFonts.ptSerif(
                                  color: index == value.cate_index
                                      ? Colors.black
                                      : Colors.black54,
                                  fontWeight: index == value.cate_index
                                      ? FontWeight.w500
                                      : FontWeight.w400,
                                  fontSize: 20),
                            ),
                          ),
                          Container(
                            width: 40,
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: index == value.cate_index
                                        ? BorderSide(
                                            width: 2, color: Colors.black)
                                        : BorderSide.none)),
                          )
                        ],
                      ),
                    );
                  });
                },
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
