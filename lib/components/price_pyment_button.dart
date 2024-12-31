import 'package:flutter/material.dart';
import 'package:laylah/utils/default_stlye.dart';
import 'package:laylah/utils/default_stlye.dart';

class PricePaymentButton extends StatefulWidget {
  var price;
  var title;
   PricePaymentButton({super.key,required this.price,required this.title});

  @override
  State<PricePaymentButton> createState() => _PricePaymentButtonState();
}

class _PricePaymentButtonState extends State<PricePaymentButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.all(8),
      child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
      Container(child: Text(widget.title,style: DefaultStyle.blackStyle18bold,),),
      Container(child: Text(widget.price,style: DefaultStyle.blackStyle18bold,),),
    ],),);
  }
}
