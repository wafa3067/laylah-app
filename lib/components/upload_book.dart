import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laylah/components/custom_button.dart';
import 'package:laylah/components/input_text.dart';
import 'package:laylah/components/upload_book2.dart';


import '../screens/welcome_screen.dart';
import '../utils/colors.dart';

class UploadBook extends StatefulWidget {
  const UploadBook({super.key});

  @override
  State<UploadBook> createState() => _UploadBookState();
}

class _UploadBookState extends State<UploadBook> {
  final List<String> items = [
    'English',
  ];
  var cover;
  var gender;
  var content;

  PickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        cover = File(image.path);
      });
    }
  }

  String? selectedValue;
  final TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  TextEditingController book_title = TextEditingController();
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
          margin: EdgeInsets.only(left: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(child: Text('Story Description')),

            ],
          ),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 10),
                padding: EdgeInsets.only(top: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '*',
                      style:
                          GoogleFonts.ptSerif(color: Colors.red, fontSize: 20),
                    ),
                    Text(
                      'Choose Book Cover',
                      style: GoogleFonts.ptSerif(),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  PickImage();
                },
                child: Container(
                  margin:
                      EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12)),
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  child: cover == null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add),
                            Text(
                              'New Story',
                              style: GoogleFonts.ptSerif(),
                            )
                          ],
                        )
                      : Container(
                          child: Image.file(cover),
                        ),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '*',
                  style: GoogleFonts.ptSerif(color: Colors.red, fontSize: 20),
                ),
                Text(
                  ' Book Title',
                  style: GoogleFonts.ptSerif(),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(12),
            child: InputText(
              text: book_title,
              require: true,
              name: 'Book title',
              placeholder: 'Enter book title',
            ),
          ),
          Divider(
            color: Colors.grey,
            height: 4,
          ),
          Container(
            margin: EdgeInsets.all(12),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.grey.shade200),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: Row(
                    children: [
                      Text(
                        '*',
                        style: GoogleFonts.ptSerif(
                            color: Colors.red, fontSize: 20),
                      ),
                      Text(
                        'Language',
                        style: GoogleFonts.ptSerif(
                          fontSize: 14,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 120,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: Text(
                        'Select Language ',
                        style: GoogleFonts.ptSerif(
                          fontSize: 14,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      items: items
                          .map((item) => DropdownMenuItem(
                                value: item,
                                child: Text(
                                  item,
                                  style: GoogleFonts.ptSerif(
                                    fontSize: 14,
                                  ),
                                ),
                              ))
                          .toList(),
                      value: selectedValue,
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value as String;
                        });
                      },
                      buttonStyleData: const ButtonStyleData(
                        height: 40,
                        width: 200,
                      ),
                      dropdownStyleData: const DropdownStyleData(
                        maxHeight: 200,
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        height: 40,
                      ),
                      dropdownSearchData: DropdownSearchData(
                        searchController: textEditingController,
                        searchInnerWidgetHeight: 50,
                        searchInnerWidget: Container(
                          height: 50,
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 4,
                            right: 8,
                            left: 8,
                          ),
                          child: TextFormField(
                            expands: true,
                            maxLines: null,
                            controller: textEditingController,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              hintText: 'Search for an item...',
                              hintStyle: const TextStyle(fontSize: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        searchMatchFn: (item, searchValue) {
                          return (item.value.toString().contains(searchValue));
                        },
                      ),
                      //This to clear the search value when you close the menu
                      onMenuStateChange: (isOpen) {
                        if (!isOpen) {
                          textEditingController.clear();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '*',
                  style: GoogleFonts.ptSerif(color: Colors.red, fontSize: 20),
                ),
                Text(
                  'Target Audience',
                  style: GoogleFonts.ptSerif(),
                ),
              ],
            ),
          ),
          Container(
            child: Row(children: [
              Container(
                margin: EdgeInsets.all(6),
                child: Row(children: [
                  InkWell(
                    onTap: () {
                        setState(() {
                          gender = 'General';
                        });
                      },
                    child: Container(
                      padding:
                        const  EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            width: 3,
                            color: gender == 'General'
                                ? CustomColors.AppColor1
                                : Colors.grey.shade200),
                      ),
                      child: Text(
                        'General',
                        style: GoogleFonts.ptSerif(),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        gender = 'Male';
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 12, right: 12, top: 4, bottom: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            width: 3,
                            color: gender == 'Male'
                                ? CustomColors.AppColor1
                                : Colors.grey.shade200),
                      ),
                      child: Text(
                        'Male',
                        style: GoogleFonts.ptSerif(),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        gender = 'Female';
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 12, right: 12, top: 4, bottom: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            width: 3,
                            color: gender == 'Female'
                                ? CustomColors.AppColor1
                                : Colors.grey.shade200),
                      ),
                      child: Text(
                        'Female',
                        style: GoogleFonts.ptSerif(),
                      ),
                    ),
                  ),
                ]),
              )
            ]),
          ),
          Container(
            padding: EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '*',
                  style: GoogleFonts.ptSerif(color: Colors.red, fontSize: 20),
                ),
                Text(
                  'Content Rating',
                  style: GoogleFonts.ptSerif(),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.all(6),
                    child: Row(children: [
                      InkWell(
                         onTap: () {
                            setState(() {
                              content = '4+';
                            });
                          },
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 12, right: 12, top: 4, bottom: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                width: 3,
                                color: content == '4+'
                                    ? CustomColors.AppColor1
                                    : Colors.grey.shade200),
                          ),
                          child: Text(
                            '4+',
                            style: GoogleFonts.ptSerif(),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () {
                              setState(() {
                                content = '12+';
                              });
                            },
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 12, right: 12, top: 4, bottom: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                width: 3,
                                color: content == '12+'
                                    ? CustomColors.AppColor1
                                    : Colors.grey.shade200),
                          ),
                          child: InkWell(
                            
                            child: Text(
                              '12+',
                              style: GoogleFonts.ptSerif(),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () {
                              setState(() {
                                content = '16+';
                              });
                            },
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 12, right: 12, top: 4, bottom: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                width: 3,
                                color: content == '16+'
                                    ? CustomColors.AppColor1
                                    : Colors.grey.shade200),
                          ),
                          child: InkWell(
                            
                            child: Text(
                              '16+',
                              style: GoogleFonts.ptSerif(),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      InkWell(
                          onTap: () {
                              setState(() {
                                content = '18+';
                              });
                            },
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 12, right: 12, top: 4, bottom: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                width: 3,
                                color: content == '18+'
                                    ? CustomColors.AppColor1
                                    : Colors.grey.shade200),
                          ),
                          child: InkWell(
                          
                            child: Text(
                              '18+',
                              style: GoogleFonts.ptSerif(),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  )
                ]),
          ),
          SizedBox(
            height: 20,
          ),
          CustomButton(
              color: null,
              text_color: null,
              text: 'Next',
              onTap: () {
                final auth = FirebaseAuth.instance;
                if (auth.currentUser != null) {
                  if (content != null &&
                      cover != null &&
                      book_title.text.isNotEmpty &&
                      content != null &&
                      selectedValue!.isNotEmpty) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UploadBook2(
                                  content: content,
                                  cover: cover,
                                  book_title: book_title.text,
                                  audiance: gender,
                                  language: selectedValue,
                                )));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: CustomColors.AppColor1,
                        content: Text('All Fields are required')));
                  }
                } else {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => WelcomeScreen()));
                }
              }),
        ],
      ),
    );
  }
}
