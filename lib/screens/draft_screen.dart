import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laylah/components/adding_draft.dart';
import 'package:laylah/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DraftScreen extends StatefulWidget {
  const DraftScreen({super.key});

  @override
  State<DraftScreen> createState() => _DraftScreenState();
}

retrieveDataFromSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? dataString = prefs.getString('date');

  if (dataString != null) {
    Map<String, dynamic> data = json.decode(dataString);
 
  } else {}
}

class _DraftScreenState extends State<DraftScreen> {
  @override
  Widget build(BuildContext context) {
    retrieveDataFromSharedPreferences();
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: CustomColors.AppColor1,
      //   flexibleSpace: Container(
      //       decoration: BoxDecoration(
      //     gradient: LinearGradient(
      //         begin: Alignment.topCenter,
      //         end: Alignment.bottomCenter,
      //         colors: [CustomColors.AppColor1, CustomColors.AppColor2]),
      //   )),
      //   title: Row(
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       Text(
      //         'LayLah',
      //         style: GoogleFonts.dancingScript(
      //             fontSize: 30,
      //             color: Colors.white,
      //             fontWeight: FontWeight.bold),
      //       ),
      //       Icon(
      //         Icons.search,
      //         size: 30,
      //       )
      //     ],
      //   ),
      // ),
      body: ListView(shrinkWrap: true, children: [
        // Container(
        //   margin: EdgeInsets.all(12),
        //   child: Center(child: Text('No Data')),
        // ),
        Container(
          // margin: EdgeInsets.all(12),
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: Colors.grey.shade200),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              child: Text('chatpter 1',
                  style:
                      GoogleFonts.ptSerif(fontSize: 16, color: Colors.black)),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              child: Row(
                children: [
                  Text('Words:',
                      style: GoogleFonts.ptSerif(
                          fontSize: 16, color: Colors.black54)),
                  Text('145',
                      style: GoogleFonts.ptSerif(
                          fontSize: 16, color: Colors.black54)),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              child: Text('may 25,2023 16:42:50',
                  style:
                      GoogleFonts.ptSerif(fontSize: 16, color: Colors.black54)),
            ),
          ]),
        )
      ]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: CustomColors.AppColor1,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddingDraft()));
        },
        child: Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [CustomColors.AppColor1, CustomColors.AppColor2]),
          ),
          child: Icon(
            Icons.add,
            size: 30,
          ),
        ),
      ),
    );
  }
}
