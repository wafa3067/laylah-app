import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:laylah/components/custom_button.dart';
import 'package:laylah/utils/colors.dart';

class DayRewardCard extends StatefulWidget {
  var coins;
  var day;
  DayRewardCard({
    super.key,
  });

  @override
  State<DayRewardCard> createState() => _DayRewardCardState();
}

class _DayRewardCardState extends State<DayRewardCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      width: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [CustomColors.lightoragne, CustomColors.lowlighttpink]),
      ),
      child: Column(children: [
        // Row(
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     SizedBox(
        //       height: 5,
        //     ),
        //     Container(
        //       width: 50,
        //       height: 50,
        //       child: Image.asset('images/coins.png'),
        //     ),
        //     SizedBox(
        //       height: 5,
        //     ),
        //     Container(
        //       child: Text('${widget.coins} ',
        //           style: GoogleFonts.ptSerif(
        //               fontSize: 18, color: CustomColors.white)),
        //     ),
        //   ],
        // ),
        // SizedBox(
        //   height: 5,
        // ),
        // Container(
        //   child: Text('DAY ${widget.day} ',
        //       style:
        //           GoogleFonts.ptSerif(fontSize: 16, color: CustomColors.white)),
        // ),
        // SizedBox(
        //   height: 5,
        // ),
        // Container(
        //     width: 110,
        //     child: CustomButton(
        //         color: null,
        //         gr_color1: CustomColors.white,
        //         gr_color2: CustomColors.white,
        //         text: 'Claim Now',
        //         text_color: CustomColors.black))
      ]),
    );
  }
}
