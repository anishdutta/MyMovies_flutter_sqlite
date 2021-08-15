import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_movies/constants.dart';
import 'package:my_movies/signin.dart';
import 'signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Mymovies.dart';





class Signup extends StatefulWidget {
  static String id = 'signin';
  @override
  _SignupState createState() => new _SignupState();
}

class _SignupState extends State<Signup> {
  String email = '';
  String password = '';
  bool isselect = true;
  int key = 0;
  bool showSpinner = false;

  final _auth = FirebaseAuth.instance;
  @override
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: kBackgroundColor,
      resizeToAvoidBottomInset: false,
      body: Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          SizedBox(
            height: 50,
          ),
          Container(
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: 20,
                  top: 0,
                  child: Container(

                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    child: Image.network('https://c.tenor.com/xZr-Qp1IrggAAAAi/playmobil-movie.gif',
                      width: 100,),

                  ),
                ),

                Container(
                  padding: EdgeInsets.fromLTRB(16.0, 175.0, 0.0, 0.0),
                  child: Text('Sign Up now!',
                      style: TextStyle(
                          fontSize: 30.0, fontWeight: FontWeight.bold)),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(220.0, 175.0, 0.0, 0.0),
                  child: Text('.',
                      style: TextStyle(
                          fontSize: 50.0,
                          fontWeight: FontWeight.bold,
                          color: kSecondaryColor)),
                )
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
              child: Column(
                children: <Widget>[
                  TextField(

                    decoration: InputDecoration(
                        labelText: 'EMAIL',
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: kSecondaryColor))),
                    onChanged: (value){
                      email = value;
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    decoration: InputDecoration(
                        labelText: 'PASSWORD',
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: kSecondaryColor))),
                    obscureText: true,
                    onChanged: (value){
                      password = value;
                    },
                  ),

                  SizedBox(height: 40.0),
                  Container(
                    height: 40.0,
                    child: Material(
                      borderRadius: BorderRadius.circular(20.0),
                      shadowColor: kSecondaryColor,
                      color: kSecondaryColor,
                      elevation: 7.0,
                      child: GestureDetector(
                        onTap: () async{

                          setState(() {
                            showSpinner = true;
                          });

                          try {
                            UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                email: email,
                                password: password
                            );
                            Fluttertoast.showToast(
                                msg: "Registration successful Please Login now!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: kSecondaryColor,
                                textColor: kTextColor,
                                fontSize: 16.0
                            ).then((value) => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Signin()),
                              )
                            });
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              Fluttertoast.showToast(
                                  msg: "The password provided is too weak.",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: kSecondaryColor,
                                  textColor: kTextColor,
                                  fontSize: 16.0
                              );
                              print('The password provided is too weak.');
                            } else if (e.code == 'email-already-in-use') {
                              Fluttertoast.showToast(
                                  msg: "The account already exists for that email.",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: kSecondaryColor,
                                  textColor: kTextColor,
                                  fontSize: 16.0
                              );
                              print('The account already exists for that email.');
                            }
                          } catch (e) {
                            Fluttertoast.showToast(
                                msg: "$e",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: kSecondaryColor,
                                textColor: kTextColor,
                                fontSize: 16.0
                            );
                            print(e);
                          }




                        },
                        child: Center(
                          child: Text(
                            'Register',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),

                ],
              )),
          SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Already a member ?',
                style: TextStyle(fontFamily: 'Montserrat'),
              ),
              SizedBox(width: 5.0),
              InkWell(
                onTap: () {
                  // Navigator.push(
                  //     context,
                  //     PageTransition(
                  //       type: PageTransitionType.fade,
                  //       child: SignupPage(),
                  //     ));
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Signin()),
                  );

                },
                child: Text(
                  'Login',
                  style: TextStyle(
                      color: kSecondaryColor,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}