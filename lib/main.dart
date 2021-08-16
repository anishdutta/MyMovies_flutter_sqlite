import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Mymovies.dart';
import 'constants.dart';
import 'signin.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final _auth = FirebaseAuth.instance;
  Future<User> getCurrentUser() async {
    User currentUser;
    currentUser = (await _auth.currentUser)!;
    return currentUser;
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My Movies',
        theme: ThemeData(
        // We set Poppins as our default font
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        primaryColor: kPrimaryColor,
        accentColor: kPrimaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    routes: {
          Mymovies.id: (context) =>Mymovies(),
          Signin.id: (context) => Signin()
    },

    home: FutureBuilder(
      future: getCurrentUser(),
      builder: (context, snapshot){
        if(snapshot.hasData){
          return Mymovies();
        }
        else{
          return Signin();
        }
      },
    ),
    );
  }
}

