import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/colors.dart';

class HoverText extends StatefulWidget {
  var title;

  var onTap;
  var width;
  HoverText({super.key, required this.onTap, required this.title, this.width});

  @override
  State<HoverText> createState() => _HoverTextState();
}

class _HoverTextState extends State<HoverText> {
  var user = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          border: widget.title != widget.width
              ? Border(bottom: BorderSide(width: 2))
              : Border(
                  bottom: BorderSide(width: 2, color: CustomColors.pink1))),
      child: MouseRegion(
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
              child: Text(
                "${widget.title}",
                style: GoogleFonts.ptSerif(
                    fontSize: 16,
                    color: widget.width != widget.title
                        ? CustomColors.black
                        : CustomColors.AppColor1),
              ),
            ),
          )),
    );
  }
}
