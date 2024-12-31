import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
// import com.facebook.FacebookSdk;
// import com.facebook.appevents.AppEventsLogger;

import '../screens/main_page.dart';

class AppFunctions with ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? gUser;
  var storage = FlutterSecureStorage();

  bool user = false;
  bool get _user => user;
  bool loged_in = false;
  bool get _loged_in => loged_in;

//google login
  GoogleSignInAccount get _gUser => gUser!;
  GoogleLogin(context) async {
    final GoogleUser = await googleSignIn.signIn();
    if (GoogleUser != null) {
      try {
        this.gUser = GoogleUser;
        final GoogleSignInAuthentication? gAuth =
            await this.gUser!.authentication;

        final credential = GoogleAuthProvider.credential(
            accessToken: gAuth!.accessToken, idToken: gAuth.idToken);
        loged_in = true;
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) async {
          await storage.write(key: 'uid', value: value.user!.uid);
          FirebaseFirestore.instance
              .collection('users')
              .doc(value.user!.uid)
              .set({
            'displayName': value.user!.displayName,
            'email': value.user!.email,
            'photoUrl': value.user!.photoURL,
            'uid': value.user!.uid
          });
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MainPage()));
        });
      } catch (e) {}
    }
    notifyListeners();
  }

  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Future<UserCredential> AppleSignIn() async {
  //   // To prevent replay attacks with the credential returned from Apple, we
  //   // include a nonce in the credential request. When signing in with
  //   // Firebase, the nonce in the id token returned by Apple, is expected to
  //   // match the sha256 hash of `rawNonce`.
  //   final rawNonce = generateNonce();
  //   final nonce = sha256ofString(rawNonce);
  //
  //   // Request credential for the currently signed in Apple account.
  //   final appleCredential = await SignInWithApple.getAppleIDCredential(
  //     scopes: [
  //       AppleIDAuthorizationScopes.email,
  //       AppleIDAuthorizationScopes.fullName,
  //     ],
  //     // nonce: nonce,
  //   );
  //
  //
  //
  //   // Sign in the user with Firebase. If the nonce we generated earlier does
  //   // not match the nonce in `appleCredential.identityToken`, sign in will fail.
  //   return await FirebaseAuth.instance.signInWithCredential().then((value)async {
  //     await storage.write(key: 'uid', value: value.user!.uid);
  //     FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(value.user!.uid)
  //         .set({
  //       'displayName': value.user!.displayName,
  //       'email': value.user!.email,
  //       'photoUrl': value.user!.photoURL,
  //       'uid': value.user!.uid
  //     });
  //     return value;
  //   });
  //
  // }

  Future<User?> AppleSignIn(context) async {
    try {
      final result = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: 'com.laylah.app',
          redirectUri:
              Uri.parse('https://laylah-cf6ac.firebaseapp.com/__/auth/handler'),
        ),
      );

      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: result.identityToken,
        accessToken: result.authorizationCode,
      );
      print('oth credntail $oauthCredential');
      final authResult = await FirebaseAuth.instance
          .signInWithCredential(oauthCredential)
          .then((value) async {
        await storage.write(key: 'uid', value: value.user!.uid);

        FirebaseFirestore.instance
            .collection('users')
            .doc(value.user!.uid)
            .set({
          'displayName': value.user!.displayName,
          'email': value.user!.email,
          'photoUrl': value.user!.photoURL,
          'uid': value.user!.uid
        });
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MainPage()));
      });

      final user = authResult.user;
      return user;
    } catch (error) {
      print("errorO  ${error.toString()}");
      return null;
    }
  }

  signInWithFacebook(context) async {
    // Trigger the sign-in flow

    final LoginResult loginResult = await FacebookAuth.instance
        .login(permissions: ['public_profile', 'email']);

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential)
        .then((value) async {
      await storage.write(key: 'uid', value: value.user!.uid);

      FirebaseFirestore.instance.collection('users').doc(value.user!.uid).set({
        'displayName': value.user!.displayName,
        'email': value.user!.email,
        'photoUrl': value.user!.photoURL,
        'uid': value.user!.uid
      });
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainPage()));
      return value;
    });
  }
  // AppleSignIn()async{
  //   final credential = await SignInWithApple.getAppleIDCredential(
  //     scopes: [
  //       AppleIDAuthorizationScopes.email,
  //       AppleIDAuthorizationScopes.fullName,
  //     ],
  //   );
  //
  //
  //   // Sign in the user with Firebase. If the nonce we generated earlier does
  //   // not match the nonce in `appleCredential.identityToken`, sign in will fail.
  //   return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  //   return await FirebaseAuth.instance.signInWithCredential(credential as AuthCredential)
  //       .then((value)async {
  //     await storage.write(key: 'uid', value: value.user!.uid);
  //     FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(value.user!.uid)
  //         .set({
  //       'displayName': value.user!.displayName,
  //       'email': value.user!.email,
  //       'photoUrl': value.user!.photoURL,
  //       'uid': value.user!.uid
  //     });
  //   });
  //   print(credential);
  //
  // }

  String displayName = 'Guest User';
  String get _displayName => displayName;

  //user profile details
  String? profile;
  String get _profile => displayName;
  String? no_photo;
  String get _no_photo => _no_photo;
  profileDetails() {
    final auth = FirebaseAuth.instance.currentUser;
    var first = auth!.email!.split('@');
    displayName = "${auth.displayName != null ? auth.displayName : first[0]}";
    profile = "${auth.photoURL}";
    no_photo = "${auth.email![0]}";

    notifyListeners();
  }

  //google logout
  GoogleLogout() async {
    googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
    await storage.delete(
      key: 'uid',
    );
    notifyListeners();
  }

  String? user_id;
  String? get _user_id => user_id;

  // user id
  GetUserId() async {
    var uid = await storage.read(key: 'uid');
    if (uid != null) {
      user = true;
      user_id = uid;
    }
    notifyListeners();
  }

  // chat user
  int chat_user = 0;
  int get _chat_user => chat_user;
  checkChatUser(int index) {
    chat_user = index;
    notifyListeners();
  }

  // pick images

  XFile? cover;
  XFile get _cover => cover!;
  PickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      cover = image;
    }
    notifyListeners();
  }

  // update user functions
//update display name
  Updateuser(name) {
    final auth = FirebaseAuth.instance;
    auth.currentUser!
        .updateDisplayName(name.text)
        .whenComplete(() => print('complete'));
  }

// update photo
  updateProfile(name) {
    final auth = FirebaseAuth.instance;
    auth.currentUser!
        .updatePhotoURL(name.text)
        .whenComplete(() => print('complete'));
  }

//hover effect
  bool hover = false;
  bool get _hover => hover;
  SetHover(bool value) {
    hover = value;
    notifyListeners();
  }

// check published books
  bool publish = false;
  getPublishBooks(id) async {
    await FirebaseFirestore.instance.collection('books').get().then((value) {
      for (var result in value.docs) {
        if (id == result.data()['writer_id']) {
          if (result.data()['section'] != 'undefind') {
            publish = true;
          }
        }
      }
    });
    notifyListeners();
  }

  bool comment_user = false;
  bool empty = false;

  bool get _comment_user => comment_user;
  bool get _empty => empty;

  CommentsData(book_id, chapter_id, comment_id) async {
    var user_id = await storage.read(key: 'uid');
    FirebaseFirestore.instance
        .collection('books')
        .doc(book_id)
        .collection('chapter')
        .doc(chapter_id)
        .collection('comments')
        .doc(comment_id)
        .collection('likes')
        .get()
        .then((value) {
      bool foundUserLike = false;

      if (value.docs.isEmpty) {
        empty = true;
      } else {
        for (var u in value.docs) {
          if (u.data().isNotEmpty && u.data()['user_id'] == user_id) {
            foundUserLike = true;
            break; // Exit the loop since we found a match
          }
        }

        comment_user = foundUserLike;
        empty = !foundUserLike; // If user liked, not empty; if not, empty
      }

      notifyListeners();
    });
  }

  // CommentsData(book_id, chapter_id, comment_id) async {
  //   var user_id = await storage.read(key: 'uid');
  //   FirebaseFirestore.instance
  //       .collection('books')
  //       .doc(book_id)
  //       .collection('chapter')
  //       .doc(chapter_id)
  //       .collection('comments')
  //       .doc(comment_id)
  //       .collection('likes')
  //       .get()
  //       .then((value) {
  //     if (value.docs.isEmpty) {
  //       empty = true;
  //     }
  //     if (value.docs.isNotEmpty) {
  //       for (var u in value.docs) {
  //         if (u.data().isNotEmpty) {
  //           if (u.data()['user_id'] == user_id) {
  //             comment_user = true;
  //           }
  //           if (u.data()['user_id'] != user_id) {
  //             comment_user = false;
  //           }
  //         }
  //       }
  //     }
  //     notifyListeners();
  //   });
  //   // notifyListeners();
  // }

  int check_in = 0;
  int watch = 0;
  int topUp = 0;
  int read = 0;
  int comment = 0;
  int new_user = 0;

  int check_in_length = 0;
  int watch_length = 0;
  int topUp_length = 0;
  int read_length = 0;
  int comment_length = 0;

  int get _check_in => check_in;
  int get _watch => watch;
  int get _topUp => topUp;
  int get _read => read;
  int get _comment => comment;
  int get _new_user => new_user;

  int get _check_in_length => check_in_length;
  int get _watch_length => watch_length;
  int get _topUp_length => topUp_length;
  int get _read_length => read_length;
  int get _commen_lengtht => comment_length;

  GetTotal() {
    GetUserId();
    print('user func calls with ids ${user_id}');
    FirebaseFirestore.instance
        .collection('users')
        .doc(user_id)
        .collection('check_in')
        .get()
        .then((value) {
      check_in = 15 * value.docs.length;
      check_in_length = value.docs.length;
      notifyListeners();
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(user_id)
        .collection('watch')
        .get()
        .then((value) {
      watch = 3 * value.docs.length;
      watch_length = value.docs.length;
      notifyListeners();
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(user_id)
        .collection('topup')
        .get()
        .then((value) {
      topUp = 20 * value.docs.length;
      topUp_length = value.docs.length;
      notifyListeners();
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(user_id)
        .collection('read')
        .get()
        .then((value) {
      for (var d in value.docs) {
        if (d.data()['minutes'] == 5) {
          read = 5;
        }
        if (d.data()['minutes'] > 5 && d.data()['minutes'] < 10) {
          read = 5;
        }
        if (d.data()['minutes'] >= 10 && d.data()['minutes'] < 20) {
          read = 10;
        }
        if (d.data()['minutes'] >= 20 && d.data()['minutes'] < 40) {
          read = 15;
        }
        if (d.data()['minutes'] >= 40 && d.data()['minutes'] < 80) {
          read = 20;
        }
        if (d.data()['minutes'] >= 80) {
          read = 25;
        }
      }
      read_length = value.docs.length;
      notifyListeners();
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(user_id)
        .collection('comment')
        .get()
        .then((value) {
      comment = 1 * value.docs.length;
      comment_length = value.docs.length;
      notifyListeners();
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(user_id)
        .collection('new_user')
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        new_user = 0;
      } else {
        new_user = 10;
      }

      notifyListeners();
    });
  }



bool appled=false;

  checkContractApplied()async{
      var Storage = FlutterSecureStorage();

        var user_id = await Storage.read(key: 'uid');

    FirebaseFirestore.instance
                              .collection('contract-requests').doc(user_id).get().then((value) {});
  }
}
