import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laylah/components/custom_button.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:multiselect/multiselect.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../provider/set_state_class.dart';
import '../utils/colors.dart';

class UploadBook2 extends StatefulWidget {
  var cover;
  var book_title;
  var language;
  var audiance;
  var content;

  UploadBook2(
      {super.key,
      required this.audiance,
      required this.book_title,
      required this.content,
      required this.cover,
      required this.language});

  @override
  State<UploadBook2> createState() => _UploadBook2State();
}

class _UploadBook2State extends State<UploadBook2> {
  final List<String> Noval = [
    'Orignal',
    'Translation',
    'Fanfiction',
  ];


  final List<String> Status = [
    'OnGoing',
    'Complete',
  ];



  final List<String> Genre = [
    'Romance',
    'Fantacny',
    'CEO',
    'Vampire',
    'Reginal',
    '18+',
    'YA',
    'Mafia',
    'Age Gap',
    'Royal',
  ];



  final List<String> Tags = [
    'Love & Marriage',
    'love trangle',
    'Advanture',
    'Action',
    'Story',
    'Science',
    'Fiction',
    'Rich',
    'Idol',
    'designer',
  ];

  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController description = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
final provider= Provider.of<SetStateClass>(context, listen: false);
provider.dispose();
    super.dispose();
  }

  var _image;
  bool image_loading = false;
  bool loading = false;
  UploadImage() async {
    // var fileName = widget.cover.name;
    //     final reader = FileReader();
    //     var read = reader.readAsDataUrl(file);
    //Upload to Firebase
    var uuid = Uuid();
    final _imageStorage = FirebaseStorage.instance;
    var snapshot = await _imageStorage
        .ref()
        .child('images/${uuid.v1()}')
        .putFile(widget.cover);
    var url = await snapshot.ref.getDownloadURL();

    if (await url != null) {
      setState(() {
        _image = url;
        image_loading = false;
      });
    }
  }

  @override
  void initState() {
    UploadImage();
    // TODO: implement initState
    super.initState();
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
        shrinkWrap: true,
        children: [
          SizedBox(
            height: 20,
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
                        'Noval Type',
                        style: GoogleFonts.ptSerif(
                          fontSize: 14,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ],
                  ),
                ),
             
             Consumer<SetStateClass>(
               builder: (context, myType, child) {
                 return Container(
                  width: 120,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: Text(
                        'Select Type ',
                        style: GoogleFonts.ptSerif(
                          fontSize: 14,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      items: Noval.map((item) => DropdownMenuItem(
                            value: item,
                            child: Text(
                              item,
                              style: GoogleFonts.ptSerif(
                                fontSize: 14,
                              ),
                            ),
                          )).toList(),
                      value: myType.selectNoval,
                      onChanged: (value) {
       myType.setNoval(value as String);
                        
                     
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
                );
               },
             ),
                
              
              ],
            ),
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
                        'Genre',
                        style: GoogleFonts.ptSerif(
                          fontSize: 14,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ],
                  ),
                ),
               Consumer<SetStateClass>(
                 builder: (context, myType, child) {
                   return  Container(
                  width: 120,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: Text(
                        ' Select Genre',
                        style: GoogleFonts.ptSerif(
                          fontSize: 14,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      items: Genre.map((item) => DropdownMenuItem(
                            value: item,
                            child: Text(
                              item,
                              style: GoogleFonts.ptSerif(
                                fontSize: 14,
                              ),
                            ),
                          )).toList(),
                      value: myType.SelectGenre,
                      onChanged: (value) {
                      
                        myType.setGenre(value as String);
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
                );
                 },
               )
              
              ],
            ),
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
                        'Status',
                        style: GoogleFonts.ptSerif(
                          fontSize: 14,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ],
                  ),
                ),

                Consumer<SetStateClass>(
                  builder: (context, myType, child) {
                    return Container(
                  width: 120,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: Text(
                        ' Select Status',
                        style: GoogleFonts.ptSerif(
                          fontSize: 14,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      items: Status.map((item) => DropdownMenuItem(
                            value: item,
                            child: Text(
                              item,
                              style: GoogleFonts.ptSerif(
                                fontSize: 14,
                              ),
                            ),
                          )).toList(),
                      value:myType.  SelectStatus,
                      onChanged: (value) {
                       
                        myType.setStatus(value as String);
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
                );
                  },
                )
                
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(12),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.grey.shade200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Text(
                        '*',
                        style: GoogleFonts.ptSerif(
                            color: Colors.red, fontSize: 20),
                      ),
                      Text(
                        'Tags',
                        style: GoogleFonts.ptSerif(
                          fontSize: 14,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ],
                  ),
                ),
     Consumer<SetStateClass>(
       builder: (context, myType, child) {
         return Container(
  width: MediaQuery.of(context).size.width,
  child:  MultiSelectDialogField(
              items: Tags.map((tag) => MultiSelectItem(tag, tag)).toList(),
              title: Text("Select Tags"),
              selectedColor: Colors.blue,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.all(Radius.circular(5)),
                border: Border.all(
                  color: Colors.blue,
                  width: 1,
                ),
              ),
              buttonIcon: Icon(
                Icons.arrow_drop_down,
                color: Colors.blue,
              ),
              buttonText: Text(
                "Select Tags",
                style: TextStyle(
                  color: Colors.blue[900],
                  fontSize: 16,
                ),
              ),
              onConfirm: (List results) {
                
              
                  myType.selectedTags = results;
              
              },
              chipDisplay: MultiSelectChipDisplay(
                onTap: (value) {
                 
                     myType.selectedTags.remove(value);
                
                },
              ),
            ),
         


                  // DropdownButtonHideUnderline(
                  //   child: DropdownButton2<String>(
                  //     isExpanded: true,
                  //     hint: Text(
                  //       ' Select Tags',
                  //       style: GoogleFonts.ptSerif(
                  //         fontSize: 14,
                  //         color: Theme.of(context).hintColor,
                  //       ),
                  //     ),
                  //     items:

                  //      Tags.map((item) => DropdownMenuItem(
                  //           value: item,
                  //           child: Text(
                  //             item,
                  //             style: GoogleFonts.ptSerif(
                  //               fontSize: 14,
                  //             ),
                  //           ),
                  //         )).toList(),
                  //     value: selectTags,
                  //     onChanged: (value) {
                  //       setState(() {
                  //         selectTags = value as String;
                  //       });
                  //     },
                  //     buttonStyleData: const ButtonStyleData(
                  //       height: 40,
                  //       width: 200,
                  //     ),
                  //     dropdownStyleData: const DropdownStyleData(
                  //       maxHeight: 200,
                  //     ),
                  //     menuItemStyleData: const MenuItemStyleData(
                  //       height: 40,
                  //     ),
                  //     dropdownSearchData: DropdownSearchData(
                  //       searchController: textEditingController,
                  //       searchInnerWidgetHeight: 50,
                  //       searchInnerWidget: Container(
                  //         height: 50,
                  //         padding: const EdgeInsets.only(
                  //           top: 8,
                  //           bottom: 4,
                  //           right: 8,
                  //           left: 8,
                  //         ),
                  //         child: TextFormField(
                  //           expands: true,
                  //           maxLines: null,
                  //           controller: textEditingController,
                  //           decoration: InputDecoration(
                  //             isDense: true,
                  //             contentPadding: const EdgeInsets.symmetric(
                  //               horizontal: 10,
                  //               vertical: 8,
                  //             ),
                  //             hintText: 'Search for an item...',
                  //             hintStyle: const TextStyle(fontSize: 12),
                  //             border: OutlineInputBorder(
                  //               borderRadius: BorderRadius.circular(8),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //       searchMatchFn: (item, searchValue) {
                  //         return (item.value.toString().contains(searchValue));
                  //       },
                  //     ),
                  //     //This to clear the search value when you close the menu
                  //     onMenuStateChange: (isOpen) {
                  //       if (!isOpen) {
                  //         textEditingController.clear();
                  //       }
                  //     },
                  //   ),
                  // ),
                )
         ;
       },
     )           
  
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
                  'Synopsis',
                  style: GoogleFonts.ptSerif(),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(12),
            child: Text(
              'Please write description for your with 20 to 500 worlds',
              style: GoogleFonts.ptSerif(color: Colors.grey.shade600),
            ),
          ),
          Container(
            margin: EdgeInsets.all(12),
            child: TextFormField(
              maxLines: 8,
              maxLength: 500,
              controller: description,
              decoration: InputDecoration(
                isDense: true,
                filled: true,

                fillColor: Colors.grey.shade200,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                // hintText: 'Leave feed back here....',
                hintStyle: const TextStyle(fontSize: 12),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 120,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(12)),
                child: OutlinedButton(
                    style: ButtonStyle(),
                    child: Text('Back'),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ),
Consumer<SetStateClass>(
  builder: (context, myType, child) {
    return myType.submitLoad == false
                  ? Container(
                      width: 120,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      child: CustomButton(
                        color: null,
                        text_color: null,
                        onTap: () async {

                          final provider = Provider.of<SetStateClass>(context, listen: false);

                          var storage =const FlutterSecureStorage();
          
                          var user_id = await storage.read(key: 'uid');
                          var date = DateTime.now();
                          final auth = FirebaseAuth.instance;
                          if (widget.book_title != null &&
                              // writer.text.isNotEmpty &&
                              widget.audiance != null &&
                              widget.content != null &&
                              widget.language != null &&
                             provider. selectNoval != null &&
                           provider.   SelectGenre != null &&
                            provider.  selectedTags.isNotEmpty &&
                              _image != null &&
                              description.text.isNotEmpty) {
                                provider.setSubmitLoad(true);
                          
                            var book_id =const Uuid().v1();
                            FirebaseFirestore.instance
                                .collection('books')
                                .doc(book_id)
                                .set({
                              'id': book_id,
                              'view': 0,
                              'likes': 0,
                              'words': 0,
                              'book_title': widget.book_title,
                              'cover': _image,
                              'book_writer': auth.currentUser!.displayName,
                              'target_audiance': widget.audiance,
                              'content_rating': widget.content,
                              'noval_type':provider. selectNoval,
                              'language': widget.language,
                              'genre':provider. SelectGenre,
                              'tags':   provider.selectedTags,
                              'update_date':
                                  '${date.year}/${date.month}/${date.day} ${date.hour}:${date.minute}',
                              'descriptions': description.text,
                              'writer_id': user_id,
                              'comments': 0,
                              'status':provider. SelectStatus,
                              'libraries': 0,
                              'remarks':
                                  'Apply for contract and monetize your book.',
                              'section': 'undefind',
                              'applied_for_contract':false,
                            }).then((value) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text('Book Added Successfully'),
                                backgroundColor: Colors.green,
                              ));
                              
                            Navigator.pop(context);
                            Navigator.pop(context);
                            });
                            provider.setSubmitLoad(false);
                           
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                              content: Text('All Fields Are Required'),
                              backgroundColor: Colors.green,
                            ));
                          }
                        },
                        text: "Submit",
                      ),
                    )
                  :const Center(
                      child: CircularProgressIndicator(),
                    );
  },
)

              
            ],
          )
        ],
      ),
    );
  }
}
