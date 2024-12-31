import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/colors.dart';

class CustomButton extends StatefulWidget {
  var onTap;
  var color;
  var text_color;
  var text;
  var gr_color1;
  var gr_color2;
  var width;
  var style;
  var height;
  CustomButton(
      {super.key,
      this.onTap,
      required this.color,
      required this.text,
      required this.text_color,
      this.gr_color1,
      this.gr_color2,
      this.width,
      this.style,this.height});

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: widget.onTap,
        child: Container(
            width: widget.width == null ? 200 : widget.width,
            height:widget.height==null? 40:widget.height,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  widget.gr_color1 != null
                      ? widget.gr_color1
                      : CustomColors.AppColor1,
                  widget.gr_color2 != null
                      ? widget.gr_color2
                      : CustomColors.AppColor2,
                ]),
                color: widget.color == null
                    ? CustomColors.AppColor1
                    : widget.color,
                borderRadius: BorderRadius.circular(12)),
            child: Text('${widget.text}',
                style: widget.style == null
                    ? GoogleFonts.ptSerif(
                        color: widget.text_color != null
                            ? widget.text_color
                            : Colors.white,
                        fontSize: 18)
                    : widget.style)));
  }
}
