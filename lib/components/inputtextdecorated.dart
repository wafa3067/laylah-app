import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/colors.dart';

class InputTextDecorated extends StatefulWidget {
  bool require;
  var name;
  var width;
  TextEditingController text;
  var placeholder;
  var secure;
  var onTap;
  bool readOnly;
  bool hide;
  InputTextDecorated(
      {super.key,
      this.name,
      required this.require,
      required this.text,
      this.placeholder,
      this.width,
      this.secure,
      this.onTap,
      this.readOnly = false,
      this.hide = false});

  @override
  State<InputTextDecorated> createState() => _InputTextDecoratedState();
}

class _InputTextDecoratedState extends State<InputTextDecorated> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.all(12),
      child: Container(
        width: MediaQuery.of(context).size.width - 20,
        margin: EdgeInsets.all(8.0),
        child: TextFormField(
            readOnly: widget.readOnly,
            onTap: widget.onTap,
            controller: widget.text,
            obscureText: widget.secure != null ? widget.secure : false,
            decoration: InputDecoration(
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                        width: 2,
                        color: CustomColors.AppColor2,
                        style: BorderStyle.solid)),
                contentPadding: EdgeInsets.all(15),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                        width: 2,
                        color: CustomColors.AppColor2,
                        style: BorderStyle.solid)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide:
                        BorderSide(width: 1, color: CustomColors.AppColor1)),
                hintText: '${widget.placeholder}',
                hintStyle:
                    GoogleFonts.ptSerif(color: CustomColors.lightpurople))),
      ),
    );
  }
}
