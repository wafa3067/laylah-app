import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:laylah/provider/AppFunctions.dart';
import 'package:provider/provider.dart';
import 'package:laylah/provider/set_state_class.dart';
import 'package:laylah/screens/home_screen.dart';
import 'package:laylah/screens/library_screen.dart';
import 'package:laylah/screens/profile_screen.dart';
import 'package:laylah/screens/write_book_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../components/bottom_navigator.dart';
import '../utils/colors.dart';

class MainPage extends StatefulWidget {
  var earn;
   MainPage({super.key,this.earn});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List Apps = [
    HomeScreen(),
    LibraryScreen(),
    WriteBookScreen(),
    ProfileScreen()
  ];
  late StreamSubscription<ConnectivityResult> subscription;

// get user chats
  getChat(){
    final provider=Provider.of<AppFunctions>(context,listen: false);
    FirebaseFirestore.instance.collection('chat').get().then((value) {
      for(var user in value.docs){
        if(user.data()['user_id']==provider.user_id){
          provider.checkChatUser(1);
        }
      }
    });
  }

  // write book id
  var storage = FlutterSecureStorage();
  var writer_id;
  GetUserId() async {
    var user_id = await storage.read(key: 'uid');
    if (user_id != null) {
      setState(() {
        writer_id = user_id;
      });
      await CurrentUserBooks();
    }
  }

  bool current_user_books = false;
  CurrentUserBooks() {
    final provider = Provider.of<SetStateClass>(context, listen: false);
    FirebaseFirestore.instance.collection('books').get().then((value) {
      value.docs.forEach((element) {

        if (writer_id == element.data()['writer_id']) {
          provider.setCurrentUserBooks(true);
        }
      });
    });
  }

  @override
  initState() {
    final provider=Provider.of<AppFunctions>(context,listen: false);
    provider.GetUserId();
    getChat();
    GetUserId();
    provider.GetTotal();
    provider.getPublishBooks(provider.user_id);
    super.initState();
  }

// Be sure to cancel subscription after you are done
  @override
  dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  // StreamSubscription<ConnectivityResult>? subscription;

final provider = Provider.of<SetStateClass>(context, listen: false);
// subscription = Connectivity()
//     .onConnectivityChanged
//     .listen((ConnectivityResult result) {
//   if (result == ConnectivityResult.none) {
//     provider.setConnection(false);
//   } else if (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi) {
//     provider.setConnection(true);
//   }
// } as void Function(List<ConnectivityResult> event)?) as StreamSubscription<ConnectivityResult>?;
 StreamSubscription<List<ConnectivityResult>> subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
   
   print("result is ${result}");
    if (result.contains(ConnectivityResult.none)) {
    provider.setConnection(false);
  } else if (result.contains(ConnectivityResult.mobile) || result.contains(ConnectivityResult.wifi)) {
    provider.setConnection(true);
    print("checked");
  }
  });
    return Scaffold(
      backgroundColor: CustomColors.white,
      body: Consumer<SetStateClass>(
        builder: (context, value, child) {
          return Apps.elementAt(value.current_index);
        },
      ),
      bottomNavigationBar: BottomNavigator(),
    );
  }
}
