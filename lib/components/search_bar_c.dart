import 'package:flutter/material.dart';
import 'package:laylah/provider/set_state_class.dart';
import 'package:provider/provider.dart';

import '../utils/colors.dart';

class SearchBarD extends StatefulWidget {
  TextEditingController search;
  var onChange;
  SearchBarD({super.key, required this.search,this.onChange});

  @override
  State<SearchBarD> createState() => _SearchBarDState();
}

class _SearchBarDState extends State<SearchBarD> {
  TextEditingController SearchText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      child: Consumer<SetStateClass>(
        builder: (context, myType, child) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 45,
                width: MediaQuery.of(context).size.width - 103,
                child: TextField(
                  onChanged: (v) {
                    myType.setSearch(v);
                  },
                  decoration: InputDecoration(
                    icon: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        final provider = Provider.of<SetStateClass>(context, listen: false);
                        provider.searchTap = '';

                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: CustomColors.black,
                        size: 30,
                      ),
                    ),
                    prefixIcon: Icon(Icons.search),
                    fillColor: CustomColors.white,
                    filled: true,
                    hintText: 'Titles, Authors, Tags…',
                    contentPadding: EdgeInsets.all(4),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none),
                    disabledBorder:
                        UnderlineInputBorder(borderSide: BorderSide.none),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                height: 40,
                width: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.blueGrey.shade50,
                    Colors.blueGrey.shade50
                  ]),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: InkWell(
                  child: Center(
                      child: Text(
                    'Search',
                    style:
                        TextStyle(color: CustomColors.AppColor1, fontSize: 22),
                  )),
                  onTap: () {
                    if (myType.search != '') {
                      myType.setSearchTap(myType.search);
                    }
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
