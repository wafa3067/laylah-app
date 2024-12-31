import 'dart:io';

import 'package:change_case/change_case.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:laylah/components/custom_button.dart';
import 'package:laylah/components/input_text.dart';
import 'package:laylah/components/setting_components.dart';
import 'package:laylah/provider/AppFunctions.dart';
import 'package:provider/provider.dart';

import '../utils/colors.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  TextEditingController name=TextEditingController();


  @override
  Widget build(BuildContext context) {
    final auth=FirebaseAuth.instance;
bool hover=false;
    print(hover);
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting',style: GoogleFonts.roboto(color: Colors.pink),),
        leading: InkWell(onTap: (){
          Navigator.pop(context);
        },child: Icon(Icons.arrow_back,color: Colors.pink,),),
        backgroundColor: HexColor('#f8f2f6'),
      ),
      backgroundColor: Colors.blueGrey.shade50,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(child: Image.asset('images/l.png',color: Colors.white,height: 100,),),
          Container(child: Image.asset('images/logop.png',height: 100,),),
    SettingComponents(icon: Icons.people, name: 'Update Profile', onTap: (){
      showDialog(context: context, builder: (context){
        return  AlertDialog(title: Container(
            child: Consumer<AppFunctions>(
              builder: (context, myType, child) {
                print(myType.hover);
                return  Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      child: MouseRegion(

                        onEnter: (event){

                          setState(() {
                            hover=true;
                          });
                        },
                        onExit: (event){
                          setState(() {
                            hover=false;
                          });
                        },
                        child: Center(
                          child: Stack(
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
                              hover==false ? Align(

                               alignment: Alignment.center,
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  alignment:Alignment.center,
                                  child: InkWell(child: Icon(Icons.change_circle_outlined,size: 50,color: Colors.white,),),),
                              ):Container(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width:MediaQuery.of(context).size.width/2.5,
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: '${myType.displayName!=null ? myType.displayName:myType.no_photo}'
                            ),
                        ),),
                        Container(
                          width:70,
                          child: CustomButton(
                            gr_color1:Colors.blueGrey.shade50,
                            gr_color2:Colors.blueGrey.shade50,
                            onTap: (){
                          myType.Updateuser(name);
                        },text: 'Update ',color: null,text_color: Colors.black,),),
                      ],
                    ),


                  ],
                );
              },
            ),)

        );
      });
    }),
    SettingComponents(icon: Ionicons.reader_outline, name: 'Terms & Conditions', onTap: (){}),
    SettingComponents(icon: MaterialIcons.privacy_tip, name: 'Privacy policy', onTap: (){}),
    SettingComponents(icon: Icons.lock, name: 'DMCA', onTap: (){}),
    SettingComponents(icon: Icons.star_half_rounded, name: 'Rate Us', onTap: (){}),
    SettingComponents(icon: Icons.logout, name: 'Logout', onTap: ()async{
      var storage=FlutterSecureStorage();
      await storage.delete(key: 'uid');
    }),

//         Container(child: Column(children: [
//           Consumer<AppFunctions>(
//             builder: (context, myType, child) {
//               print(myType.hover);
//               return  Container(
//                 alignment: Alignment.center,
//                 width: MediaQuery.of(context).size.width,
//                 child: MouseRegion(
//
//                   onEnter: (event){
//
//                   setState(() {
//                     hover=true;
//                   });
//                   },
//                   onExit: (event){
//                     setState(() {
//                       hover=false;
//                     });
//                   },
//                   child: Center(
//                     child: Stack(
//                       children: [
//                         Center(
//                           child: Container(
//                             width: 100,
//                             height: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(50),
//                               boxShadow: [
//                                 BoxShadow(
//                                     color: CustomColors.lightyellow, blurRadius: 1),
//                               ],
//                             ),
//                             child:myType.profile != 'null' ? ClipRRect(
//                               borderRadius: BorderRadius.circular(50),
//                               child:
//                               Image.network(
//                                 '${myType.profile}',
//                                 fit: BoxFit.cover,
//                               ),
//                             ):Center(child: Text('${myType.no_photo}'.toCapitalCase(),style: GoogleFonts.roboto(fontSize: 72),)),
//                           ),
//                         ),
//                         hover==false ? Container(
//                           alignment:Alignment.center,
//                           child: InkWell(child: Icon(Icons.change_circle_outlined),),):Container(),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           Consumer<AppFunctions>(
//             builder: (context, myType, child) {
//
//               return Container(
//                 child: Text(
//                   '${myType.displayName}',
//                   style: GoogleFonts.ptSerif(
//                       fontSize: 20,
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold),
//                 ),
//               );
//             },
//           ),
//
//         ],),),
//         Container(child: InputText(
//   require: false,
//   text:name,
//   placeholder: 'Enter Name To Update',
//   name: 'Name',
// ),),
//         Consumer<AppFunctions>(builder: (context,value,child){
//           return  Column(
//             children: [
//               Container(child: CustomButton(onTap: (){
//                 value .Updateuser(name);
//               },text: 'Update ',color: null,text_color: null,),),
//               SizedBox(height: 10,),
//               value.cover !=null ?   Container(child: ClipRRect(
//                    borderRadius:BorderRadius.circular(100),
//                   child: Image.file(File(value.cover!.path),height: 140,width: 140,fit: BoxFit.fill,)),
//
//               ):Container(),
//               Container(child: CustomButton(onTap: (){
//
//                 value.PickImage();
//               },text: 'Pic Image ',color: null,text_color: null,),),
//             ],
//           );
//         })

    ],),);
  }
}
