import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laylah/utils/colors.dart';

class CustomSteper extends StatefulWidget {
  bool one;
  bool two;
  bool thre;
  bool four;
  bool complete_one;
  bool complete_two;
  bool complete_thre;
  bool complete_four;

  CustomSteper({
    super.key,
    required this.one,
    required this.two,
    required this.thre,
    required this.four,
    required this.complete_one,
    required this.complete_two,
    required this.complete_thre,
    required this.complete_four,
  });

  @override
  State<CustomSteper> createState() => _CustomSteperState();
}

class _CustomSteperState extends State<CustomSteper> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12),
      child: Row(children: [
        widget.complete_one == false
            ? Container(
                child: Text(
                  '1',
                  style: GoogleFonts.ptSerif(
                      color: widget.one == true
                          ? CustomColors.AppColor1
                          : Colors.black,
                      fontSize: 20),
                ),
              )
            : Container(
                child: Icon(
                  MaterialIcons.done,
                  color: CustomColors.AppColor1,
                ),
              ),
        Expanded(
          child: Container(
            width: 70,
            child: Divider(
              height: 5,
              color: CustomColors.AppColor1,
            ),
          ),
        ),
        widget.complete_two == false
            ? Container(
                child: Text('2',
                    style: GoogleFonts.ptSerif(
                        color: widget.two == true
                            ? CustomColors.AppColor1
                            : Colors.black,
                        fontSize: 20)),
              )
            : Container(
                child: Icon(
                  MaterialIcons.done,
                  color: CustomColors.AppColor1,
                ),
              ),
        Expanded(
          child: Container(
            width: 70,
            child: Divider(
              height: 5,
              color: CustomColors.AppColor1,
            ),
          ),
        ),
        widget.complete_thre == false
            ? Container(
                child: Text('3',
                    style: GoogleFonts.ptSerif(
                        color: widget.thre == true
                            ? CustomColors.AppColor1
                            : Colors.black,
                        fontSize: 20)),
              )
            : Container(
                child: Icon(
                  MaterialIcons.done,
                  color: CustomColors.AppColor1,
                ),
              ),
        Expanded(
          child: Container(
            width: 70,
            child: Divider(
              height: 5,
              color: CustomColors.AppColor1,
            ),
          ),
        ),
        widget.complete_four == false
            ? Container(
                child: Text('4',
                    style: GoogleFonts.ptSerif(
                        color: widget.four == true
                            ? CustomColors.AppColor1
                            : Colors.black,
                        fontSize: 20)),
              )
            : Container(
                child: Icon(
                  MaterialIcons.done,
                  color: CustomColors.AppColor1,
                ),
              ),
      ]),
    );
  }
}
