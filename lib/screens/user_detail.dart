import 'package:change_case/change_case.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:laylah/components/user_books.dart';
import 'package:laylah/provider/AppFunctions.dart';
import 'package:provider/provider.dart';

import '../utils/colors.dart';

class UserDetail extends StatefulWidget {
  var user_id;
   UserDetail({super.key,required this.user_id});

  @override
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
        children: [
    Consumer<AppFunctions>(
    builder: (context,myType,child) {
        return
          Container(
            margin:EdgeInsets.only(top: 25),
            child:

Column(children: [
  Container(
    alignment: Alignment.center,
    width: MediaQuery.of(context).size.width,
    height: 100,
    child:
            Stack(
            children: [
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                          color: CustomColors.lightyellow, blurRadius: 1),
                    ],
                  ),
                  child:myType.profile != 'null' ? ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child:
                    Image.network(
                      '${myType.profile}',
                      fit: BoxFit.cover,
                    ),
                  ):Center(child: Text('${myType.no_photo}'.toCapitalCase(),style: GoogleFonts.roboto(fontSize: 72),)),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(bottom: 2),
height: 30,
                  width: 70,
                  decoration: BoxDecoration(
                      color: HexColor('#E43F72'),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(50),bottomRight: Radius.circular(50))),
                  alignment: Alignment.bottomCenter,
                  child: Center(child: Text('Writer',style: GoogleFonts.roboto(color: CustomColors.white),)),),
              )
            ],
          )
  ),
  SizedBox(height: 10,),
  Container(
    width:MediaQuery.of(context).size.width/2.5,
    child: Center(child: Text('Wafa Abbas',style: GoogleFonts.roboto(color: CustomColors.black,fontSize: 18,fontWeight: FontWeight.bold),))),
  SizedBox(height: 10,),
  InkWell(
    onTap: (){},
    child: Container(
        width: 120,
        height: 30,
        decoration: BoxDecoration(
          border: Border.all(width: 1),
          borderRadius: BorderRadius.circular(24),
          color: HexColor('#E43F72')
              ,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
        Container(child: Text('Follow',style: GoogleFonts.roboto(color: Colors.white,fontSize: 18),),),
        Container(child: Icon(Feather.user_check,color: Colors.white,),)
    ],),),
  )
  ],),);}),
     SizedBox(height: 40,),
          Container(child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
            Container(child: Column(children: [
              Container(child: Text('Followers',style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: HexColor('E43F72')),),),
              SizedBox(height: 10,),
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection('followers').snapshots(),
                builder: (context, snapshot) {
                  return Container(child: Text('0',style: GoogleFonts.roboto(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    ),),);
                }
              ),
            ],),),
            Container(child: Column(children: [
              Container(child: Text('Works',style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: HexColor('E43F72')),),),
              SizedBox(height: 10,),
              Container(child: Text('0',style: GoogleFonts.roboto(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    ),),),
            ],),),
          ],),),
          SizedBox(height: 20,),
          Container(
            height: MediaQuery.of(context).size.height-372,
            width: MediaQuery.of(context).size.width,
            child: UserBooks(user_id: widget.user_id,),)
    ],),
      ),);
  }
}
