import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:laylah/components/custom_button.dart';
import 'package:laylah/provider/set_state_class.dart';
import 'package:laylah/utils/colors.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey.shade50,
        appBar: AppBar(
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back,color: Colors.pink,),
            ),
            flexibleSpace: Container(
                color: HexColor('#f8f2f6')
              // decoration: BoxDecoration(
              //     gradient: LinearGradient(colors: [
              //   CustomColors.AppColor1,
              //   CustomColors.AppColor2
              // ])),
            ),
            title: Text('Notifications',style: GoogleFonts.roboto(color: Colors.pink),)),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('notifications')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Image.asset(
                        'images/notification.png',
                        height: 100,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      child: Text(
                        'No Notification Found',
                        style: GoogleFonts.roboto(fontSize: 22),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      child: Center(
                        child: Text(
                          "You have currently no notifications.We'll notify you when something new arrives",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(fontSize: 16),
                        ),
                      ),
                    ),
SizedBox(height: 10,),
                    Consumer<SetStateClass>(builder: (context ,value,child){
                      return  Container(
                        width: 125,
                        child: CustomButton(

                          text: 'Back to Home',
                          onTap: () {
                           Navigator.pop(context);

                          },
                          color: null,
                          text_color: Colors.black87,
                          gr_color1: Colors.blueGrey.shade50,
                          gr_color2: Colors.blueGrey.shade50,
                        ),
                      );
                    }),

                  ],
                );
              }
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, int index) {
                      return Container(
                        decoration: BoxDecoration(
                            color: CustomColors.pink1,
                            gradient: LinearGradient(colors: [
                              CustomColors.AppColor1,
                              CustomColors.AppColor2
                            ]),
                            borderRadius: BorderRadius.circular(12)),
                        margin: EdgeInsets.all(12),
                        padding: EdgeInsets.all(12),
                        // height: 70,
                        child: Expanded(
                          child: Column(children: [
                            Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 80,
                                    child: Text(
                                        'you have new sms for your profile regrading read this is this ok to show here or not please confirm me that  ',
                                        style: GoogleFonts.ptSerif(
                                          fontSize: 16,
                                          color: Colors.white,
                                        )),
                                  ),
                                  InkWell(
                                    onTap: () {},
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Icon(
                                        Icons.close,
                                        color: CustomColors.white,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${DateTime.now()}',
                                style: GoogleFonts.ptSerif(
                                    color: Colors.yellow, fontSize: 18),
                              ),
                            ),
                          ]),
                        ),
                      );
                    });
              }

              return Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}
