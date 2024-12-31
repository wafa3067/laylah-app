import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/colors.dart';

class InputPassword extends StatefulWidget {
  bool require;
  var name;
  var width;
  TextEditingController text;
  var placeholder;
  var secure;
  var onTap;
  bool readOnly;
  bool hide;
  InputPassword(
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
  State<InputPassword> createState() => _InputPasswordState();
}

class _InputPasswordState extends State<InputPassword> {
  var hide = true;
  bool secure = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.all(12),
      child: Container(
        width: MediaQuery.of(context).size.width - 20,
        margin: EdgeInsets.all(8.0),
        // height: 55,
        child: TextFormField(
            readOnly: widget.readOnly,
            onTap: widget.onTap,
            controller: widget.text,
            obscureText: secure,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(15),
                suffixIcon: hide == false
                    ? InkWell(
                        onTap: () {
                          setState(() {
                            hide = true;
                            secure = true;
                          });
                        },
                        child: Icon(Icons.remove_red_eye))
                    : InkWell(
                        onTap: () {
                          setState(() {
                            hide = false;
                            secure = false;
                          });
                        },
                        child: Icon(
                          MaterialCommunityIcons.eye_off,
                        ),
                      ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide:
                        BorderSide(width: 2, color: CustomColors.AppColor2)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide:
                        BorderSide(width: 2, color: CustomColors.AppColor1)),
                hintText: '${widget.placeholder}',
                hintStyle:
                    GoogleFonts.ptSerif(color: CustomColors.lightpurople))),
      ),
    );
  }
}
