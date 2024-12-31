import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:laylah/provider/set_state_class.dart';
import 'package:laylah/screens/home_screen.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:laylah/utils/colors.dart';

class BottomNavigator extends StatefulWidget {
  var discover;
  var library;
  var write;
  var profile;
  BottomNavigator(
      {super.key, this.discover, this.library, this.profile, this.write});

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SetStateClass>(builder: (context, value, child) {
      return Container(

        decoration: BoxDecoration(
          color: HexColor('#f8f2f6'),
          gradient: LinearGradient(
            colors: [HexColor('#f8f2f6'), HexColor('#f8f2f6')],
            // begin: Alignment.bottomCenter,
            // end: Alignment.topCenter,
            // stops: [0.5, 0.90],
            // tileMode: TileMode.mirror,
          ),
        ),
        child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: HexColor('#f8f2f6'),
            unselectedItemColor: Colors.pinkAccent,
            selectedItemColor: Colors.pink,
            currentIndex: value.current_index,
            onTap: (vl) {
              value.setCurrentIndex(vl);
            },
            selectedLabelStyle: GoogleFonts.ptSerif(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.pink,
            ),
            unselectedLabelStyle: GoogleFonts.ptSerif(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.pink,
            ),
            items: [
              BottomNavigationBarItem(
                backgroundColor:
                    value.current_index == 0 ? Colors.pink : Colors.pinkAccent,
                icon: Icon(
                  Foundation.graph_bar,
                  color:
                      value.current_index == 0 ? Colors.pink : Colors.pinkAccent,
                ),
                label: 'Discover',
              ),
              BottomNavigationBarItem(
                  icon: Icon(
                    value.current_index == 1
                        ? AntDesign.heart
                        : AntDesign.hearto,
                    color: value.current_index == 1
                        ? Colors.pink
                        : Colors.pinkAccent,
                  ),
                  label: 'Library'),
              BottomNavigationBarItem(
                  backgroundColor:
                      value.current_index == 2 ? Colors.pink : Colors.pinkAccent,
                  icon: Icon(
                    MaterialCommunityIcons.fountain_pen,
                    color: value.current_index == 2
                        ? Colors.pink
                        : Colors.pinkAccent,
                  ),
                  label: 'Write'),
              BottomNavigationBarItem(
                  icon: Icon(
               value.current_index==3 ? Icons.person:Ionicons.person_outline,
                    color: value.current_index == 3
                        ? Colors.pink
                        : Colors.pinkAccent,
                  ),
                  label: 'Profile'),
            ]),
      );
    });
  }
}
