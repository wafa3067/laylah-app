import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laylah/components/card_horizonatl.dart';
import 'package:laylah/components/recomdended_card.dart';
import 'package:laylah/components/search_bar_c.dart';
import 'package:laylah/components/search_card.dart';
import 'package:laylah/provider/set_state_class.dart';
import 'package:provider/provider.dart';

import '../utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searched = TextEditingController();

  Future<bool> _onWillPop() async {
    final provider = Provider.of<SetStateClass>(context, listen: false);
    provider.searchTap = '';
    searched.clear();
    searched.text='';
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SetStateClass>(context, listen: false);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.blueGrey.shade50,
        body: SafeArea(
          child: Container(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
// search bar
                  Container(
                    height: 70,
                    margin: EdgeInsets.only(left: 6, right: 6),
                    child: SearchBarD(
                      search: searched,
                      onChange: (v){
                      },
                    ),
                  ),
                  //top searches
                  Consumer<SetStateClass>(builder: (context,value,child){
                    return   value.searchTap == ''
                        ? Container(child: searched.text.length==0 ?
                    Consumer<SetStateClass>(
                      builder: (context, myType, child) {
                        return Column(

                            children: [
                              Container(
                                margin: EdgeInsets.all(6),
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Top Searches',
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    color: CustomColors.black,
                                    // fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(2),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 8, right: 8, top: 5, bottom: 5),
                                      margin: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color: CustomColors.white,
                                          borderRadius: BorderRadius.circular(6)),
                                      child: InkWell(
                                        onTap: () {
                                          myType.setSearchTap('Soul Rivier');
                                        },
                                        child: Text(
                                          'Soul Rivier',
                                          style: GoogleFonts.inter(
                                            // fontSize: 20,
                                            color: CustomColors.black,
                                            // fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 8, right: 8, top: 5, bottom: 5),
                                      decoration: BoxDecoration(
                                          color: CustomColors.white,
                                          borderRadius: BorderRadius.circular(6)),
                                      child: InkWell(
                                        onTap: () {
                                          myType.setSearchTap('Computer Science');
                                        },
                                        child: Text(
                                          'Computer Science',
                                          style: GoogleFonts.inter(
                                            // fontSize: 20,
                                            color: CustomColors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(3),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 8, right: 8, top: 5, bottom: 5),
                                      margin: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color: CustomColors.white,
                                          borderRadius: BorderRadius.circular(6)),
                                      child: InkWell(
                                        onTap: () {
                                          myType
                                              .setSearchTap('Science and fiction');
                                        },
                                        child: Text(
                                          'Science and Fiction',
                                          style: GoogleFonts.inter(
                                            // fontSize: 20,
                                            color: CustomColors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 8, right: 8, top: 5, bottom: 5),
                                      decoration: BoxDecoration(
                                          color: CustomColors.white,
                                          borderRadius: BorderRadius.circular(6)),
                                      child: InkWell(
                                        onTap: () {
                                          myType.setSearchTap('new reward');
                                        },
                                        child: Text(
                                          'New Reward',
                                          style: GoogleFonts.inter(
                                            color: CustomColors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ]);
                      },
                    ):Container())
                        : Container();
                  }),

                  // searched items
                  Consumer<SetStateClass>(
                    builder: (context, myType, child) {

                      return Container(
                        height: myType.searchTap == ''
                            ? MediaQuery.of(context).size.height - 520
                            : MediaQuery.of(context).size.height - 400,
                        child: SearchCard(
                          search: myType.searchTap,
                        ),
                      );
                    },
                  ),
                  Container(child: Column(children: [


                    // recommended books
                    searched.text.length==0 ?
                    Container(
                      margin: EdgeInsets.all(12),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Recommenced Books',
                        style: GoogleFonts.inter(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ):Container(),
                    searched.text.length==0 ?
                    Container(
                // height: 200,
                      child: RecomdedCard(),
                    ):Container()
                  ],),),

            ]),
          ),
        ),
      ),
    );
  }
}
