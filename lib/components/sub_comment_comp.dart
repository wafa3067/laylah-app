import 'package:change_case/change_case.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laylah/provider/AppFunctions.dart';
import 'package:laylah/screens/sub_comment.dart';
import 'package:laylah/utils/default_stlye.dart';
import 'package:provider/provider.dart';

class SubCommentComp extends StatefulWidget {
  var cover;
  var name;
  var date;
  var email;
  var likes;
  var dislike;
  var comments;
  var user_id;

  var book_id;
  var chapter_id;
  var comment_id;

  SubCommentComp(
      {super.key,
        required this.date,
        required this.comments,
        required this.cover,
        required this.dislike,
        required this.likes,
        required this.name,
        required this.email,
        required this.comment_id,
        required this.chapter_id,
        required this.book_id,
        required this.user_id});

  @override
  State<SubCommentComp> createState() => _SubCommentCompState();
}

class _SubCommentCompState extends State<SubCommentComp> {
  var storage = FlutterSecureStorage();

  // CheckCommentUser(book_id, chapter_id, comment_id) async {
  //   var user_id = await storage.read(key: 'uid');
  //   final provider = Provider.of<AppFunctions>(context, listen: false);
  //   FirebaseFirestore.instance
  //       .collection('books')
  //       .doc(book_id)
  //       .collection('chapter')
  //       .doc(chapter_id)
  //       .collection('comments')
  //       .doc(comment_id)
  //       .collection('likes')
  //       .get()
  //       .then((value) {
  //     if (value.docs.isEmpty) {
  //       provider.CommentsData(false, true);
  //     }
  //     if (value.docs.isNotEmpty) {
  //       for (var u in value.docs) {
  //         if (u.data().isNotEmpty) {
  //           if (u.data()['user_id'] == user_id) {
  //             provider.CommentsData(true, false);
  //             provider.comment_user = true;
  //           }
  //           if (u.data()['user_id'] != user_id) {
  //             provider.CommentsData(false, false);
  //           }
  //         }
  //       }
  //     }
  //   });
  // }
  //
  // @override
  // void initState() {
  //   CheckCommentUser(widget.book_id, widget.chapter_id, widget.comment_id);
  //
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12,vertical: 5),
      color: Colors.white,
      width: MediaQuery.of(context).size.width - 24,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: widget.cover != null
                ? ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child:
                // user.data!.docs[u]['photoUrl']!=null ?
                Image.network(
                  '${widget.cover}',
                  width: 50,
                  height: 50,
                  fit: BoxFit.fill,
                ))
                : Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade50,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                  child: Text(
                    '${widget.email.split('@')[0][0]}'.toCapitalCase(),
                    style: TextStyle(fontSize: 40),
                  )),
            ),
          ),
          Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    //${user.data!.docs[u]['displayName']!=null ? user.data!.docs[u]['displayName']:user.data!.docs[u]['email'].split('@')[0]}  ${snapshot.data!.docs[c]['date']}
                    width: MediaQuery.of(context).size.width - 178,
                    child: Text(
                      '${widget.name == null ? widget.email.split('@')[0] : widget.name} ${widget.date}',
                      style: GoogleFonts.roboto(fontSize: 14),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    // ${snapshot.data!.docs[c]['comment']}
                      width: MediaQuery.of(context).size.width - 94,
                      child: Text(
                        "${widget.comments}",
                        textAlign: TextAlign.justify,
                        style: GoogleFonts.roboto(fontSize: 18),
                      )),
                  SizedBox(
                    height: 5,
                  ),
//                   Consumer<AppFunctions>(
//                     builder: (context, provider, child) {
//                       return provider.empty == false
//                           ? Container(
//                         width: MediaQuery.of(context).size.width - 84,
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             Container(
//                               height: 30,
//                               width: 50,
//                               child: StreamBuilder(
//                                   stream: FirebaseFirestore.instance
//                                       .collection('books')
//                                       .doc(widget.book_id)
//                                       .collection('chapter')
//                                       .doc(widget.chapter_id)
//                                       .collection('comments')
//                                       .doc(widget.comment_id)
//                                       .collection('likes')
//                                       .snapshots(),
//                                   builder: (context, snapshot) {
//                                     if (snapshot.hasData) {
//                                       return ListView.builder(
//                                           physics:
//                                           NeverScrollableScrollPhysics(),
//                                           itemCount:
//                                           snapshot.data!.docs.length,
//                                           itemBuilder: (context, int index) {
//                                             return Container(
//                                               height: 30,
//                                               width: 50,
//                                               child: Row(
//                                                 children: [
//                                                   InkWell(
//                                                       onTap: () async {
//                                                         if (provider.empty ==
//                                                             true) {
//                                                           CollectionReference
//                                                           itemCollection =
//                                                           FirebaseFirestore
//                                                               .instance
//                                                               .collection(
//                                                               'books')
//                                                               .doc(widget
//                                                               .book_id)
//                                                               .collection(
//                                                               'chapter')
//                                                               .doc(widget
//                                                               .chapter_id)
//                                                               .collection(
//                                                               'comments')
//                                                               .doc(widget
//                                                               .comment_id)
//                                                               .collection(
//                                                               'likes');
//                                                           DocumentReference
//                                                           addData =
//                                                           await itemCollection
//                                                               .add({
//                                                             'user_id': widget
//                                                                 .user_id,
//                                                             'like': 1,
//                                                           });
//                                                           String id =
//                                                               addData.id;
//                                                           await addData
//                                                               .update({
//                                                             'id': id
//                                                           }).then((value) {});
// // var id=addData.id;
//                                                         }
//                                                         if (provider
//                                                             .comment_user ==
//                                                             false) {
//                                                           CollectionReference
//                                                           itemCollection =
//                                                           FirebaseFirestore
//                                                               .instance
//                                                               .collection(
//                                                               'books')
//                                                               .doc(widget
//                                                               .book_id)
//                                                               .collection(
//                                                               'chapter')
//                                                               .doc(widget
//                                                               .chapter_id)
//                                                               .collection(
//                                                               'comments')
//                                                               .doc(widget
//                                                               .comment_id)
//                                                               .collection(
//                                                               'likes');
//                                                           DocumentReference
//                                                           addData =
//                                                           await itemCollection
//                                                               .add({
//                                                             'user_id': widget
//                                                                 .user_id,
//                                                             'like': 1,
//                                                           });
//                                                           String id =
//                                                               addData.id;
//                                                           await addData
//                                                               .update({
//                                                             'id': id
//                                                           }).then((value) {});
//                                                         }
//                                                         if (provider
//                                                             .comment_user ==
//                                                             true) {
//                                                           FirebaseFirestore
//                                                               .instance
//                                                               .collection(
//                                                               'books')
//                                                               .doc(widget
//                                                               .book_id)
//                                                               .collection(
//                                                               'chapter')
//                                                               .doc(widget
//                                                               .chapter_id)
//                                                               .collection(
//                                                               'comments')
//                                                               .doc(widget
//                                                               .comment_id)
//                                                               .collection(
//                                                               'likes')
//                                                               .doc(snapshot
//                                                               .data!
//                                                               .docs[
//                                                           index]['id'])
//                                                               .delete();
//                                                         }
//                                                         CheckCommentUser(
//                                                             widget.book_id,
//                                                             widget.comment_id,
//                                                             widget
//                                                                 .comment_id);
//                                                       },
//                                                       child: Icon(Icons
//                                                           .thumb_up_alt_outlined)),
//                                                   SizedBox(
//                                                     width: 5,
//                                                   ),
//                                                   Container(
//                                                     child: Text(
//                                                       '${snapshot.data?.docs.length}',
//                                                       style:
//                                                       GoogleFonts.roboto(
//                                                           color: Colors
//                                                               .black),
//                                                     ),
//                                                   )
//                                                 ],
//                                               ),
//                                             );
//                                           });
//                                     }
//
//                                     return Container();
//                                   }),
//                             ),
//                             Container(
//                               child: Row(
//                                 children: [
//                                   InkWell(
//                                       onTap: () {},
//                                       child: Icon(
//                                           Icons.thumb_down_alt_outlined)),
//                                   SizedBox(
//                                     width: 5,
//                                   ),
//                                   Container(
//                                     child: Text(
//                                       '${widget.dislike}',
//                                       style: GoogleFonts.roboto(
//                                           color: Colors.blueGrey),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//
//                           ],
//                         ),
//                       )
//                           : Container(
//                         width: MediaQuery.of(context).size.width - 84,
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             Container(
//                                 height: 30,
//                                 width: 50,
//                                 child: Container(
//                                   height: 30,
//                                   width: 50,
//                                   child: Row(
//                                     children: [
//                                       InkWell(
//                                           onTap: () async {
//                                             if (provider.empty == true) {
//                                               CollectionReference
//                                               itemCollection =
//                                               FirebaseFirestore.instance
//                                                   .collection('books')
//                                                   .doc(widget.book_id)
//                                                   .collection('chapter')
//                                                   .doc(widget.chapter_id)
//                                                   .collection('comments')
//                                                   .doc(widget.comment_id)
//                                                   .collection('likes');
//                                               DocumentReference addData =
//                                               await itemCollection.add({
//                                                 'user_id': widget.user_id,
//                                                 'like': 1,
//                                               });
//                                               String id = addData.id;
//                                               await addData
//                                                   .update({'id': id}).then(
//                                                       (value) {});
//                                             }
//                                             if (provider.comment_user ==
//                                                 false) {
//                                               CollectionReference
//                                               itemCollection =
//                                               FirebaseFirestore.instance
//                                                   .collection('books')
//                                                   .doc(widget.book_id)
//                                                   .collection('chapter')
//                                                   .doc(widget.chapter_id)
//                                                   .collection('comments')
//                                                   .doc(widget.comment_id)
//                                                   .collection('likes');
//                                               DocumentReference addData =
//                                               await itemCollection.add({
//                                                 'user_id': widget.user_id,
//                                                 'like': 1,
//                                               });
//                                               String id = addData.id;
//                                               await addData
//                                                   .update({'id': id}).then(
//                                                       (value) {});
//                                             }
//                                             CheckCommentUser(
//                                                 widget.book_id,
//                                                 widget.comment_id,
//                                                 widget.comment_id);
//                                           },
//                                           child: Icon(
//                                               Icons.thumb_up_alt_outlined)),
//                                       SizedBox(
//                                         width: 5,
//                                       ),
//                                       Container(
//                                         child: Text(
//                                           '0',
//                                           style: GoogleFonts.roboto(
//                                               color: Colors.black),
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 )),
//                             Container(
//                               child: Row(
//                                 children: [
//                                   InkWell(
//                                       onTap: () {},
//                                       child: Icon(
//                                           Icons.thumb_down_alt_outlined)),
//                                   SizedBox(
//                                     width: 5,
//                                   ),
//                                   Container(
//                                     child: Text(
//                                       '${widget.dislike}',
//                                       style: GoogleFonts.roboto(
//                                           color: Colors.blueGrey),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//
//                           ],
//                         ),
//                       );
//                     },
//                   ),
                ],
              )),
        ],
      ),
    );
  }
}
