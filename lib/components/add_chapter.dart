import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

import '../utils/colors.dart';
import 'CustomIconButton.dart';

class AddChapter extends StatefulWidget {
  var id;
  var title;
  var chatper;
  int words;

  AddChapter(
      {super.key,
      required this.id,
      required this.title,
      this.chatper,
      required this.words});

  @override
  State<AddChapter> createState() => _AddChapterState();
}

class _AddChapterState extends State<AddChapter> {
  TextEditingController chapter_title = TextEditingController();
  TextEditingController descriptions = TextEditingController();
  TextEditingController publish_date = TextEditingController();
String newVar="";
  String post = 'post';
  bool post_check = true;
  bool draft = false;
  bool publish = false;
  SelectPost(String value) {
    if (value == 'post') {
      setState(() {
        post = value;
        post_check = true;
        draft = false;
        publish = false;
      });
    } else if (value == 'draft') {
      setState(() {
        post = value;
        post_check = false;
        draft = true;
        publish = false;
      });
    } else if (value == 'publish') {
      setState(() {
        post = value;
        post_check = false;
        draft = false;
        publish = true;
      });
    }
  }

  bool upload = false;
  AddChapter() {
    if (chapter_title.text.isNotEmpty && descriptions.text.isNotEmpty) {
      if(descriptions.text.length==5000){
 setState(() {
        upload = true;
      });
      var uuid = Uuid().v1();
      var date = DateTime.now();
      FirebaseFirestore.instance
          .collection('books')
          .doc(widget.id)
          .update({'words': widget.words + descriptions.text.length});
      FirebaseFirestore.instance
          .collection('books')
          .doc(widget.id)
          .collection('chapter')
          .doc(uuid)
          .set({
        'book_id': uuid,
        'chapter_title': chapter_title.text,
        'description': descriptions.text,
        'update_date':
            '${date.year}/${date.month}/${date.day} :${date.hour}:${date.minute}',
        'publish_type': post,
        'publish_date': publish_date.text,
        'words': descriptions.text.length,
        'chater_no': chapter_no
      }).then((value) => {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Chapter Added Successfully')))
              });
      GetChapter();
      chapter_title.clear();
      descriptions.clear();
      setState(() {
        upload = false;
      });
      }else{
         ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('description should be equal to 5k')));
      }
     
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Enter title and description')));
    }
  }

  var chapter_no;
  GetChapter() {
    FirebaseFirestore.instance
        .collection('books')
        .doc(widget.id)
        .collection('chapter')
        .get()
        .then((value) => {
              setState(() {
                chapter_no = value.docs.length;
              })
            });
  }

  @override
  void initState() {
    GetChapter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final format = DateFormat("yyyy-MM-dd hh-mm");

    return Scaffold(
      appBar: AppBar(
        leading: Ink(),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [CustomColors.pink1, CustomColors.pink2])),
        ),
        title: Text('Add Chapter'),
        backgroundColor: CustomColors.blue200,
      ),
      body: Container(
        // margin: EdgeInsets.all(12),
        child: ListView(
            shrinkWrap: true,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height - 220,
                    width: MediaQuery.of(context).size.width - 24,
                    margin: EdgeInsets.all(12),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: CustomColors.white,
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Row(children: [
                              Container(
                                child: CustomIconButton(
                                  icon: Icons.arrow_back,
                                  title: 'Stories',
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                child: Text('${widget.title}'),
                              ),
                            ]),
                          ),
                          Container(
                            child: Row(children: [
                              Container(
                                child: Text(
                                    'Chapter: ${chapter_no != null ? chapter_no + 1 : 0}'),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                height: 35,
                                width: MediaQuery.of(context).size.width - 130,
                                child: TextField(
                                  controller: chapter_title,
                                  decoration: InputDecoration(
                                      hintText: 'Enter Chapter Title',
                                      fillColor: Colors.blue.shade50,
                                      filled: true,
                                      contentPadding: EdgeInsets.all(5),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(6))),
                                ),
                              ),
                            ]),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 12, right: 12),
                            child: Divider(
                              thickness: 3,
                              color: Colors.blue.shade50,
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height - 330,
                            width: MediaQuery.of(context).size.width,
                            child: TextField(
                              maxLines: 40,
                              maxLength: 5000,
                              controller: descriptions,
                              decoration: InputDecoration(
                                  hintText: '',
                                  fillColor: Colors.blue.shade50,
                                  filled: true,
                                  contentPadding: EdgeInsets.all(5),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(6))),
                            ),
                          )
                        ]),
                  ),

                  // Container(
                  //   height: MediaQuery.of(context).size.height - 250,
                  //   // margin: EdgeInsets.all(12),
                  //   // padding: EdgeInsets.all(12),
                  //   decoration: BoxDecoration(
                  //       // color: CustomColors.white,
                  //       borderRadius: BorderRadius.circular(12)),
                  //   child: Column(children: [
                  //     Container(
                  //       margin: EdgeInsets.all(12),
                  //       padding: EdgeInsets.all(12),
                  //       decoration: BoxDecoration(
                  //           color: CustomColors.white,
                  //           borderRadius: BorderRadius.circular(12)),
                  //       child: CustomIconButton(
                  //         width: 200,
                  //         icon: Icons.add,
                  //         color1: CustomColors.blue100,
                  //         color2: CustomColors.blue100,
                  //         title: 'Create New Chapter',
                  //         onTap: () {
                  //           chapter_title.clear();
                  //           descriptions.clear();
                  //         },
                  //       ),
                  //     ),
                  //     SizedBox(
                  //       height: 5,
                  //     ),
                  //     Container(
                  //         height: MediaQuery.of(context).size.height - 365,
                  //         width: 250,
                  //         margin: EdgeInsets.all(12),
                  //         padding: EdgeInsets.all(12),
                  //         decoration: BoxDecoration(
                  //             color: CustomColors.white,
                  //             borderRadius: BorderRadius.circular(12)),
                  //         child: StreamBuilder(
                  //             stream: FirebaseFirestore.instance
                  //                 .collection('books')
                  //                 .doc(widget.id)
                  //                 .collection('chapter')
                  //                 .snapshots(),
                  //             builder: (context, snapshot) {
                  //               return ListView.builder(
                  //                   itemCount: snapshot.data!.docs.length,
                  //                   itemBuilder: (context, int index) {
                  //                     return Container(
                  //                       margin: EdgeInsets.only(bottom: 12),
                  //                       child: Column(
                  //                         crossAxisAlignment:
                  //                             CrossAxisAlignment.start,
                  //                         children: [
                  //                           Container(
                  //                               child: Text(
                  //                             'Chapter${snapshot.data!.docs[index]['chater_no']} ${snapshot.data!.docs[index]['chapter_title']}',
                  //                             style: GoogleFonts.ptSerif(
                  //                               color: CustomColors.blue200,
                  //                             ),
                  //                           )),
                  //                           SizedBox(
                  //                             height: 10,
                  //                           ),
                  //                           Row(
                  //                             crossAxisAlignment:
                  //                                 CrossAxisAlignment.center,
                  //                             mainAxisAlignment:
                  //                                 MainAxisAlignment.spaceBetween,
                  //                             children: [
                  //                               Container(
                  //                                   child: Text(
                  //                                 'Word :${snapshot.data!.docs[index]['words']}',
                  //                                 style: GoogleFonts.ptSerif(
                  //                                   color: CustomColors.blue200,
                  //                                 ),
                  //                               )),
                  //                               Container(
                  //                                   child: Text(
                  //                                 '${snapshot.data!.docs[index]['update_date']}',
                  //                                 style: GoogleFonts.ptSerif(
                  //                                   color: CustomColors.blue200,
                  //                                 ),
                  //                               )),
                  //                             ],
                  //                           ),
                  //                           SizedBox(
                  //                             height: 10,
                  //                           ),
                  //                           Container(
                  //                               // margin: EdgeInsets.all(12),
                  //                               padding: EdgeInsets.all(12),
                  //                               decoration: BoxDecoration(
                  //                                   borderRadius:
                  //                                       BorderRadius.circular(6),
                  //                                   gradient: LinearGradient(
                  //                                       colors: [
                  //                                         Colors.red.shade50,
                  //                                         Colors.orange.shade50
                  //                                       ])),
                  //                               child: Text(
                  //                                 '${snapshot.data!.docs[index]['publish_type']}',
                  //                                 style: GoogleFonts.ptSerif(
                  //                                   color: CustomColors.blue200,
                  //                                 ),
                  //                               )),
                  //                           SizedBox(
                  //                             height: 10,
                  //                           ),
                  //                           Container(
                  //                             child: Row(
                  //                                 crossAxisAlignment:
                  //                                     CrossAxisAlignment.center,
                  //                                 mainAxisAlignment:
                  //                                     MainAxisAlignment
                  //                                         .spaceBetween,
                  //                                 children: [
                  //                                   CustomIconButton(
                  //                                       width: 112,
                  //                                       color1: CustomColors.blue50,
                  //                                       color2:
                  //                                           CustomColors.blue200,
                  //                                       icon: Icons.preview,
                  //                                       onTap: () {},
                  //                                       title: 'Preview'),
                  //                                   CustomIconButton(
                  //                                       color1: CustomColors.pink1,
                  //                                       color2: CustomColors.pink2,
                  //                                       width: 112,
                  //                                       icon: Icons.delete,
                  //                                       onTap: () {},
                  //                                       title: 'delete'),
                  //                                 ]),
                  //                           ),
                  //                           Divider(
                  //                             thickness: 2,
                  //                             color: CustomColors.blue200,
                  //                           )
                  //                         ],
                  //                       ),
                  //                     );
                  //                   });
                  //             })),
                  //   ]),
                  // ),
                ],
              ),
              Container(
                alignment: Alignment.topRight,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          SelectPost('post');
                        },
                        child: Container(
                          width: 200,
                          height: 24,
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  child: Icon(post_check == true
                                      ? Icons.radio_button_checked_outlined
                                      : Icons.radio_button_off_outlined),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  child: Text('post',
                                      style: GoogleFonts.ptSerif()),
                                )
                              ]),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          SelectPost('draft');
                        },
                        child: Container(
                          height: 24,
                          width: 200,
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  child: Icon(draft == true
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_off_outlined),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  child: Text('save as draft',
                                      style: GoogleFonts.ptSerif()),
                                )
                              ]),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          SelectPost('publish');
                        },
                        child: Container(
                          height: 24,
                          width: 206,
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  child: Icon(publish == true
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_unchecked_sharp),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  child: Text('Asign publiscation date',
                                      style: GoogleFonts.ptSerif()),
                                )
                              ]),
                        ),
                      ),
                    ]),
              ),
              post == 'publish'
                  ? Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            alignment: Alignment.topRight,
                            height: 33,
                            width: 300,
                            child: DateTimeField(
                              decoration: InputDecoration(
                                  hintText: 'select publish date',
                                  fillColor: CustomColors.blue50,
                                  filled: true),
                              format: format,
                              onFieldSubmitted: (v) {
                                publish_date.text = "$v";
                              },
                              onShowPicker: (context, currentValue) {
                                return showDatePicker(
                                    context: context,
                                    firstDate: DateTime(1900),
                                    initialDate: currentValue ?? DateTime.now(),
                                    lastDate: DateTime(2100));
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
              upload == false
                  ? Container(
                      alignment: Alignment.bottomRight,
                      child: CustomIconButton(
                        color1: CustomColors.blue100,
                        color2: CustomColors.blue100,
                        width: 200,
                        icon: Icons.file_upload,
                        onTap: () {
                          AddChapter();
                        },
                        title: 'Publish',
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    )
            ]),
      ),
    );
  }
}
