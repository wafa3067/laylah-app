import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laylah/utils/colors.dart';

class InputText extends StatefulWidget {
  bool require;
  var name;
  var width;
  TextEditingController text;
  var placeholder;
  var secure;
  var onTap;
  bool readOnly;
  InputText(
      {super.key,
      this.name,
      required this.require,
      required this.text,
      this.placeholder,
      this.width,
      this.secure,
      this.onTap,
      this.readOnly = false});

  @override
  State<InputText> createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 8),
            child: Row(
              children: [
                required == true
                    ? Container(
                        child: Text(
                          '*',
                          style: GoogleFonts.ptSerif(
                              color: Colors.red, fontSize: 18),
                        ),
                      )
                    : Container(),
                Container(
                  width: MediaQuery.of(context).size.width - 60,
                  child: Text(
                    '${widget.name}',
                    style: GoogleFonts.ptSerif(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width - 20,
            margin: EdgeInsets.only(left: 8, right: 8),
            child: TextFormField(
                readOnly: widget.readOnly,
                onTap: widget.onTap,
                controller: widget.text,
                obscureText: widget.secure != null ? widget.secure : false,
                decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            width: 2, color: CustomColors.AppColor1)),
                    hintText: '${widget.placeholder}',
                    hintStyle: GoogleFonts.ptSerif())),
          ),
        ],
      ),
    );
  }
}
