import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:laylah/components/sub_comment_comp.dart';
import 'package:laylah/utils/default_stlye.dart';
import 'package:uuid/uuid.dart';

class SubComment extends StatefulWidget {
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

  SubComment({
    super.key,
    required this.comment_id,
    required this.book_id,
    required this.chapter_id,
    required this.date,
    required this.comments,
    required this.cover,
    required this.dislike,
    required this.likes,
    required this.name,
    required this.email,
    required this.user_id,
  });

  @override
  State<SubComment> createState() => _SubCommentState();
}

class _SubCommentState extends State<SubComment> {
  TextEditingController sms = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column
            (
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                // height: MediaQuery.of(context).size.height-113,
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('books')
                        .doc(widget.book_id)
                        .collection('chapter')
                        .doc(widget.chapter_id)
                        .collection('comments')
                        .doc(widget.comment_id)
                        .collection('subcomment').orderBy('date')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data!.docs.length > 0
                            ? Container(

                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, int index) {
                                    return SubCommentComp(
                                        date: snapshot.data!.docs[index]['date'],
                                        comments: snapshot.data!.docs[index]['sub_comment'],
                                        cover: widget.cover,
                                        dislike: widget.dislike,
                                        likes: widget.likes,
                                        name: widget.name,
                                        email: widget.email,
                                        comment_id: snapshot.data!.docs[index]['id'],
                                        chapter_id: widget.chapter_id,
                                        book_id: widget.book_id,
                                        user_id: widget.user_id);
                                  }),
                            )
                            : Container(
                                height: MediaQuery.of(context).size.height - 113,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Icon(
                                        Icons.comment,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Container(
                                        child: Text(
                                      'No Comments ',
                                      style: DefaultStyle.blackNormal,
                                    )),
                                  ],
                                ),
                              );
                      }
                      return Container();
                    }),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 75,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.blueGrey.shade50,
                          
                          borderRadius: BorderRadius.circular(12)),
                      child: TextField(
                        controller: sms,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(5),
                            border: InputBorder.none),
                      ),
                    ),
                    Container(
                      child: InkWell(
                          onTap: () async {
                            var storage = FlutterSecureStorage();
                            var comment_id = Uuid().v1();
                            var date = DateTime.now();
                            var user_id = await storage.read(key: 'uid');
                            FirebaseFirestore.instance
                                .collection('books')
                                .doc(widget.book_id)
                                .collection('chapter')
                                .doc(widget.chapter_id)
                                .collection('comments')
                                .doc(widget.comment_id)
                                .collection('subcomment')
                                .doc(comment_id)
                                .set({
                              'id': comment_id,
                              'sub_comment': sms.text,
                              'date':
                                  "${date.year}/${date.month}/${date.day}-${date.hour}:${date.minute}:${date.second}",
                              'like': 0,
                              'dislike': 0,
                              'user_id': user_id,
                            });
                            sms.clear();
                          },
                          child: Icon(
                            Icons.send,
                            color: Colors.grey,
                            size: 50,
                          )),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
