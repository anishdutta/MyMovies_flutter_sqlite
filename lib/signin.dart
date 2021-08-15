import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_movies/constants.dart';
import 'signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Mymovies.dart';





class Signin extends StatefulWidget {
  static String id = 'signin';
  @override
  _SigninState createState() => new _SigninState();
}

class _SigninState extends State<Signin> {
  String email = '';
  String password = '';
  bool isselect = true;
  int key = 0;
  bool showSpinner = false;

  final _auth = FirebaseAuth.instance;

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
                height: 55,
              ),
              Container(
                child: Stack(
                  children: <Widget>[
                    Container(

                      padding: EdgeInsets.fromLTRB(0.0, 60.0, 0.0, 0.0),
                      child: Image.network('https://c.tenor.com/n3WbodS_C2YAAAAi/appventure-myappventure.gif',
                        width: 100,),

                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(16.0, 175.0, 0.0, 0.0),
                      child: Text('My Movies',
                          style: TextStyle(
                              fontSize: 50.0, fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(220.0, 175.0, 0.0, 0.0),
                      child: Text('.',
                          style: TextStyle(
                              fontSize: 50.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.green)),
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
                                borderSide: BorderSide(color: Colors.green))),
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
                      SizedBox(height: 5.0),
                      Container(
                        alignment: Alignment(1.0, 0.0),
                        padding: EdgeInsets.only(top: 15.0, left: 20.0),
                        child: InkWell(
                          child: Text(
                            'Forgot Password',
                            style: TextStyle(
                                color: kSecondaryColor,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                                decoration: TextDecoration.underline),
                          ),
                        ),
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
                                final newUser = await _auth.signInWithEmailAndPassword(
                                    email: email, password: password);

                                if (newUser != null) {
                                  Fluttertoast.showToast(
                                      msg: "Welcome",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: kSecondaryColor,
                                      textColor: kTextColor,
                                      fontSize: 16.0
                                  ).then((value) => {
                                  Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Mymovies()),
                                  )
                                  });
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
                                'LOGIN',
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
                    'New to My Movie ?',
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
                        MaterialPageRoute(builder: (context) => Signup()),
                      );
                    },
                    child: Text(
                      'Register',
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