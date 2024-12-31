import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/colors.dart';

class CustomIconButton extends StatefulWidget {
  var title;
  var icon;
  var onTap;
  var width;
  var color1;
  var color2;

  CustomIconButton(
      {super.key,
      this.icon,
      required this.onTap,
      required this.title,
      this.width,
      this.color1,
      this.color2});

  @override
  State<CustomIconButton> createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomIconButton> {
  var user = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          user = true;
        });
      },
      onExit: (event) {
        setState(() {
          user = false;
        });
      },
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          width: widget.width == null ? 100 : double.parse("${widget.width}"),
          height: 35,
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: user == false
                      ? [
                          widget.color1 == null
                              ? CustomColors.white
                              : widget.color1,
                          widget.color2 == null
                              ? CustomColors.white
                              : widget.color2
                        ]
                      : [CustomColors.darkbrown, CustomColors.darkgreen]),
              borderRadius: BorderRadius.circular(8),
              color: user == false
                  ? CustomColors.darkgrey
                  : CustomColors.AppColor1),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                widget.icon != null
                    ? Container(
                        child: Icon(
                          widget.icon,
                          size: 26,
                          color: user == false
                              ? CustomColors.black
                              : CustomColors.white,
                        ),
                      )
                    : Container(),
                Container(
                  child: Text(
                    '${widget.title}',
                    style: GoogleFonts.ptSerif(
                        color: user == false
                            ? CustomColors.black
                            : CustomColors.white),
                  ),
                )
              ]),
        ),
      ),
    );
  }
}
