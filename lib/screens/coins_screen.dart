import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/coin_card.dart';
import '../utils/colors.dart';

class CoinsScrren extends StatefulWidget {
  var earn;
   CoinsScrren({super.key,this.earn});

  @override
  State<CoinsScrren> createState() => _CoinsScrrenState();
}

class _CoinsScrrenState extends State<CoinsScrren> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back),
        ),
        backgroundColor: CustomColors.AppColor1,
        flexibleSpace: Container(
            decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                CustomColors.lowlightorange,
                CustomColors.lowlighttpink
              ]),
        )),
        centerTitle: true,
        title: Text(
          'store',
          style: GoogleFonts.ptSerif(
            fontSize: 30,
            color: CustomColors.white,
          ),
        ),
      ),
      body: ListView(shrinkWrap: true, children: [
        Container(
            height: MediaQuery.of(context).size.height - 100,
            child: CoinCard(earn:widget.earn)),
        Container(
          child: Text(
            'Privacy and policy',
            style: GoogleFonts.ptSerif(
              color: Colors.black,
            ),
          ),
        )
      ]),
    );
  }
}
