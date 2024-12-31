import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laylah/provider/AppFunctions.dart';
import 'package:laylah/utils/default_stlye.dart';
import 'package:provider/provider.dart';

class UserBooks extends StatefulWidget {
  var user_id;
   UserBooks({super.key,required this.user_id});

  @override
  State<UserBooks> createState() => _UserBooksState();
}

class _UserBooksState extends State<UserBooks> {



  @override
  Widget build(BuildContext context) {
    final provider=Provider.of<AppFunctions>(context,listen: false);

    return provider.publish==true ? StreamBuilder(
        stream: FirebaseFirestore.instance.collection('books').snapshots(),
        builder: (context, snapshot) {
          return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context,int index) {
                return
                  snapshot.data!.docs[index]['section']!='undefind'?
                  widget.user_id==snapshot.data!.docs[index]['writer_id']?
                Container(
                  margin: EdgeInsets.only(bottom:32,),
                  height: 180,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0, 12), // This controls the shadow's position in (x, y) coordinates
                        blurRadius: 12.0, // This controls the amount of blur in the shadow
                        spreadRadius: 0.0, // This controls the spread of the shadow
                      ),
                    ],
                    color: Colors.white,
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Row(children: [
                    Container(
                      // width: 100,
                      // height: 180,
                      child: Column(children: [
                        Container(
                          margin:EdgeInsets.all(5),
                          child: Image.network('${snapshot.data!.docs[index]['cover']}',width: 110,height: 160,fit: BoxFit.fill,),),
                      ],),),
                    Container(
                      width: MediaQuery.of(context).size.width-120,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.all(8),
                            child: Text('${snapshot.data!.docs[index]['book_title']}',style: DefaultStyle.blackStyle18bold,),),
                          Container(
                            margin: EdgeInsets.all(8),
                            child: Text("${snapshot.data!.docs[index]['descriptions']}",
                              maxLines: 5,
                              textAlign: TextAlign.justify,
                              style: DefaultStyle.blackNormal,),),
                          Container(child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(child: Icon(Icons.remove_red_eye_outlined),),
                              Container(child: Text("${snapshot.data!.docs[index]['view']}",style: DefaultStyle.blackNormal,),),
                              Container(child: Icon(MaterialCommunityIcons.thumb_up_outline),),
                              StreamBuilder(
                                  stream: FirebaseFirestore.instance.collection('books').doc(snapshot.data!.docs[index]['id']).collection('likes').snapshots(),
                                  builder: (context, snapshot) {
                                    if(snapshot.hasData){
                                      return Container(child: Text("${snapshot.data!.docs.length>1000 ? "${snapshot.data?.docs.length}"+'K':snapshot.data?.docs.length}",style: DefaultStyle.blackNormal,),);
                                    }
                                    return Center(child: CircularProgressIndicator(color: Colors.pink,),);
                                  }
                              ),
                              Container(child: Icon(MaterialCommunityIcons.menu),),
                              StreamBuilder(
                                  stream: FirebaseFirestore.instance.collection('books').doc(snapshot.data!.docs[index]['id']).collection('chapter').snapshots(),
                                  builder: (context, snapshot) {
                                    if(snapshot.hasData){
                                      return Container(child: Text("${snapshot.data?.docs.length}",style: DefaultStyle.blackNormal,),);
                                    }
                                  return Center(child: CircularProgressIndicator(color: Colors.pink,),);
                                  }
                              ),

                            ],),)
                        ],),),
                  ],),):Container():Container();
              }
          );
        }
    ):Container(

      decoration: BoxDecoration(),
      child: Container(
        margin: EdgeInsets.only(top: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(child: Image.asset('images/no_book.png',width: 100,color: Colors.grey,),),
          Text('This user has not published any book',style: GoogleFonts.roboto(color: Colors.grey),),
        ],
    ),
      ),);
  }
}
