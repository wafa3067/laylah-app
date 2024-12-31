import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:laylah/provider/set_state_class.dart';
import 'package:laylah/screens/draft_screen.dart';

import '../utils/colors.dart';

class AddBooks extends StatefulWidget {
  const AddBooks({super.key});

  @override
  State<AddBooks> createState() => _AddBooksState();
}

class _AddBooksState extends State<AddBooks> {
  List Apps = [
    DraftScreen(),
    Container(
      child: Text('publish'),
    ),
    Container(
      child: Text('trash'),
    )
  ];
  var draft = true;
  var publised = false;
  var trash = false;
  List cate = ['Love', 'Comic', "Drama's", "Nature", 'Science', "Fiction"];

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
              Container(child: Text('Left at the ALter')),
              Container(
                child: Row(children: [
                  Container(
                    child: Icon(AntDesign.linechart),
                  ),
                ]),
              )
            ],
          ),
        ),
      ),
      backgroundColor: Colors.grey.shade300,
      body: Column(children: [
        Consumer<SetStateClass>(builder: (context, value, child) {
          return Container(
            height: 50,
            padding: EdgeInsets.all(6),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 1, color: Colors.grey.shade400)),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      value.updatedraft(true, false, false, 0);
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 30,
                          padding: EdgeInsets.only(left: 15, right: 15),
                          child: Text(
                            'Draft',
                            style: GoogleFonts.ptSerif(
                                color: draft == true
                                    ? Colors.black
                                    : Colors.black54,
                                fontWeight: true == draft
                                    ? FontWeight.w500
                                    : FontWeight.w400,
                                fontSize: 20),
                          ),
                        ),
                        Container(
                          width: 40,
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: value.draft == true
                                      ? BorderSide(
                                          width: 3,
                                          color: CustomColors.AppColor1)
                                      : BorderSide.none)),
                        )
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      value.updatedraft(false, false, true, 0);
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 30,
                          padding: EdgeInsets.only(left: 15, right: 15),
                          child: Text(
                            'Published',
                            style: GoogleFonts.ptSerif(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 20),
                          ),
                        ),
                        Container(
                          width: 40,
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: value.publish == true
                                      ? BorderSide(
                                          width: 3,
                                          color: CustomColors.AppColor1)
                                      : BorderSide.none)),
                        )
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      value.updatedraft(false, true, false, 2);
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 30,
                          padding: EdgeInsets.only(left: 15, right: 15),
                          child: Text(
                            'Trash',
                            style: GoogleFonts.ptSerif(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 20),
                          ),
                        ),
                        Container(
                          width: 40,
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: value.trash == true
                                      ? BorderSide(
                                          width: 3,
                                          color: CustomColors.AppColor1)
                                      : BorderSide.none)),
                        )
                      ],
                    ),
                  )
                ]),
          );
        }),
        Container(
          height: MediaQuery.of(context).size.height - 170,
          child: Consumer<SetStateClass>(builder: (context, value, child) {
            return Apps.elementAt(value.draft_index);
          }),
        )
      ]),
    );
  }
}
