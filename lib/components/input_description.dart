import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/colors.dart';

class InputDescription extends StatefulWidget {
  bool require;
  var name;
  var max;
  TextEditingController text;
  var placeholder;
  InputDescription(
      {super.key,
      this.name,
      required this.require,
      required this.text,
      this.placeholder,
      this.max});

  @override
  State<InputDescription> createState() => _InputDescriptionState();
}

class _InputDescriptionState extends State<InputDescription> {
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
                controller: widget.text,
                maxLines: widget.max,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade300,
                    border: InputBorder.none,
                    hintText: '${widget.placeholder}',
                    hintStyle: GoogleFonts.ptSerif())),
          ),
        ],
      ),
    );
  }
}
