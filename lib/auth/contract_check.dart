import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:laylah/auth/apply_for_contract1.dart';
import 'package:laylah/auth/apply_for_contract2.dart';

import '../utils/colors.dart';

class ContractCheck extends StatefulWidget {
  var book_id;
   ContractCheck({super.key,this.book_id});

  @override
  State<ContractCheck> createState() => _ContractCheckState();
}

class _ContractCheckState extends State<ContractCheck> {
  var storage = FlutterSecureStorage();
  var user = false;

  CheckBasic() async {
    var user_id = await storage.read(key: 'uid');
    FirebaseFirestore.instance
        .collection('basic')
        .doc(user_id)
        .get()
        .then((value) {
      if (value.data()!.length != 0) {
        setState(() {
          user = true;
        });
      }
    });
  }

  @override
  void initState() {
    CheckBasic();
    Future.delayed(Duration(seconds: 2), () {
      if (user == true) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ApplyForContract2(book_id:widget.book_id)));
      } else if (user == false) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ApplyForContract1()));
      }
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      child: CircularProgressIndicator(
        backgroundColor: CustomColors.AppColor1,
        color: CustomColors.blue50,
      ),
    ));
  }
}
