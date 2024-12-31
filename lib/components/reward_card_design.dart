import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:laylah/components/custom_button.dart';

import '../utils/colors.dart';

class RewardCardDesign extends StatefulWidget {
  var descriptions;
  var bouns_count;
  var button_icon;
  var button_text;
  var button_width;
  var button_border;
  var buttonPressed;
  var height;
  var title;
  RewardCardDesign(
      {super.key,
      required this.bouns_count,
      required this.button_icon,
      required this.button_text,
      required this.descriptions,
      this.button_width,
      this.button_border,
      this.buttonPressed,
      this.height,required this.title});

  @override
  State<RewardCardDesign> createState() => _RewardCardDesignState();
}

class _RewardCardDesignState extends State<RewardCardDesign> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(bottom: 8),
      height: widget.height == null ? 80 : widget.height,
      decoration: BoxDecoration(
        // border: Border.all(width: 1, color: CustomColors.lightoragne),
        borderRadius: BorderRadius.circular(20),
        // gradient: LinearGradient(colors: [
        //  Colors.white.opacity(0.8)
        //   CustomColors.white,
        // ]),
        color: Colors.white.withOpacity(0.7),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(children: [
           widget.title!=null ? Container(
              width: MediaQuery.of(context).size.width - 135,
              alignment: Alignment.topLeft,
              child: Text("${widget.title} ",
                  style: GoogleFonts.inter(
                      color: CustomColors.black87, fontSize: 16,fontWeight: FontWeight.w600)),
            ):Container(),
            Container(
              width: MediaQuery.of(context).size.width - 135,
              alignment: Alignment.topLeft,
              child: Text("${widget.descriptions} ",
                  style: GoogleFonts.quicksand(
                      color: CustomColors.black87, fontSize: 16)),
            ),
          ],),

          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: widget.button_width != null ? widget.button_width : 100,
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      HexColor('#ed8ca8'),
                      HexColor('#ed8ca8'),
                    ]),
                    color: CustomColors.AppColor1,
                    borderRadius: BorderRadius.circular(
                        widget.button_border != null
                            ? widget.button_border
                            : 12)),
                child: InkWell(
                  onTap: widget.buttonPressed,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      widget.button_icon != null
                          ? Container(
                              child: Icon(
                                widget.button_icon,
                                color: CustomColors.white,
                              ),
                            )
                          : Container(),
                      SizedBox(
                        width: 5,
                      ),
                      widget.button_text != null
                          ? Container(
                              child: Text('${widget.button_text}',
                                  style: GoogleFonts.roboto(
                                      color: CustomColors.white, fontSize: 16)),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Container(
                    //   child: Icon(
                    //     MaterialCommunityIcons.star_circle,
                    //     color: CustomColors.AppColor1,
                    //   ),
                    // ),
                    widget.bouns_count != null
                        ? Container(
                            child: Text("${widget.bouns_count}",style: GoogleFonts.roboto(),),
                          )
                        : Container(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
