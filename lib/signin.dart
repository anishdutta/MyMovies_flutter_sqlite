import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_movies/constants.dart';
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

  GoogleSignInAccount? _currentUser;

  var _auth = FirebaseAuth.instance;

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }


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
          mainAxisAlignment: MainAxisAlignment.spaceAround,

            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              Center(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 25.0, 0.0),
                        child: Image.network('https://c.tenor.com/n3WbodS_C2YAAAAi/appventure-myappventure.gif',
                          width: 150),

                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                        child: Text('My_Movies',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: kTextLightColor,
                                fontSize: 40.0, fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        // padding: EdgeInsets.fromLTRB(220.0, 175.0, 0.0, 0.0),
                        child: Text('Login now to add your favorite movie!',
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: kSecondaryColor)),
                      )
                    ],
                  ),
                ),
              ),
              Center(
                child: Container(

                  width: 300,
                  child: Column(
                    children: [
                      MaterialButton(
                        onPressed: () async {
                          signInWithGoogle().then((value) => {
                            Navigator.of(context).pushNamedAndRemoveUntil(Mymovies.id, (Route<dynamic> route) => false)
                          });
                        },
                        height: 60,

                        color: kSecondaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13)),
                        elevation: 10,
                        child: ListTile(
                          leading: Image.network(
                            'https://www.transparentpng.com/thumb/google-logo/google-logo-png-icon-free-download-SUF63j.png',
                            height: 33,
                            width: 33,
                          ),
                          title: Text(
                            'Sign In with Google',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text('This App is for the assignment for Yellow Class\'s campus drive 2022 ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: kTextLightColor)),
                    ],
                  ),
                ),
              ),

            ],
          ),
        );
  }
}