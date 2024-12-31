import 'package:change_case/change_case.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laylah/provider/AppFunctions.dart';
import 'package:laylah/screens/sub_comment.dart';
import 'package:laylah/utils/default_stlye.dart';
import 'package:provider/provider.dart';

class Comments extends StatefulWidget {
  var cover;
  var name;
  var date;
  var email;
  var likes;
  var dislike;
  var comments;
  var book_id;
  var chapter_id;
  var comment_id;
  var user_id;

  Comments({
    super.key,
    required this.date,
    required this.comments,
    required this.cover,
    required this.dislike,
    required this.likes,
    required this.name,
    required this.email,
    required this.user_id,
    required this.comment_id,
    required this.chapter_id,
    required this.book_id,
  });

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {

  bool comment_user=false;
  bool dislike=false;


  var storage = FlutterSecureStorage();

  CheckCommentUser(book_id, chapter_id, comment_id) async {
    var user_id = await storage.read(key: 'uid');
    final provider = Provider.of<AppFunctions>(context, listen: false);
    FirebaseFirestore.instance
        .collection('books')
        .doc(book_id)
        .collection('chapter')
        .doc(chapter_id)
        .collection('comments')
        .doc(comment_id)
        .collection('likes')
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
       setState(() {
         comment_user=false;
       });
      }
      if (value.docs.isNotEmpty) {
        for (var u in value.docs) {
          if (u.data().isNotEmpty) {
            if (u.data()['user_id'] == user_id) {
           setState(() {
             comment_user=true;

           });
           break;
            }
            if (u.data()['user_id'] != user_id) {
           setState(() {
             comment_user=false;

           });
            }
          }
        }
      }
    });
  }

  DislikeUser(book_id, chapter_id, comment_id) async {
    var user_id = await storage.read(key: 'uid');
    final provider = Provider.of<AppFunctions>(context, listen: false);
    FirebaseFirestore.instance
        .collection('books')
        .doc(book_id)
        .collection('chapter')
        .doc(chapter_id)
        .collection('comments')
        .doc(comment_id)
        .collection('dislikes')
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
       setState(() {
         dislike=false;
       });
      }
      if (value.docs.isNotEmpty) {
        for (var u in value.docs) {
          if (u.data().isNotEmpty) {
            if (u.data()['user_id'] == user_id) {
           setState(() {
             dislike=true;
           });
           break;
            }
            if (u.data()['user_id'] != user_id) {
           setState(() {
             dislike=false;
           });
            }
          }
        }
      }
    });
  }

  @override
  void initState() {
    CheckCommentUser(widget.book_id,widget.chapter_id,widget.comment_id);
    DislikeUser(widget.book_id,widget.chapter_id,widget.comment_id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    print('dislike $dislike');
    print('----');
    return Container(
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
              Container(
                width: MediaQuery.of(context).size.width - 84,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        height: 30,
                        width: 50,
                        child:

                              InkWell(
                              child: Container(
                                height: 30,
                                width: 50,

                                child: Row(
                                  children: [
                                 comment_user==false ?   InkWell(
                                        onTap: () async {
                                            CollectionReference itemCollection =
                                                FirebaseFirestore.instance
                                                    .collection('books')
                                                    .doc(widget.book_id)
                                                    .collection('chapter')
                                                    .doc(widget.chapter_id)
                                                    .collection('comments')
                                                    .doc(widget.comment_id)
                                                    .collection('likes');
                                            DocumentReference addData =
                                                await itemCollection.add({
                                              'user_id': widget.user_id,
                                              'like': 1,
                                            });
                                            String id = addData.id;
                                            await addData.update(
                                                {'id': id}).then((value) {
                                                  setState(() {
                                            comment_user=true;
                                                  });
                                            });

                                        },
                                        child:
                                            Icon(Icons.thumb_up_alt_outlined,)):
                                 InkWell(
                                     onTap: () async {
                                       if (comment_user == true) {
                                         FirebaseFirestore.instance
                                             .collection('books')
                                             .doc(widget.book_id)
                                             .collection('chapter')
                                             .doc(widget.chapter_id)
                                             .collection('comments')
                                             .doc(widget.comment_id)
                                             .collection('likes')
                                             .get()
                                             .then((value) {
                                           for (var user in value.docs) {
                                             if (user.data()['user_id'] ==
                                                 widget.user_id) {
                                               FirebaseFirestore.instance
                                                   .collection('books')
                                                   .doc(widget.book_id)
                                                   .collection('chapter')
                                                   .doc(widget.chapter_id).collection('comments').doc(widget.comment_id)
                                                   .collection('likes')
                                                   .doc(user
                                                   .data()['id'])
                                                   .delete();
                                             }
                                           }
                                         });
setState(() {
  comment_user=false;
});
                                       }

                                     },
                                     child:
                                     Icon(Icons.thumb_up_alt_outlined,)),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection('books')
                                            .doc(widget.book_id)
                                            .collection('chapter')
                                            .doc(widget.chapter_id)
                                            .collection('comments')
                                            .doc(widget.comment_id)
                                            .collection('likes')
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return Container(
                                              child: Text(
                                                '${snapshot.data?.docs.length}',
                                                style: GoogleFonts.roboto(
                                                    color: Colors.black),
                                              ),
                                            );

//                                   : Container(
//                                       height: 30,
//                                       width: 50,
//                                       child: Row(
//                                         children: [
//                                           Consumer<AppFunctions>(builder:
//                                               (context, provider, child) {
//                                             print('empty user${provider.empty}');
//                                             print(' user status ${provider.comment_user}');
//
//                                             return InkWell(
//                                                 onTap: () async {
//                                                   if (provider.empty == true) {
//                                                     CollectionReference
//                                                         itemCollection =
//                                                         FirebaseFirestore
//                                                             .instance
//                                                             .collection('books')
//                                                             .doc(widget.book_id)
//                                                             .collection(
//                                                                 'chapter')
//                                                             .doc(widget
//                                                                 .chapter_id)
//                                                             .collection(
//                                                                 'comments')
//                                                             .doc(widget
//                                                                 .comment_id)
//                                                             .collection(
//                                                                 'likes');
//                                                     DocumentReference addData =
//                                                         await itemCollection
//                                                             .add({
//                                                       'user_id': widget.user_id,
//                                                       'like': 1,
//                                                     });
//                                                     String id = addData.id;
//                                                     await addData.update({
//                                                       'id': id
//                                                     }).then((value) {});
// // var id=addData.id;
//                                                   }
//                                                   if (provider.comment_user ==
//                                                       false) {
//                                                     CollectionReference
//                                                         itemCollection =
//                                                         FirebaseFirestore
//                                                             .instance
//                                                             .collection('books')
//                                                             .doc(widget.book_id)
//                                                             .collection(
//                                                                 'chapter')
//                                                             .doc(widget
//                                                                 .chapter_id)
//                                                             .collection(
//                                                                 'comments')
//                                                             .doc(widget
//                                                                 .comment_id)
//                                                             .collection(
//                                                                 'likes');
//                                                     DocumentReference addData =
//                                                         await itemCollection
//                                                             .add({
//                                                       'user_id': widget.user_id,
//                                                       'like': 1,
//                                                     });
//                                                     String id = addData.id;
//                                                     await addData.update({
//                                                       'id': id
//                                                     }).then((value) {});
//                                                   }
//
//                                                 },
//                                                 child: Icon(Icons
//                                                     .thumb_up_alt_outlined));
//                                           }),
//                                           SizedBox(
//                                             width: 5,
//                                           ),
//                                           Container(
//                                             child: Text(
//                                               '${snapshot.data?.docs.length}',
//                                               style: GoogleFonts.roboto(
//                                                   color: Colors.black),
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                     );
                                          }
                                          return Container();
                                        }),
                                  ],
                                ),
                              ),
                            )
                        //   },
                        // )
  ),
                    Container(
                      child: Row(
                        children: [
                       dislike==false ?   InkWell(
                           onTap: () async {
                             CollectionReference itemCollection =
                             FirebaseFirestore.instance
                                 .collection('books')
                                 .doc(widget.book_id)
                                 .collection('chapter')
                                 .doc(widget.chapter_id)
                                 .collection('comments')
                                 .doc(widget.comment_id)
                                 .collection('dislike');
                             DocumentReference addData =
                             await itemCollection.add({
                               'user_id': widget.user_id,
                               'dislike': 1,
                             });
                             String id = addData.id;
                             await addData.update(
                                 {'id': id}).then((value) {
                               setState(() {
                                 dislike=true;
                               });
                             });

                           },
                              child: Icon(Icons.thumb_down_alt_outlined)):
                       InkWell(
                           onTap: () {
                             if (dislike == true) {
                               FirebaseFirestore.instance
                                   .collection('books')
                                   .doc(widget.book_id)
                                   .collection('chapter')
                                   .doc(widget.chapter_id)
                                   .collection('comments')
                                   .doc(widget.comment_id)
                                   .collection('dislike')
                                   .get()
                                   .then((value) {
                                 for (var user in value.docs) {
                                   if (user.data()['user_id'] ==
                                       widget.user_id) {
                                     FirebaseFirestore.instance
                                         .collection('books')
                                         .doc(widget.book_id)
                                         .collection('chapter')
                                         .doc(widget.chapter_id).collection('comments').doc(widget.comment_id)
                                         .collection('dislike')
                                         .doc(user
                                         .data()['id'])
                                         .delete();
                                   }
                                 }
                               });
                               setState(() {
                                 dislike=false;
                               });
                             }
                           },
                           child: Icon(Icons.thumb_down_alt_outlined)),
                          SizedBox(
                            width: 5,
                          ),
                          StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('books')
                                  .doc(widget.book_id)
                                  .collection('chapter')
                                  .doc(widget.chapter_id)
                                  .collection('comments')
                                  .doc(widget.comment_id)
                                  .collection('dislike')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Container(
                                    child: Text(
                                      '${snapshot.data?.docs.length}',
                                      style: GoogleFonts.roboto(
                                          color: Colors.black),
                                    ),
                                  );

//                                   : Container(
//                                       height: 30,
//                                       width: 50,
//                                       child: Row(
//                                         children: [
//                                           Consumer<AppFunctions>(builder:
//                                               (context, provider, child) {
//                                             print('empty user${provider.empty}');
//                                             print(' user status ${provider.comment_user}');
//
//                                             return InkWell(
//                                                 onTap: () async {
//                                                   if (provider.empty == true) {
//                                                     CollectionReference
//                                                         itemCollection =
//                                                         FirebaseFirestore
//                                                             .instance
//                                                             .collection('books')
//                                                             .doc(widget.book_id)
//                                                             .collection(
//                                                                 'chapter')
//                                                             .doc(widget
//                                                                 .chapter_id)
//                                                             .collection(
//                                                                 'comments')
//                                                             .doc(widget
//                                                                 .comment_id)
//                                                             .collection(
//                                                                 'likes');
//                                                     DocumentReference addData =
//                                                         await itemCollection
//                                                             .add({
//                                                       'user_id': widget.user_id,
//                                                       'like': 1,
//                                                     });
//                                                     String id = addData.id;
//                                                     await addData.update({
//                                                       'id': id
//                                                     }).then((value) {});
// // var id=addData.id;
//                                                   }
//                                                   if (provider.comment_user ==
//                                                       false) {
//                                                     CollectionReference
//                                                         itemCollection =
//                                                         FirebaseFirestore
//                                                             .instance
//                                                             .collection('books')
//                                                             .doc(widget.book_id)
//                                                             .collection(
//                                                                 'chapter')
//                                                             .doc(widget
//                                                                 .chapter_id)
//                                                             .collection(
//                                                                 'comments')
//                                                             .doc(widget
//                                                                 .comment_id)
//                                                             .collection(
//                                                                 'likes');
//                                                     DocumentReference addData =
//                                                         await itemCollection
//                                                             .add({
//                                                       'user_id': widget.user_id,
//                                                       'like': 1,
//                                                     });
//                                                     String id = addData.id;
//                                                     await addData.update({
//                                                       'id': id
//                                                     }).then((value) {});
//                                                   }
//
//                                                 },
//                                                 child: Icon(Icons
//                                                     .thumb_up_alt_outlined));
//                                           }),
//                                           SizedBox(
//                                             width: 5,
//                                           ),
//                                           Container(
//                                             child: Text(
//                                               '${snapshot.data?.docs.length}',
//                                               style: GoogleFonts.roboto(
//                                                   color: Colors.black),
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                     );
                                }
                                return Container();
                              }),
                        ],
                      ),
                    ),
                    Container(
                      child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SubComment(
                                          comment_id: widget.comment_id,
                                          book_id: widget.book_id,
                                          chapter_id: widget.chapter_id,
                                          date: null,
                                          comments: null,
                                          dislike: null,
                                          likes: null,
                                          cover: widget.cover,
                                          name: widget.name,
                                          email: widget.email,
                                          user_id: widget.user_id,
                                        )));
                          },
                          child: Icon(Icons.comment_outlined)),
                    ),
                  ],
                ),
              )
            ],
          )),
        ],
      ),
    );
  }
}
