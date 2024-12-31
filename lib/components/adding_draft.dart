import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:laylah/provider/set_state_class.dart';
import 'package:laylah/screens/draft_screen.dart';
import 'package:uuid/uuid.dart';
import '../utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddingDraft extends StatefulWidget {
  const AddingDraft({super.key});

  @override
  State<AddingDraft> createState() => _AddingDraftState();
}

class _AddingDraftState extends State<AddingDraft> {
  List search = ['Left at the Alter'];

  TextEditingController searching = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
            decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [CustomColors.AppColor1, CustomColors.AppColor2]),
        )),
        backgroundColor: CustomColors.AppColor1,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back)),
        title: Container(
          margin: EdgeInsets.only(left: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(child: Text('Save&Exit')),
              Container(
                child: Row(children: [
                  Container(
                    child: Icon(AntDesign.linechart),
                  ),
                  Container(
                    child: Icon(AntDesign.arrowright),
                  ),
                ]),
              )
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12)),
            width: MediaQuery.of(context).size.width - 10,
            child: TextField(
              onSubmitted: (String vl) {
                setState(() {
                  searching.text = "${vl}";
                });
              },
              controller: searching,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(4),
                  hintText: 'Chapter Title',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none),
            ),
          ),
          searching.text == search[0]
              ? InkWell(
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
                                  Container(
                                    margin: EdgeInsets.all(12),
                                    child: Text(
                                      'Release',
                                      style: GoogleFonts.ptSerif(fontSize: 24),
                                    ),
                                  ),
                                  Divider(
                                    height: 3,
                                    color: Colors.grey,
                                  ),
                                  ListTile(
                                    title: Text('Left at the Alter',
                                        style:
                                            GoogleFonts.ptSerif(fontSize: 16)),
                                    subtitle: Text('Chatper 1',
                                        style: GoogleFonts.ptSerif()),
                                    onTap: () {
                                      // Perform share action
                                    },
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(12),
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: Text('Chapter type',
                                                style: GoogleFonts.ptSerif(
                                                    fontSize: 16)),
                                          ),
                                          Container(
                                            child: Text('Normal chapter ',
                                                style: GoogleFonts.ptSerif(
                                                    fontSize: 16)),
                                          ),
                                        ]),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(12),
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: Text('Word Counts',
                                                style: GoogleFonts.ptSerif(
                                                    fontSize: 16)),
                                          ),
                                          Container(
                                            child: Text('4 ',
                                                style: GoogleFonts.ptSerif(
                                                    fontSize: 16)),
                                          ),
                                        ]),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Consumer<SetStateClass>(
                                      builder: (context, value, child) {
                                    return Container(
                                      margin: EdgeInsets.all(12),
                                      child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            value.switch_value == false
                                                ? Container(
                                                    child: Text('Auto Publish',
                                                        style:
                                                            GoogleFonts.ptSerif(
                                                                fontSize: 16)),
                                                  )
                                                : Container(
                                                    child: Text(
                                                        'publish time(GPT+500)'),
                                                  ),
                                            Container(
                                              child: FlutterSwitch(
                                                value: value.switch_value,
                                                onToggle: (vl) {
                                                  value.updateSwicth(vl);
                                                },
                                              ),
                                            )
                                          ]),
                                    );
                                  }),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(12),
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: 120,
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.all(12),
                                            margin: EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                                color: CustomColors.grey400,
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            child: Text('Cancel',
                                                style: GoogleFonts.ptSerif(
                                                    fontSize: 16,
                                                    color: Colors.black)),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.pop(context);
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (context) => AlertDialog(
                                                              actions: [
                                                                Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              25,
                                                                          right:
                                                                              25),
                                                                  child: Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            alignment:
                                                                                Alignment.center,
                                                                            width:
                                                                                100,
                                                                            height:
                                                                                40,
                                                                            padding:
                                                                                EdgeInsets.all(6),
                                                                            decoration:
                                                                                BoxDecoration(color: CustomColors.AppColor1, borderRadius: BorderRadius.circular(12)),
                                                                            child:
                                                                                Text(
                                                                              'Discord Save',
                                                                              style: TextStyle(color: Colors.white),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        InkWell(
                                                                          onTap:
                                                                              () async {
                                                                            var uuid =
                                                                                Uuid().v1();
                                                                            Map data =
                                                                                {
                                                                              "id": uuid,
                                                                              'chapter_name': 'Chapter1',
                                                                              'date': 'may 25,2023,16:42:50',
                                                                              'words': 145
                                                                            };
                                                                            String
                                                                                dataString =
                                                                                json.encode(data);

                                                                            final SharedPreferences
                                                                                prefs =
                                                                                await SharedPreferences.getInstance();
                                                                            prefs.setStringList(
                                                                              'map',
                                                                              [
                                                                                dataString,
                                                                              ],
                                                                            ).then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) => DraftScreen())));
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            alignment:
                                                                                Alignment.center,
                                                                            width:
                                                                                100,
                                                                            height:
                                                                                40,
                                                                            padding:
                                                                                EdgeInsets.all(6),
                                                                            decoration: BoxDecoration(
                                                                                gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                                                                                  CustomColors.AppColor1,
                                                                                  CustomColors.AppColor2
                                                                                ]),
                                                                                color: CustomColors.AppColor1,
                                                                                borderRadius: BorderRadius.circular(12)),
                                                                            child:
                                                                                Text(
                                                                              ' Save',
                                                                              style: TextStyle(color: Colors.white),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ]),
                                                                )
                                                              ],
                                                              title: Container(
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Container(
                                                                      child: Text(
                                                                          'Do you want to save the Draft and exit'),
                                                                    ),
                                                                    Divider(
                                                                      height: 4,
                                                                      color: Colors
                                                                          .grey,
                                                                    )
                                                                  ],
                                                                ),
                                                              )));
                                            },
                                            child: Container(
                                              width: 120,
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.all(12),
                                              padding: EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
                                                      colors: [
                                                        CustomColors.AppColor1,
                                                        CustomColors.AppColor2
                                                      ]),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              child: Text('Release',
                                                  style: GoogleFonts.ptSerif(
                                                      fontSize: 16,
                                                      color: Colors.white)),
                                            ),
                                          ),
                                        ]),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.all(12),
                    child: Text('${search[0]}'),
                  ),
                )
              : Container(
                  margin: EdgeInsets.only(left: 22), child: Text('Search..'))
        ],
      ),
    );
  }
}
