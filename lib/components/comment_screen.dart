import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import '../provider/AppFunctions.dart';
import 'comments.dart';

class CommentScreen extends StatefulWidget {
  var id;
  var chapter_id;
  var comment_id;
  var user_id;

  CommentScreen(
      {super.key,
      required this.id,
      required this.chapter_id,
      required this.comment_id,
      required this.user_id
      });

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  // var storage=FlutterSecureStorage();
  //
  // CheckCommentUser(book_id,chapter_id,comment_id)async{
  //   var user_id=await storage.read(key: 'uid');
  //   final provider=Provider.of<AppFunctions>(context,listen: false);
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
  //
  //     if(value.docs.isEmpty){
  //       provider.CommentsData(false, true);
  //     }
  //     if(value.docs.isNotEmpty){
  //       for(var u in value.docs){
  //         if (u.data().isNotEmpty) {
  //           if(u.data()['user_id']==user_id){
  //             provider.CommentsData(true, false);
  //             provider.comment_user=true;
  //           }if(u.data()['user_id']!=user_id){
  //             provider.CommentsData(false, false);
  //           }
  //         }
  //       }
  //     }
  //
  //   });
  //
  //
  //
  // }
  //
  //
  // @override
  // void initState() {
  //   CheckCommentUser(widget.id,widget.chapter_id,widget.comment_id);
  //   super.initState();
  // }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('books')
              .doc(widget.id)
              .collection('chapter')
              .doc(widget.chapter_id)
              .collection('comments')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, int index) {
                    if (snapshot.hasData) {
                      return StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .snapshots(),
                          builder: (context, user) {
                            if (user.hasData) {
                              return Container(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: AlwaysScrollableScrollPhysics(),
                                    itemCount: user.data!.docs.length,
                                    itemBuilder: (context, int u) {
                                      return snapshot.data?.docs[index]
                                                  ['user_id'] ==
                                              user.data?.docs[u]['uid']
                                          ? Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  24,
                                              margin: EdgeInsets.all(12),
                                              // height: 200,
                                              child: Comments(
                                                  date: snapshot.data?.docs[index]
                                                      ['date'],
                                                  comments: snapshot.data?.docs[index]
                                                      ['comment'],
                                                  cover: user.data!.docs[u]
                                                      ['photoUrl'],
                                                  dislike: snapshot.data?.docs[index]
                                                      ['dislike'],
                                                  likes: snapshot.data?.docs[index]
                                                      ['like'],
                                                  name: user.data!.docs[u]
                                                      ['displayName'],
                                                  email: user.data!.docs[u]
                                                      ['email'],
                                                  chapter_id: widget.chapter_id,
                                                  book_id: widget.id,
                                                  comment_id: snapshot
                                                      .data!.docs[index]['id'],
                                                  user_id: widget.user_id),
                                            )
                                          : Container();
                                    }),
                              );
                            }
                            return Container();
                          });
                    }
                    return Container(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  });
            }
            return Container(
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.pink,
                ),
              ),
            );
          }),
    );
  }
}
