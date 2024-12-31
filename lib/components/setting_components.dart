import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingComponents extends StatefulWidget {
  IconData icon;
  String name;
  var onTap;
   SettingComponents({super.key,required this.icon,required this.name,required this.onTap});

  @override
  State<SettingComponents> createState() => _SettingComponentsState();
}

class _SettingComponentsState extends State<SettingComponents> {
  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: widget.onTap,
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),

              color: Colors.white),
          margin: EdgeInsets.symmetric(horizontal: 12,vertical: 5),
          width: MediaQuery.of(context).size.width,
          height: 50,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(left: 12),
                child: Row(children: [
                  Container(
                      margin: EdgeInsets.only(right: 12),
                      child: Icon(
                       widget.icon,
                        color: Colors.black,
                      )),
                  Text(
                    '${widget.name}',
                    style: GoogleFonts.ptSerif(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                ]),
              ),
              Container(
                  margin: EdgeInsets.only(right: 12),
                  child: Icon(Icons.arrow_forward))
            ],
          )),
    );
  }
}
