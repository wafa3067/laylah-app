import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laylah/auth/apply_for_contract2.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../components/CustomIconButton.dart';
import '../components/custom_button.dart';
import '../components/custom_dropdown.dart';
import '../components/custom_steper.dart';
import '../components/input_text.dart';
import '../provider/set_state_class.dart';
import '../utils/colors.dart';

class ApplyForContract1 extends StatefulWidget {
  const ApplyForContract1({super.key});

  @override
  State<ApplyForContract1> createState() => _ApplyForContract1State();
}

class _ApplyForContract1State extends State<ApplyForContract1> {
  TextEditingController real_name = TextEditingController();
  TextEditingController pen_name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController website = TextEditingController();
  // TextEditingController document_number = TextEditingController();
  TextEditingController postel_code = TextEditingController();
  TextEditingController choose_country = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();

  var Storage = FlutterSecureStorage();
  bool image_loading1 = false;
  String? _image1;
  var uuid = Uuid().v1();

  Future<void> PickImage1() async {
    setState(() {
      image_loading1 = true;
    });
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    var uuid = Uuid();
    var file = File(image!.path);
    final _imageStorage = FirebaseStorage.instance;
    var snapshot =
        await _imageStorage.ref().child('images/${uuid.v1()}').putFile(file);
    var url = await snapshot.ref.getDownloadURL();

    if (await url != null) {
      setState(() {
        _image1 = url;
        image_loading1 = false;
      });
    }
  }

  bool image_loading2 = false;
  String? _image2;

  Future<void> PickImage2() async {
    setState(() {
      image_loading2 = true;
    });
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    var uuid = Uuid();
    var file = File(image!.path);
    final _imageStorage = FirebaseStorage.instance;
    var snapshot =
        await _imageStorage.ref().child('images/${uuid.v1()}').putFile(file);
    var url = await snapshot.ref.getDownloadURL();

    if (await url != null) {
      setState(() {
        _image2 = url;
        image_loading2 = false;
      });
    }
  }

  BasicInfo() async {
    final provider = Provider.of<SetStateClass>(context, listen: false);
    var user_id = await Storage.read(key: 'uid');
    FirebaseFirestore.instance.collection('basic').doc(user_id).set({
      'id': user_id,
      'name': real_name.text,
      'pen_name': pen_name.text,
      'email': email.text,
      'website': website.text,
      'id_card': provider.id_card,
      'driving': provider.driving_check,
      'passport': provider.passport_check,
      'document_front': _image1,
      'postel': postel_code.text,
      'document_back': _image2,
      'city': city.text,
      'country': choose_country.text,
      'state': state.text,
      'address': address.text,
      'age': provider.age_check == true ? 'above 21' : 'below 21',
      'number': "${provider.country_code}${number.text}",
      'payoner': provider.payoneer,
      'agree': provider.agree,
    }).then((value) => {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Added successfully'))),
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ApplyForContract2()))
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
            decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [CustomColors.AppColor1, CustomColors.AppColor2]),
        )),
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
              Container(child: Text('Basic Info')),
            ],
          ),
        ),
      ),
      body: Container(
        // margin: EdgeInsets.all(50),
        // padding: EdgeInsets.only(left: 50, right: 50),
        child: ListView(children: [
          SizedBox(
            height: 10,
          ),
          Center(
            child: Container(
              margin: EdgeInsets.all(8),
              child: Text(
                'You are welcome to become the Signed auther',
                style: GoogleFonts.ptSerif(fontSize: 20),
              ),
            ),
          ),
          Container(
            child: InputText(
              text: real_name,
              name: 'Name',
              placeholder: 'Fill ID card full name',
              require: true,
            ),
          ),
          Container(
            child: InputText(
              text: pen_name,
              name: 'Pen Name',
              placeholder: 'Pen Name',
              require: true,
            ),
          ),
          Container(
            child: InputText(
              text: website,
              name: 'Website/Plateform',
              placeholder: ' Enter Website/plateform address',
              require: false,
            ),
          ),
          Container(
            child: InputText(
              text: email,
              name: 'Email Address',
              placeholder: 'Email Address',
              require: true,
            ),
          ),
          Container(
              // margin: EdgeInsets.only(left: 15, right: 15),
              child: InputText(
            text: TextEditingController(text: choose_country.text),
            readOnly: true,
            require: true,
            name: 'Choose Country',
            placeholder: 'Select Country',
            onTap: () {
              showCountryPicker(
                context: context,
                showPhoneCode:
                    true, // optional. Shows phone code before the country name.
                onSelect: (Country country) {
                  setState(() {
                    choose_country.text = "${country.displayNameNoCountryCode}";
                  });
                },
              );
            },
          )),
          Container(
            child: InputText(
              text: address,
              name: 'Permanent Address',
              placeholder: '',
              require: true,
            ),
          ),
          Container(
            child: InputText(
              text: city,
              name: 'City',
              placeholder: '',
              require: true,
            ),
          ),
          Container(
            child: InputText(
              text: state,
              name: 'State',
              placeholder: '',
              require: true,
            ),
          ),
          Container(
            child: InputText(
              text: postel_code,
              name: 'Postel or zip code',
              placeholder: '',
              require: false,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 8),
            child: Row(
              children: [
                Container(
                  child: Text(
                    '*',
                    style: GoogleFonts.ptSerif(color: Colors.red, fontSize: 18),
                  ),
                ),
                Container(
                  child: Text(
                    'Age',
                    style: GoogleFonts.ptSerif(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          Consumer<SetStateClass>(
            builder: (context, value, child) {
              return Container(
                decoration: BoxDecoration(
                    color: CustomColors.AppColor1,
                    borderRadius: BorderRadius.circular(12)),
                margin:
                    EdgeInsets.only(left: 35, right: 12, bottom: 10, top: 5),
                padding: EdgeInsets.all(1),
                child: InkWell(
                  onTap: () {
                    if (value.age_check == true) {
                      value.setAge(false);
                    } else {
                      value.setAge(true);
                    }
                  },
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
                          color: value.age_check == true
                              ? CustomColors.black87
                              : CustomColors.white,
                          size: 15,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        child: Text(
                          'I am above 21 years of age',
                          style: GoogleFonts.ptSerif(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Container(
            margin: EdgeInsets.only(left: 8),
            child: Row(
              children: [
                Container(
                  child: Text(
                    '*',
                    style: GoogleFonts.ptSerif(color: Colors.red, fontSize: 18),
                  ),
                ),
                Container(
                  child: Text(
                    'Telephone number',
                    style: GoogleFonts.ptSerif(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Row(children: [
              Container(
                child: Consumer<SetStateClass>(
                  builder: (context, myType, child) {
                    return CountryCodePicker(
                      onChanged: (v) {
                        myType.setCountryCode("${v.code}");
                      },
                      // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                      initialSelection: 'IT',
                      favorite: ['+92', 'PK'],
                      // optional. Shows only country name and flag
                      showCountryOnly: false,
                      // optional. Shows only country name and flag when popup is closed.
                      showOnlyCountryWhenClosed: false,
                      // optional. aligns the flag and the Text left
                      alignLeft: false,
                    );
                  },
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width - 110,
                child: TextFormField(
                    controller: number,
                    decoration: InputDecoration(
                        fillColor: CustomColors.blue50,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide.none),
                        hintText: '',
                        hintStyle: GoogleFonts.ptSerif())),
              )
            ]),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.only(left: 8),
            child: Row(
              children: [
                Container(
                  child: Text(
                    '*',
                    style: GoogleFonts.ptSerif(color: Colors.red, fontSize: 18),
                  ),
                ),
                Container(
                  child: Text(
                    'documents',
                    style: GoogleFonts.ptSerif(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Consumer<SetStateClass>(
            builder: (context, myType, child) {
              return Row(
                children: [
                  InkWell(
                    onTap: () {
                      myType.setSaveDocument(
                          id: true, passport: false, driving: false);
                    },
                    child: Container(
                      child: Row(
                        children: [
                          Container(
                            child: Icon(myType.id_card == true
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off),
                          ),
                          Text('National Id'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: () {
                      myType.setSaveDocument(
                          id: false, passport: true, driving: false);
                    },
                    child: Container(
                      child: Row(
                        children: [
                          Container(
                            child: Icon(myType.passport_check == true
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off),
                          ),
                          Text('Passport'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      myType.setSaveDocument(
                          id: false, passport: false, driving: true);
                    },
                    child: Container(
                      child: Row(
                        children: [
                          Container(
                            child: Icon(myType.driving_check == true
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off),
                          ),
                          Text('Driving licence'),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Container(
                height: 200,
                margin: EdgeInsets.all(12),
                width: MediaQuery.of(context).size.width - 24,
                child: _image1 == null
                    ? Image.asset(
                        'images/front.png',
                        fit: BoxFit.fill,
                        filterQuality: FilterQuality.high,
                      )
                    : Image.network("$_image1"),
              ),
            ],
          ),
          InkWell(
            splashColor: CustomColors.AppColor1,
            onTap: () {
              PickImage1();
            },
            child: Container(
              margin: EdgeInsets.all(12),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: InkWell(
                        splashColor: CustomColors.AppColor1,
                        onTap: () {},
                        child: Icon(
                          Icons.add_circle,
                          color: CustomColors.AppColor1,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      child: Text(
                        'click to upload the front image of ducument',
                        style: GoogleFonts.ptSerif(
                            fontSize: 14, color: CustomColors.AppColor1),
                      ),
                    ),
                  ]),
            ),
          ),
          Row(
            children: [
              Container(
                height: 200,
                margin: EdgeInsets.all(12),
                width: MediaQuery.of(context).size.width - 24,
                child: _image2 == null
                    ? Image.asset(
                        'images/back.png',
                        fit: BoxFit.fill,
                        filterQuality: FilterQuality.high,
                      )
                    : Image.network('$_image2'),
              ),
            ],
          ),
          InkWell(
            splashColor: CustomColors.AppColor1,
            onTap: () {
              PickImage2();
            },
            child: Container(
              margin: EdgeInsets.all(12),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: InkWell(
                        splashColor: CustomColors.AppColor1,
                        onTap: () {},
                        child: Icon(
                          Icons.add_circle,
                          color: CustomColors.AppColor1,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      child: Text(
                        'click to upload the back image of ducument',
                        style: GoogleFonts.ptSerif(
                            fontSize: 14, color: CustomColors.AppColor1),
                      ),
                    ),
                  ]),
            ),
          ),
          Container(
            child: Text('Do you have a payoneer'),
          ),
          Consumer<SetStateClass>(
            builder: (context, myType, child) {
              return Row(
                children: [
                  InkWell(
                    onTap: () {
                      myType.setSavePayoneer(true);
                    },
                    child: Container(
                      child: Row(
                        children: [
                          Container(
                            child: Icon(myType.payoneer == true
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off),
                          ),
                          Text('Yes'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: () {
                      myType.setSavePayoneer(false);
                    },
                    child: Container(
                      child: Row(
                        children: [
                          Container(
                            child: Icon(myType.payoneer == false
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off),
                          ),
                          Text('No'),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(
            height: 10,
          ),
          Container(child: Consumer<SetStateClass>(
            builder: (context, myType, child) {
              return InkWell(
                onTap: () {
                  if (myType.agree == true) {
                    myType.setSaveAgree(false);
                  } else {
                    myType.setSaveAgree(true);
                  }
                },
                child: Row(children: [
                  Container(
                    child: Icon(myType.agree == false
                        ? Icons.check_box_outline_blank
                        : Icons.check_box),
                  ),
                  Container(
                    child:
                        Text('Agree to turms and conditions & privacy policy'),
                  )
                ]),
              );
            },
          )),
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: CustomIconButton(
              // icon: Icons.upload,
              color1: CustomColors.blue200,
              color2: CustomColors.blue100,
              title: 'Continue',
              onTap: () {
                BasicInfo();
              },
            ),
          )
        ]),
      ),
    );
  }
}
