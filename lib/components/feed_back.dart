import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laylah/provider/set_state_class.dart';
import 'package:laylah/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../provider/AppFunctions.dart';

class FeedBack extends StatefulWidget {
  const FeedBack({super.key});

  @override
  State<FeedBack> createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  final List<String> items = [

  ];

  String? selectedValue;
  final TextEditingController textEditingController = TextEditingController();

  GetUser(){
    FirebaseFirestore.instance.collection('questions').get().then((value) {
      for(var q in value.docs){
        setState(() {
          items.add(q.data()['question_type']);
        });
      }
    });
  }


  @override
  void initState() {
   GetUser();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider=Provider.of<AppFunctions>(context,listen: false);
    final states=Provider.of<SetStateClass>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
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
              Container(child: Text('FeedBack')),
              Container(
                child: Row(children: [
                  Container(
                    child: Icon(Feather.tool),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(child: Text('Q&A')),
                ]),
              )
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
            child: Text(
              'Join the Group to Meet Laylah',
              style: GoogleFonts.ptSerif(),
            ),
          ),
          Container(
            margin: EdgeInsets.all(12),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.grey.shade200),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                isExpanded: true,
                hint: Text(
                  'Choose the Question Type',
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
          Container(
            margin: EdgeInsets.all(12),
            child: TextFormField(
              maxLines: 10,
              controller: textEditingController,
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: Colors.grey.shade200,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                hintText: 'Leave feed back here....',
                hintStyle: const TextStyle(fontSize: 12),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
              ),
            ),
          ),

         Consumer<AppFunctions>(builder: (BuildContext context, value, Widget? child) {

           return  value.cover==null ? InkWell(
onTap: (){
  value.PickImage();
},
             child: Container(
               margin: EdgeInsets.all(12),
               decoration: BoxDecoration(
                   color: Colors.grey.shade200,
                   borderRadius: BorderRadius.circular(12)),
               height: 150,
               width: MediaQuery.of(context).size.width,
               child: Icon(Icons.add),
             ),
           ):Container(
             height: 150,
             child: Image.file(File("${value.cover!.path}")),);
         },),

          Container(
            margin: EdgeInsets.all(12),
            child: Text(
              'Upload  a screenshot to help us better identify your issue',
              style: GoogleFonts.ptSerif(color: Colors.grey.shade600),
            ),
          ),

      Consumer<SetStateClass>(builder: (BuildContext context, value, Widget? child) {
      return   value.loadImage==false ?   Container(
          margin: EdgeInsets.all(12),
          width: 200,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                  MaterialStatePropertyAll(CustomColors.AppColor1)),
              child: Text('Submit'),
              onPressed: () async{
                var id=Uuid().v1();

                var storage=FlutterSecureStorage();
                var user=await storage.read(key: 'uid');
                if(provider.cover!=null){
                  value.SetLoadImage(false);
                  var image;
                  var uuid = Uuid();
                  final _imageStorage = FirebaseStorage.instance;
                  var snapshot = await _imageStorage
                      .ref()
                      .child('images/${uuid.v1()}')
                      .putFile(File("${provider.cover!.path}"));
                  var url = await snapshot.ref.getDownloadURL();

                  if (await url != null) {
                    value.SetLoadImage(true);
                    FirebaseFirestore.instance.collection('feed_back').doc(id).set({
                      'id':id,
                      'question_type':selectedValue,
                      'feed':textEditingController.text,
                      'image':url,
                      'user':user,
                    }).then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Feed Back Added')));
                    });

                  }

                }

              }),
        ):Container(child: Center(child: CircularProgressIndicator(),),);
      },)

        ],
      ),
    );
  }
}
