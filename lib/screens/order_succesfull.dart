import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderSuccessfull extends StatefulWidget {
  const OrderSuccessfull({super.key});

  @override
  State<OrderSuccessfull> createState() => _OrderSuccessfullState();
}

class _OrderSuccessfullState extends State<OrderSuccessfull> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blueGrey.shade50,
        width: MediaQuery.of(context).size.width,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Container(
              //   height: 50,
              //   child: Image.asset(
              //     'images/l.png',
              //     color: Colors.red,
              //   ),
              // ),
              // SizedBox(
              //   height: 20,
              // ),
              // Container(
              //   child: Image.asset(
              //     'images/laylah.png',
              //     color: Colors.pink,
              //   ),
              // ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.green, width: 6),
                    borderRadius: BorderRadius.circular(50)),
                child: Icon(
                  MaterialIcons.done,
                  color: Colors.green,
                  size: 70,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Text(
                  'Order Completed Successfully',
                  style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Text(
                  '50 coins added to your account thank you for buying',
                  style: GoogleFonts.roboto(
                    color: Colors.grey,
                  ),
                ),
              )
            ]),
      ),
    );
  }
}
