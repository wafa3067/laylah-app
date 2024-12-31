import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/background_image.dart';
import 'package:laylah/components/custom_button.dart';
import 'package:laylah/components/input_text.dart';
import 'package:laylah/utils/colors.dart';
import 'package:lottie/lottie.dart';

import 'AdminSign.dart';

class AdminSignUp extends StatefulWidget {
  const AdminSignUp({Key? key}) : super(key: key);

  @override
  State<AdminSignUp> createState() => _AdminSignUpState();
}

class _AdminSignUpState extends State<AdminSignUp> {
  TextEditingController nameController = TextEditingController();
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool valdicateds = false;
  bool login = false;
  final auth = FirebaseAuth.instance;

  Future<void> SignUpWithEmail() async {
    if (userController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      if (userController.text.contains('@email')) {
        try {
          await auth
              .createUserWithEmailAndPassword(
                email: userController.text,
                password: passwordController.text,
              )
              .timeout(Duration(minutes: 2))
              .then((value) => {
                    setState(() {
                      login = true;
                    }),
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AdminLogin()),
                    ),
                  });
        } on FirebaseAuthException catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: CustomColors.AppColor1, content: Text('$e')));
          if (e.code == 'weak-password') {
            setState(() {
              login = false;
            });
          } else if (e.code == 'email-already-in-use') {
            setState(() {
              login = false;
            });
          } else {
            setState(() {
              login = false;
            });
          }
        } catch (e) {
          setState(() {
            login = false;
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: CustomColors.AppColor1,
            content: Text(' Enter Valid Email example@email.com')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: CustomColors.AppColor1,
          content: Text(' Email & Password Required Fields')));
    }
  }

  @override
  void initState() {
    // SignUpWithEmail();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: login == false
            ? Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      CustomColors.lightyellow,
                      CustomColors.dimgrey
                    ]),
                    color: CustomColors.lightyellow,
                    image: DecorationImage(image: AssetImage('logo.jpeg'))),
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height,
                // margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/5),
                child: Container(
                  alignment: Alignment.center,
                  width: 500,
                  height: MediaQuery.of(context).size.height / 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      CustomColors.lightyellow,
                      CustomColors.dimgrey
                    ]),
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
                              text: userController,
                              name: 'Email',
                            )),
                          ),
                          Container(
                              padding:
                                  const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child: InputText(
                                width: MediaQuery.of(context).size.width,
                                require: true,
                                placeholder: 'Enter Password',
                                text: passwordController,
                                name: 'password',
                              )),
                          Container(
                            height: 50,
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: CustomButton(
                              text: 'Sign Up',
                              text_color: null,
                              color: null,
                              onTap: () {
                                SignUpWithEmail();
                              },
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              const Text("Have a Account"),
                              TextButton(
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: CustomColors.AppColor1),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AdminLogin()),
                                  );
                                },
                              )
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                          )
                        ],
                      )),
                ))
            : Container(
                child: Lottie.asset(
                  'lottie/load.json',
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  fit: BoxFit.fill,
                ),
              ));
  }
}
