import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laylah/components/upload_book.dart';
import 'package:laylah/components/written_book.dart';
import 'package:laylah/provider/set_state_class.dart';
import 'package:provider/provider.dart';

import '../components/custom_button.dart';
import '../utils/colors.dart';

class WriteBookScreen extends StatefulWidget {
  const WriteBookScreen({super.key});

  @override
  State<WriteBookScreen> createState() => _WriteBookScreenState();
}

class _WriteBookScreenState extends State<WriteBookScreen> {
  var storage = FlutterSecureStorage();
  var writer_id;
  GetUserId() async {
    var user_id = await storage.read(key: 'uid');
    if (user_id != null) {
      setState(() {
        writer_id = user_id;
      });
      await CurrentUserBooks();
    }
  }

  bool current_user_books = false;
  CurrentUserBooks() {
    final provider = Provider.of<SetStateClass>(context, listen: false);
    FirebaseFirestore.instance.collection('books').get().then((value) {
      value.docs.forEach((element) {

        if (writer_id == element.data()['writer_id']) {
          provider.setCurrentUserBooks(true);
        }
      });
    });
  }

  @override
  void initState() {
    GetUserId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SetStateClass>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
            decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [CustomColors.lightpinkapp, CustomColors.lightpinkapp]),
        )),
        title: Container(
          margin: EdgeInsets.only(left: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  child: Text(
                'Author Centre',
                style: GoogleFonts.roboto(color: Colors.pink),
              )),
              Container(
                child: Row(children: [
                  Container(
                    child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UploadBook()));
                        },
                        child: Text(
                          'Add',
                          style: GoogleFonts.roboto(color: Colors.pink),
                        )),
                  ),
                ]),
              )
            ],
          ),
        ),
      ),
      backgroundColor: Colors.blueGrey.shade50,
      body:
      Consumer<SetStateClass>(builder: (context,value,child){
        return  value.current_user_book== true
            ?
        Container(
          height: MediaQuery.of(context).size.height,
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('books')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      itemBuilder: (context, int index) {
                        return writer_id ==
                            snapshot.data!.docs[index]['writer_id']
                            ? SizedBox(
                            height: 350,
                            child: WrittenBook(
                              applied: snapshot.data!.docs[index]['applied_for_contract'],
                              cover: snapshot.data!.docs[index]
                              ['cover'],
                              id: snapshot.data!.docs[index]['id'],
                              status: snapshot.data!.docs[index]
                              ['status'],
                              remarks: snapshot.data!.docs[index]
                              ['remarks'],
                              book_title: snapshot.data!.docs[index]
                              ['book_title'],
                              words: snapshot.data!.docs[index]
                              ['words'],
                              views: snapshot.data!.docs[index]['view'],
                            ))
                            : Container();
                      });
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              }),
        )
            : Container(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    child: Image.asset('images/library.png'),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Create a new book ',
                    style: GoogleFonts.roboto(fontSize: 22),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: 120,
                    child: CustomButton(
                      gr_color1: CustomColors.white,
                      gr_color2: CustomColors.white,
                      color: null,
                      style: GoogleFonts.roboto(fontSize: 16),
                      text: 'Create Book',
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UploadBook()));
                      },
                      text_color: Colors.black,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      })

    );
  }
}
