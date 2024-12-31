import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:laylah/auth/apply_for_contract1.dart';
import 'package:laylah/auth/contract_check.dart';
import 'package:laylah/components/add_chapter.dart';
import 'package:laylah/components/custom_button.dart';

import '../utils/colors.dart';

class WrittenBook extends StatefulWidget {
  var book_title;
  var status;
  var views;
  var remarks;
  var cover;
  var id;
  var applied;
  var words;
  WrittenBook(
      {super.key,
      required this.book_title,
      required this.remarks,
      required this.status,
      required this.cover,
      required this.id,
      required this.words,
      required this.views,
      required this.applied,
      
      });

  @override
  State<WrittenBook> createState() => _WrittenBookState();
}

class _WrittenBookState extends State<WrittenBook> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
      height: 350,
      child: Column(children: [
        Container(
          alignment: Alignment.topRight,
          child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                leading: Icon(Icons.add),
                                title: Text('Add Chapter'),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AddChapter(
                                                id: widget.id,
                                                title: widget.book_title,
                                                words: widget.words,
                                              )));
                                  // Perform share action
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.delete),
                                title: Text('Delete'),
                                onTap: () {
                                  // Perform delete action
                                  FirebaseFirestore.instance
                                      .collection('books')
                                      .doc(widget.id)
                                      .delete()
                                      .then((value) =>
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  backgroundColor:
                                                      CustomColors.AppColor1,
                                                  content: Text('Deleted'))));
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            height:
                                10), // Add spacing between border and content
                        ListTile(
                          leading: Icon(Icons.close),
                          title: Text('Close'),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Icon(Icons.more_horiz)),
        ),
        Container(
          child: Row(
            children: [
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(12)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      6.0), // Adjust the radius as per your needs
                  child: Image.network(
                    widget.cover,
                    width: 100,
                    height: 130,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        // width: 100,
                        margin: EdgeInsets.only(left: 12),
                        alignment: Alignment.center,

                        padding: EdgeInsets.all(4),
                        child: Text(
                          '${widget.book_title}',
                          style: GoogleFonts.ptSerif(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        // width: 100,
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(left: 12),
                        padding: EdgeInsets.all(4),
                        child: Text(
                          '${widget.status}',
                          style: GoogleFonts.ptSerif(
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 12),
                        width: MediaQuery.of(context).size.width - 160,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 70,
                              // color: Colors.green,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    child: Icon(
                                      AntDesign.heart,
                                      size: 19,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('books')
                                          .doc(widget.id)
                                          .collection('likes')
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Container(
                                              child: Text(
                                            '${snapshot.data!.docs.length}',
                                            style: GoogleFonts.ptSerif(
                                                fontSize: 17,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.grey),
                                          ));
                                        }
                                        return Center();
                                      }),
                                  Container(
                                    child: Icon(
                                      AntDesign.question,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 70,
                              // color: Colors.green,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    child: Icon(
                                      Icons.remove_red_eye,
                                      size: 25,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Container(
                                      child: Text(
                                    '${widget.views}',
                                    style: GoogleFonts.ptSerif(
                                        fontSize: 17,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey),
                                  )),
                                  Container(
                                    child: Icon(
                                      AntDesign.question,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 12),
                        width: MediaQuery.of(context).size.width - 160,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 70,
                              // color: Colors.green,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.grey),
                                    child: Icon(
                                      MaterialCommunityIcons.format_text,
                                      size: 19,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Container(
                                      child: Text(
                                    '${widget.words}',
                                    style: GoogleFonts.ptSerif(
                                        fontSize: 17,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey),
                                  )),
                                  Container(
                                    child: Icon(
                                      AntDesign.question,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 70,
                              // color: Colors.green,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    child: Icon(
                                      MaterialIcons.rate_review,
                                      size: 25,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('books')
                                          .doc(widget.id)
                                          .collection('comments')
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Container(
                                              child: Text(
                                            '${snapshot.data!.docs.length}',
                                            style: GoogleFonts.ptSerif(
                                                fontSize: 17,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.grey),
                                          ));
                                        }
                                        return Center();
                                      }),
                                  Container(
                                    child: Icon(
                                      AntDesign.question,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ]),
              )
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        // Container(
        //   margin: EdgeInsets.all(5),
        //   child: Text(
        //     'Apply for contract and get a singing bonus of \$100 NOW!',
        //     style: GoogleFonts.ptSerif(color: Colors.grey.shade600),
        //   ),
        // ),
        InkWell(
          onTap: () {
            // Navigator.pop(context);
          },
          child: Container(
            alignment: Alignment.centerRight,
            child: CustomButton(
              onTap: widget.applied==false ? () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ContractCheck(book_id:widget.id)));
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                            actions: [
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Expanded(
                                  child: Container(
                                    height: 40,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                        color: CustomColors.AppColor1,
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Text(
                                      'Ok',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            title: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Text('Warm Reminder'),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    child: Text(
                                      """1: To retrieve the Map data from SharedPreferences, you need to retrieve
2:string value,decode it back to a Map using json.decode(), and handle any potential exceptions. Here's an example:
3:string value,decode it back to a Map using json.decode(), and handle any potential exceptions. Here's an example:
                                             """,
                                      style: GoogleFonts.ptSerif(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            )));
              }:(){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Book is under review")));
              },
              color: null,
              text_color: null,
              text: widget.applied==false ? 'Apply for contract':"Under Review",
            ),
          ),

//             Container(
//               width: 300,
//               alignment: Alignment.topRight,
//               decoration:
//                   BoxDecoration(borderRadius: BorderRadius.circular(12)),
//               child: ElevatedButton(
//                   style: ButtonStyle(
//                       backgroundColor:
//                           MaterialStatePropertyAll(CustomColors.AppColor1)),
//                   child: Text('Apply for contract'),
//                   onPressed: () {
//                     Navigator.push(context,
//                         MaterialPageRoute(builder: (context) => AcPersonal()));
//                     showDialog(
//                         context: context,
//                         builder: (context) => AlertDialog(
//                                 actions: [
//                                   InkWell(
//                                     onTap: () {
//                                       Navigator.pop(context);
//                                     },
//                                     child: Expanded(
//                                       child: Container(
//                                         height: 40,
//                                         alignment: Alignment.center,
//                                         padding: EdgeInsets.all(6),
//                                         decoration: BoxDecoration(
//                                             color: CustomColors.AppColor1,
//                                             borderRadius:
//                                                 BorderRadius.circular(12)),
//                                         child: Text(
//                                           'Ok',
//                                           style: TextStyle(color: Colors.white),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                                 title: Container(
//                                   width: MediaQuery.of(context).size.width,
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Container(
//                                         child: Text('Warm Reminder'),
//                                       ),
//                                       SizedBox(
//                                         height: 10,
//                                       ),
//                                       Container(
//                                         child: Text(
//                                           """1: To retrieve the Map data from SharedPreferences, you need to retrieve
// 2:string value,decode it back to a Map using json.decode(), and handle any potential exceptions. Here's an example:
// 3:string value,decode it back to a Map using json.decode(), and handle any potential exceptions. Here's an example:
//                                              """,
//                                           style: GoogleFonts.ptSerif(
//                                               color: Colors.black54,
//                                               fontWeight: FontWeight.w500,
//                                               fontSize: 14),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 )));
//                   }),
//             ),
        ),
        Divider(
          color: Colors.grey,
          height: 3,
        ),
        Container(
          margin: EdgeInsets.all(5),
          child: Text(
            'Remarks',
            style: GoogleFonts.ptSerif(
                color: Colors.black, fontWeight: FontWeight.w500),
          ),
        ),
        Container(
          margin: EdgeInsets.all(5),
          child: Text(
            '${widget.remarks}',
            style: GoogleFonts.ptSerif(color: Colors.grey.shade600),
          ),
        ),
      ]),
    );
  }
}
