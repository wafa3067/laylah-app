import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../components/custom_button.dart';
import '../components/custom_steper.dart';
import '../components/input_description.dart';
import '../components/input_text.dart';
import '../provider/set_state_class.dart';
import '../screens/main_page.dart';
import '../utils/colors.dart';


class ApplyForContract2 extends StatefulWidget {
  var book_id;
   ApplyForContract2({super.key,this.book_id});

  @override
  State<ApplyForContract2> createState() => _ApplyForContract2State();
}

class _ApplyForContract2State extends State<ApplyForContract2> {
  TextEditingController othersite = TextEditingController();
  TextEditingController pen_name = TextEditingController();
  TextEditingController number_of_years = TextEditingController();
  TextEditingController facebook_username = TextEditingController();
  TextEditingController document_number = TextEditingController();
  TextEditingController expeted_word = TextEditingController();
  TextEditingController chapter_word = TextEditingController();
  TextEditingController book_title = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [CustomColors.AppColor1, CustomColors.AppColor2]))),
        backgroundColor: CustomColors.AppColor1,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back)),
        title: Container(
          // margin: EdgeInsets.only(left: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(child: Text('Applying for contract...')),
            ],
          ),
        ),
      ),
      body: Container(
        // margin: EdgeInsets.only(left: 50, right: 50, top: 10),
        // padding: EdgeInsets.only(left: 50, right: 50),
        child: ListView(children: [
          Container(
            margin: EdgeInsets.all(8),
            child: Text(
              'Applying for contract',
              style: GoogleFonts.ptSerif(fontSize: 20),
            ),
          ),
          Container(
            child: InputText(
              text: book_title,
              name: 'Book Title',
              placeholder: 'Book Title',
              require: true,
            ),
          ),
          Container(
            margin: EdgeInsets.all(8),
            child: Text(
              'Type of contract',
              style: GoogleFonts.ptSerif(fontSize: 20),
            ),
          ),
          Consumer<SetStateClass>(
            builder: (context, myType, child) {
              return Container(
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          myType.Settypeofcontract(true);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: myType.type_of_contract == true
                                  ? CustomColors.AppColor1
                                  : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(12)),
                          margin: EdgeInsets.only(
                              left: 1, right: 1, bottom: 10, top: 5),
                          padding: EdgeInsets.all(1),
                          child: Row(
                            children: [
                              Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(45)),
                                child: Icon(
                                  Icons.done,
                                  color: myType.type_of_contract == true
                                      ? CustomColors.black87
                                      : Colors.white,
                                  size: 15,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                child: Text(
                                  'Alpha Contract[paid]',
                                  style: GoogleFonts.ptSerif(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          myType.Settypeofcontract(false);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: myType.type_of_contract == false
                                  ? CustomColors.AppColor1
                                  : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(12)),
                          margin: EdgeInsets.only(
                              left: 1, right: 1, bottom: 10, top: 5),
                          padding: EdgeInsets.all(1),
                          child: Row(
                            children: [
                              Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(45)),
                                child: Icon(
                                  Icons.done,
                                  color: myType.type_of_contract == false
                                      ? Colors.black
                                      : CustomColors.white,
                                  size: 15,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                child: Text(
                                  'Superstart Contract[free]',
                                  style: GoogleFonts.ptSerif(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ]),
              );
            },
          ),
          Container(
            margin: EdgeInsets.all(8),
            child: Text(
              'Intended Contract',
              style: GoogleFonts.ptSerif(fontSize: 20),
            ),
          ),
          Consumer<SetStateClass>(
            builder: (context, myType, child) {
              return Container(
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          myType.setExclusive(true);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: myType.Exclusive == true
                                  ? CustomColors.AppColor1
                                  : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(12)),
                          margin: EdgeInsets.only(
                              left: 1, right: 1, bottom: 10, top: 5),
                          padding: EdgeInsets.all(1),
                          child: Row(
                            children: [
                              Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(45)),
                                child: Icon(
                                  Icons.done,
                                  color: myType.Exclusive == true
                                      ? CustomColors.black87
                                      : Colors.white,
                                  size: 15,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                child: Text(
                                  'Exclusive Contract',
                                  style: GoogleFonts.ptSerif(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          myType.setExclusive(false);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: myType.Exclusive == false
                                  ? CustomColors.AppColor1
                                  : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(12)),
                          margin: EdgeInsets.only(
                              left: 1, right: 1, bottom: 10, top: 5),
                          padding: EdgeInsets.all(1),
                          child: Row(
                            children: [
                              Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(45)),
                                child: Icon(
                                  Icons.done,
                                  color: myType.Exclusive == false
                                      ? Colors.black
                                      : CustomColors.white,
                                  size: 15,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                child: Text(
                                  'Non-Exclusive Contract',
                                  style: GoogleFonts.ptSerif(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ]),
              );
            },
          ),
          Container(
            child: InputText(
              text: number_of_years,
              name: 'Number of years',
              placeholder: 'Enter number of years',
              require: true,
            ),
          ),
          Container(
            child: InputText(
              text: expeted_word,
              name: 'Expected number of words',
              placeholder: 'Enter expected number of words',
              require: true,
            ),
          ),
          Container(
            child: InputText(
              text: chapter_word,
              name: 'Average Chapter words',
              placeholder: 'Enter Average Chapter words',
              require: true,
            ),
          ),
          Container(
            margin: EdgeInsets.all(12),
            child: Text(
              'Is this book already a completed worked offline',
              style: GoogleFonts.ptSerif(fontSize: 16),
            ),
          ),
          Consumer<SetStateClass>(
            builder: (context, myType, child) {
              return Container(
                margin: EdgeInsets.all(12),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          myType.SetOfflineCompleted(true);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: myType.offlinecompleted == true
                                  ? CustomColors.AppColor1
                                  : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(12)),
                          margin: EdgeInsets.only(
                              left: 1, right: 1, bottom: 10, top: 5),
                          padding: EdgeInsets.all(1),
                          child: Row(
                            children: [
                              Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(45)),
                                child: Icon(
                                  Icons.done,
                                  color: myType.offlinecompleted == true
                                      ? CustomColors.black87
                                      : Colors.white,
                                  size: 15,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                child: Text(
                                  ' Yes ',
                                  style: GoogleFonts.ptSerif(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      InkWell(
                        onTap: () {
                          myType.SetOfflineCompleted(false);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: myType.offlinecompleted == false
                                  ? CustomColors.AppColor1
                                  : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(12)),
                          margin: EdgeInsets.only(
                              left: 1, right: 1, bottom: 10, top: 5),
                          padding: EdgeInsets.all(1),
                          child: Row(
                            children: [
                              Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(45)),
                                child: Icon(
                                  Icons.done,
                                  color: myType.type_of_contract == false
                                      ? Colors.black
                                      : CustomColors.white,
                                  size: 15,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                child: Text(
                                  ' No ',
                                  style: GoogleFonts.ptSerif(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ]),
              );
            },
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.all(12),
            child: Text(
              'Is this book Available on another site',
              style: GoogleFonts.ptSerif(fontSize: 16),
            ),
          ),
          Consumer<SetStateClass>(
            builder: (context, myType, child) {
              return Container(
                margin: EdgeInsets.all(12),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          myType.SetOtherSite(true);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: myType.other_site == true
                                  ? CustomColors.AppColor1
                                  : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(12)),
                          margin: EdgeInsets.only(
                              left: 1, right: 1, bottom: 10, top: 5),
                          padding: EdgeInsets.all(1),
                          child: Row(
                            children: [
                              Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(45)),
                                child: Icon(
                                  Icons.done,
                                  color: myType.other_site == true
                                      ? CustomColors.black87
                                      : Colors.white,
                                  size: 15,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                child: Text(
                                  ' Yes ',
                                  style: GoogleFonts.ptSerif(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      InkWell(
                        onTap: () {
                          myType.SetOtherSite(false);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: myType.other_site == false
                                  ? CustomColors.AppColor1
                                  : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(12)),
                          margin: EdgeInsets.only(
                              left: 1, right: 1, bottom: 10, top: 5),
                          padding: EdgeInsets.all(1),
                          child: Row(
                            children: [
                              Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(45)),
                                child: Icon(
                                  Icons.done,
                                  color: myType.other_site == false
                                      ? Colors.black
                                      : CustomColors.white,
                                  size: 15,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                child: Text(
                                  ' No ',
                                  style: GoogleFonts.ptSerif(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      myType.other_site == true
                          ? Container(
                              width: 230,
                              child: InputText(
                                require: true,
                                name: ' Book link',
                                placeholder: 'paste book link',
                                text: othersite,
                              ),
                            )
                          : Container()
                    ]),
              );
            },
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.all(12),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 2.5,
                    alignment: Alignment.center,
                    child: CustomButton(
                        text: 'Submit',
                        text_color: null,
                        color: null,
                        onTap: () async {
                          var uuid = Uuid().v1();
                          final provider = Provider.of<SetStateClass>(context,
                              listen: false);
                          var storage = FlutterSecureStorage();
                          var user_id = await storage.read(key: 'uid');
                          FirebaseFirestore.instance
                              .collection('contract-requests')
                              .doc(uuid)
                              .set({
                            'user_id': user_id,
                            'id': uuid,
                            'book_titel': book_title.text,
                            'type_contract': provider.type_of_contract == true
                                ? 'Alpha contract'
                                : 'Superstart contract',
                            'intend_contract': provider.Exclusive == true
                                ? 'Exclusive contract'
                                : 'Non-exclusive contract',
                            'number_of_yearts': number_of_years.text,
                            'chapter_word': chapter_word.text,
                            'expected_word': expeted_word.text,
                            'offline_completed':
                                provider.offlinecompleted == true
                                    ? 'yes'
                                    : 'not',
                            'another_site': provider.other_site == true
                                ? othersite.text
                                : ''
                          }).then((value) {
                           Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MainPage()));
                           
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('requsted submitted to admin')));
                            
                          });
                            FirebaseFirestore.instance
                  .collection('books').doc(widget.book_id).update({
                     'applied_for_contract':true,
                  });
                        }),
                  )
                ]),
          ),
        ]),
      ),
    );
  }
}
