import 'package:cached_network_image/cached_network_image.dart';
import 'package:change_case/change_case.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:laylah/components/custom_button.dart';
import 'package:laylah/provider/set_state_class.dart';
import 'package:laylah/screens/detail_screen.dart';
import 'package:laylah/screens/reward_screen.dart';
import 'package:laylah/screens/search_screen.dart';

import 'package:provider/provider.dart';

import '../components/recomdended_card.dart';
import '../utils/colors.dart';
import 'notification_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {


  var storage = FlutterSecureStorage();
  List library = [];
  List library_id = [];
  var book_image = [];
  var book_title = [];
  var book_id = [];
  String? user = '';
bool load=true;

  GetUser() async {
    var user_id = await storage.read(key: 'uid');
    if (user_id != null) {
      FirebaseFirestore.instance.collection('library').get().then((libr) {
        for (var lib in libr.docs) {
          if (lib.data()['user_id'] == user_id) {
            FirebaseFirestore.instance.collection('books').get().then((value) {
              for (var e in value.docs) {
                if (lib.data()['book_id'] == e.data()['id']) {

                  setState(() {
                    load=false;
                    book_title.add(e.data()['book_title']);
                    book_image.add(e.data()['cover']);
                    book_id.add(e.data()['id']);
                    library.add(e.data()['libraries']);
                    library_id.add(lib.data()['id']);
                  });
                }
              }
            });

          }
        }
        // GetBooks();
      });
      setState(() {
        user = user_id;

      });
    }

  }




  bool page=true;
  @override
  void initState() {
    final provider=Provider.of<SetStateClass>(context,listen: false);
    GetUser();
    Future.delayed(Duration(seconds: 2),(){

setState((){
  page=false;
});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        appBar: AppBar(
          shadowColor:Colors.grey,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blueGrey.shade50,
          flexibleSpace: Container(
              decoration: BoxDecoration(

                  color: HexColor('#f8f2f6')
              )),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'images/logop.png',
                width: 130,
                height: 50,
                fit: BoxFit.fill,
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchScreen()));
                    },
                    child: Image.asset(
                      'images/searchicon.png',
                      width: 30,
                      height: 30,
                      // color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotificationScreen()));
                    },
                    child: Image.asset(
                      'images/notificationicon.png',
                      width: 30,
                      height: 30,
                      // color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RewardScreen()));
                    },
                    child: Center(
                      child: Image.asset(
                        'images/giftboxicon.png',
                        width: 30,
                        height: 30,
                        // fit: BoxFit.fill,
                        // color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                ],
              )
            ],
          ),
        ),
        backgroundColor: Colors.blueGrey.shade50,
        body:page==false?

        load==false
            ?
               Column(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height-442,
                    width: MediaQuery.of(context).size.width,
                    child: AlignedGridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      itemCount: book_title.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailScreen(
                                          id: book_id[index],
                                          library: library[index],
                                          collection: 'horizontal',
                                        )));
                          },
                          onLongPress: (){
                            showDialog(context: context, builder: (context){
                              return AlertDialog(title: Text('Are sure want to delete.'),
                              actions: [
                                Container(
                                  width:70,
                                  child: CustomButton(onTap: (){
                                      FirebaseFirestore.instance.collection('library').doc("${library_id[index]}").delete();
                                      library = [];
                                       library_id = [];
                                       book_image = [];
                                       book_title = [];
                                       book_id = [];
                                    GetUser();
                                    Navigator.pop(context);
                                  },
                                    text: 'Delete',text_color: null, color: null,
                                  gr_color1: Colors.pink,
                                  gr_color2: Colors.pink,
                                ),),
                                Container(
                                  width:70,
                                  child: CustomButton(onTap: (){
                                    Navigator.pop(context);
                                  },
                                    text: 'Cancel',text_color: Colors.black, color: null,
                                  gr_color1: Colors.blueGrey.shade50,
                                  gr_color2: Colors.blueGrey.shade50,
                                ),),
                              ],
                              );
                            });
                         
                          },
                          child: Container(
                            margin: EdgeInsets.all(5),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                               ),
                            child: Column(
                              children: [
                                Container(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CachedNetworkImage(

                                      height: 150,
                                      width: 130,
                                      fit: BoxFit.fill, imageUrl: '${book_image[index]}',

                                    ),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    '${book_title[index]}'.toCapitalCase(),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                    style: GoogleFonts.roboto(fontWeight: FontWeight.w700,
                                        fontSize: 12),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                // recomended books
                Container(
                  child: Column(children: [
                    Container(
                      margin: EdgeInsets.all(12),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Recommenced Books',
                        style: GoogleFonts.inter(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      height: 220,
                      child: RecomdedCard(),
                    )
                  ]),
                )
              ],
            )
            : Container(
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 90),

                          alignment: Alignment.bottomCenter,
                          // height: MediaQuery.of(context).size.height / 2,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center  ,
                              mainAxisAlignment: MainAxisAlignment.center  ,
                              children: [
                                Container(
                                  width: 70,
                                  height: 70,
                                  child: Image.asset('images/library.png'),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Your library is empty',
                                  style: GoogleFonts.roboto(fontSize: 22),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  width: 110,
                                  child: CustomButton(
                                    gr_color1: CustomColors.white,
                                    gr_color2: CustomColors.white,
                                    color: null,
                                    text: 'Add Books',
                                    style: GoogleFonts.roboto(
                                      fontSize: 16,
                                    ),
                                    onTap: () {
                                      final provider =
                                          Provider.of<SetStateClass>(context,
                                              listen: false);
                                      provider.setCurrentIndex(0);
                                    },
                                    text_color: Colors.black,
                                  ),
                                ),
                              ]),
                        ),
// recomended books
                        Container(
                          child: Column(children: [
                            Container(
                              margin: EdgeInsets.all(12),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Recommenced Books',
                                style: GoogleFonts.inter(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Container(
                              height: 220,
                              child: RecomdedCard(),
                            )
                          ]),
                        )

                      ],
                    ),
                  ),
                ),
              ):Container(child: Center(child: CircularProgressIndicator(color: Colors.pink,backgroundColor: Colors.white,),),));
  }
}
