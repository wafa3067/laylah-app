import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:laylah/admin/AdminSignup.dart';
import 'package:laylah/components/custom_button.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../components/input_text.dart';
import '../screens/main_page.dart';
import '../utils/colors.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({Key? key}) : super(key: key);

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var storage = FlutterSecureStorage();
  final auth = FirebaseAuth.instance;

  bool valdicateds = false;
  bool login = false;

  Future<void> LoginWithEmail() async {
    if (nameController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      if (nameController.text.contains('@email')) {
        try {
          final auth = await FirebaseAuth.instance;
          auth
              .signInWithEmailAndPassword(
                  email: nameController.text, password: passwordController.text)
              .then((value) async => {
                    await storage.write(
                        key: 'uid', value: "${value.user?.uid}"),
                    await storage.write(
                        key: 'email', value: "${value.user?.email}"),
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>  MainPage())),
                    setState(() {
                      login = true;
                    }),
                  });
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('$e')));
            setState(() {
              login = false;
            });
          } else if (e.code == 'wrong-password') {
            setState(() {
              login = false;
            });
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: CustomColors.AppColor1,
            content: Text('Enter Email & Password')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: CustomColors.AppColor1,
          content: Text('Enter Valid Email')));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: login == false
            ? Container(
                decoration: BoxDecoration(
                    color: Colors.amber,
                    gradient: LinearGradient(colors: [
                      CustomColors.lightyellow,
                      CustomColors.dimgrey
                    ]),
                    image: DecorationImage(image: AssetImage('logo.jpeg'))),
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height,
                // margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/5),
                child: Container(
                  alignment: Alignment.center,
                  width: 500,
                  height: MediaQuery.of(context).size.height / 2,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Padding(
                      padding: const EdgeInsets.all(1),
                      child: ListView(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(10),
                            width: 200,
                            child: Center(
                              child: InputText(
                                width: MediaQuery.of(context).size.width,
                                require: true,
                                placeholder: 'Enter Email Address',
                                text: nameController,
                                name: 'Email',
                              ),
                            ),
                          ),
                          Container(
                              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child: InputText(
                                width: MediaQuery.of(context).size.width,
                                require: true,
                                secure: true,
                                placeholder: 'Enter Password ',
                                text: passwordController,
                                name: 'Password',
                              )),
                          Container(
                              height: 50,
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: CustomButton(
                                text: 'Login',
                                text_color: null,
                                color: null,
                                onTap: () {
                                  LoginWithEmail();
                                },
                              )),
                          Row(
                            children: <Widget>[
                              const Text('Register Now ?'),
                              TextButton(
                                child: Text(
                                  'Sign Up ',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: CustomColors.AppColor1),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AdminSignUp()),
                                  );
                                },
                              )
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                        ],
                      )),
                ))
            : Container(
                child: Lottie.asset(
                  'lottie/load.json',
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  fit: BoxFit.cover,
                ),
              ));
  }
}
