import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDropDown extends StatefulWidget {
  var name;
  var placeholder;
  List drop_value;
  TextEditingController selected;
  bool required;
  CustomDropDown(
      {super.key,
      required this.name,
      required this.placeholder,
      required this.required,
      required this.selected,
      required this.drop_value});

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  List gender = ['male', 'female'];
  var selected = 'male';
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
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
          DropdownButtonFormField2(
            decoration: InputDecoration(
              //Add isDense true and zero Padding.
              //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
              isDense: true,
              contentPadding: EdgeInsets.zero,
              // border: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(15),
              // ),
              //Add more decoration as you want here
              //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
            ),
            isExpanded: true,
            hint: Text(
              "${widget.placeholder == null ? "" : widget.placeholder}",
              style: TextStyle(fontSize: 14),
            ),
            items: widget.drop_value
                .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ))
                .toList(),
            validator: (value) {
              if (value == null) {
                return 'Please select gender.';
              }
              return null;
            },
            onChanged: (value) {
              //Do something when changing the item if you want.
            },
            onSaved: (value) {},
            buttonStyleData: const ButtonStyleData(
              height: 60,
              padding: EdgeInsets.only(left: 20, right: 10),
            ),
            iconStyleData: const IconStyleData(
              icon: Icon(
                Icons.arrow_drop_down,
                color: Colors.black45,
              ),
              iconSize: 30,
            ),
            dropdownStyleData: DropdownStyleData(
                // decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(15),
                ),
            // ),
          ),
        ],
      ),
    );
  }
}
