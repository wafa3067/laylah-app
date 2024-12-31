import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:laylah/components/payment_income_card.dart';
import 'package:laylah/components/price_pyment_button.dart';
import 'package:laylah/provider/AppFunctions.dart';
import 'package:laylah/utils/default_stlye.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  bool payment_histry = false;

  Widget build(BuildContext context) {
    return Scaffold(
      body: payment_histry == true
          ? ListView(
              shrinkWrap: true,
              children: [
                Container(
                  margin: EdgeInsets.all(12),
                  alignment: Alignment.topRight,
                  child: Text(
                    'Payment History',
                    style: DefaultStyle.blackStylebold,
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 35,
                        width: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: HexColor('#E43F72')),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(22)),
                                    child: Text(
                                      'Apr 2023',
                                      style: DefaultStyle.blackStylebold,
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      'V',
                                      style: DefaultStyle.whiteNormal,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Consumer<AppFunctions>(
                        builder: (BuildContext context, value, Widget? child) {
                          return Container(
                            child: Column(
                              children: [
                                Container(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: value.profile != 'null'
                                        ? Image.network(
                                            '${value.profile}',
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.fill,
                                          )
                                        : Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                color: Colors.grey.shade400),
                                            child: Center(
                                                child: Text(
                                              '${value.no_photo}'
                                                  .toCapitalCase(),
                                              style: GoogleFonts.roboto(
                                                  fontSize: 40),
                                            )),
                                          ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  child: Text(
                                    '${value.displayName}',
                                    style: DefaultStyle.blackStylebold,
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  child: PricePaymentButton(
                    title: 'Total Income:',
                    price: '\$12.00',
                  ),
                ),
                Container(
                  child: PricePaymentButton(
                    title: 'Bonus Income:',
                    price: '\$0.00',
                  ),
                ),
                Container(
                  child: PricePaymentButton(
                    title: 'Reward Income:',
                    price: '\$0.00',
                  ),
                ),
                Container(
                  child: PricePaymentButton(
                    title: 'Ad Revenue:',
                    price: '\$0.00',
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(12),
                  child: Text(
                    'Income Detail',
                    style: DefaultStyle.blackStyle18bold,
                  ),
                ),
                PaymentIconCard(
                  title: "Un Rostro Oscultro",
                  status: 'OnGoing',
                  contract_type: 'Exclusive',
                  date: 'Apr 2023',
                  cover: 'images/sms1.png',
                ),
                PaymentIconCard(
                  title: "Data Recovery Soft",
                  status: 'Completed',
                  contract_type: 'Non-Exclusive',
                  date: 'Jun 2023',
                  cover: 'images/apple.png',
                ),
              ],
            )
          : SafeArea(
              child: Container(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(12),
                      alignment: Alignment.center,
                      child: Text(
                        'Payment History',
                        style: GoogleFonts.roboto(
                            color: HexColor(
                              '#E43F72',
                            ),
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 35,
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: HexColor('#E43F72')),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(22)),
                                  child: Text(
                                    'Apr 2023',
                                    style: DefaultStyle.blackStylebold,
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    'V',
                                    style: DefaultStyle.whiteNormal,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height-182,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Image.asset(
                              'images/history.png',
                              width: 100,
                              height: 100,
                            ),
                          ),
                          Container(
                            child: Text('No  History Found',style: GoogleFonts.roboto(fontWeight: FontWeight.w600,fontSize: 20),),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
