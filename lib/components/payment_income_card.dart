import 'package:flutter/material.dart';
import 'package:laylah/utils/default_stlye.dart';

class PaymentIconCard extends StatefulWidget {
  var title;
  var status;
  var contract_type;
  var date;
  var cover;
  PaymentIconCard(
      {super.key,
      required this.title,
      required this.cover,
      required this.contract_type,
      required this.date,
      required this.status});

  @override
  State<PaymentIconCard> createState() => _PaymentIconCardState();
}

class _PaymentIconCardState extends State<PaymentIconCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 180,
                  child: Image.asset('${widget.cover}'),
                ),
                Container(
                  margin: EdgeInsets.only(left: 6, top: 6),
                  width: MediaQuery.of(context).size.width - 122,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Text(
                          '${widget.title}',
                          textAlign: TextAlign.justify,
                          style: DefaultStyle.blackStyle18bold,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        child: Text(
                          'Book Status : ${widget.status}',
                          style: DefaultStyle.blackNormal,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        child: Text(
                          'Contract Type : ${widget.contract_type}',
                          style: DefaultStyle.blackNormal,
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          '\$0.00',
                          style: DefaultStyle.blackStyle18bold,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          '${widget.date}',
                          style: DefaultStyle.blackNormal,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Divider(
            color: Colors.grey,
            thickness: 5,
          )
        ],
      ),
    );
  }
}
