import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laylah/components/custom_button.dart';
import 'package:laylah/payment_integration/payment_config.dart';
import 'package:laylah/utils/colors.dart';
import 'package:pay/pay.dart';
import 'dart:io' as p;

import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../provider/AppFunctions.dart';

class CoinCard extends StatefulWidget {
  var earn;
  CoinCard({super.key, this.earn});

  @override
  State<CoinCard> createState() => _CoinCardState();
}

class _CoinCardState extends State<CoinCard> {
  List Coins = [50, 100, 600, 1200, 1800, 2400, 3000];
  List CoinsPrice = [200, 600, 1150, 1880, 2900, 3200, 3299];

  static const _paymentItems = [
    PaymentItem(
      label: 'Total',
      amount: '99.99',
      status: PaymentItemStatus.final_price,
    )
  ];

  void onApplePayResult(paymentResult) {
    // Send the resulting Apple Pay token to your server / PSP
  }

  void onGooglePayResult(paymentResult) async {
    if (widget.earn != null) {
      final myType = Provider.of<AppFunctions>(context, listen: false);
      var date = DateTime.now();
      var storage = FlutterSecureStorage();
      var user_id = await storage.read(key: 'uid');
      FirebaseFirestore.instance
          .collection('users')
          .doc(user_id)
          .collection('topup')
          .get()
          .then((value) {
        if (value.docs.length == 0) {
          var check_id = Uuid().v1();
          FirebaseFirestore.instance
              .collection('users')
              .doc(user_id)
              .collection('topup')
              .doc(check_id)
              .set({
            'id': check_id,
            'coins': 20,
            'date': '${date.day}/${date.month}/${date.year}',
            'ad': 1,
          }).then((value) {
            myType.GetTotal();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.pink,
                content: Center(child: Text('You Have Earned 3 Coins'))));
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.pink,
              content: Center(child: Text('You Have Earned All Coins'))));
        }
        // Send the resulting Google Pay token to your server / PSP
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('coins').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
                margin: EdgeInsets.all(12),
                child: AlignedGridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  itemCount: snapshot.data!.docs.length,
                  crossAxisSpacing: 10,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          CustomColors.AppColor2,
                          CustomColors.lowlighttpink,
                        ]),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            child: Container(
                                child: Icon(
                              MaterialCommunityIcons.star_box,
                              color: CustomColors.white,
                              fill: 0.5,
                            )),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      '${snapshot.data!.docs[index]['coins']} COINS',
                                      style: GoogleFonts.ptSerif(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      '\$${snapshot.data!.docs[index]['price']}',
                                      style: GoogleFonts.ptSerif(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ]),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Divider(
                            height: 5,
                          ),
                          SizedBox(
                            height: 10,
                          ),

                          p.Platform.isAndroid
                              ? Container(
                                  // height: 40,
                                  child: GooglePayButton(
                                    paymentConfiguration:
                                        PaymentConfiguration.fromJsonString(
                                            defaultGooglePay),
                                    paymentItems: [
                                      PaymentItem(
                                        label: 'Total amount',
                                        amount:
                                            '${snapshot.data!.docs[index]['price']}',
                                        status: PaymentItemStatus.final_price,
                                      )
                                    ],
                                    type: GooglePayButtonType.pay,
                                    margin: const EdgeInsets.only(top: 15.0),
                                    onPaymentResult: onGooglePayResult,
                                    loadingIndicator: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 50,
                                  width: 130,
                                  child: ApplePayButton(
                                    paymentConfiguration:
                                        PaymentConfiguration.fromJsonString(
                                            defaultApplePay),
                                    paymentItems: [
                                      PaymentItem(
                                        label:
                                            " Total ${snapshot.data!.docs[index]['coins']} Coins",
                                        amount: snapshot.data!.docs[index]
                                            ['price'],
                                        status: PaymentItemStatus.final_price,
                                      )
                                    ],
                                    style: ApplePayButtonStyle.black,
                                    type: ApplePayButtonType.buy,
                                    margin: const EdgeInsets.only(top: 15.0),
                                    onPaymentResult: onApplePayResult,
                                    loadingIndicator: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                ),
                          // CustomButton(
                          //   color: null,
                          //   text: 'Pay Now',
                          //   text_color: CustomColors.darkgrey,
                          //   gr_color1: CustomColors.mixpink,
                          //   gr_color2: CustomColors.white,
                          //   onTap: () {},
                          // )
                        ],
                      ),
                    );
                  },
                ));
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
