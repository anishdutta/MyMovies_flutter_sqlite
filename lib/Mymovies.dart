import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_movies/moviescard.dart';
import 'package:my_movies/signin.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'constants.dart';
import 'moviescard.dart';
import 'package:hive/hive.dart';
import 'Database/db_helper.dart';
import 'Database/movie.dart';
import 'dart:convert';
import 'Database/ImageUtil.dart';
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';



class Mymovies extends StatefulWidget {
  @override
  _MymoviesState createState() => _MymoviesState();
}
class Photo {
  int id = 0;
  String photo_name = '';

  Photo(this.id, this.photo_name);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'photo_name': photo_name,
    };
    return map;
  }

  Photo.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    photo_name = map['photo_name'];
  }
}

class _MymoviesState extends State<Mymovies> {
  @override
  Widget build(BuildContext context) {
    Size _screenSize = MediaQuery.of(context).size;
    FocusNode myFocusNode = new FocusNode();
    final dbHelper = DatabaseHelper.instance;
    String MovieName = '';
    String Director = "";
    String up_MovieName = '';
    String up_Director = "";
    File? _image ;
    String imagestring = '';



    Image image;

    List<Photo> images;

    _insert() async {
      Map<String, dynamic> row = {
        DatabaseHelper.moviename: MovieName,
        DatabaseHelper.director: Director,
        DatabaseHelper.imgstring: imagestring
      };
      final id = await dbHelper.insert(row);

      print('inserted roq: $id');
    }

    List mymovielist = [];
    getallrows() async {
      final myrows = await dbHelper.queryAllRows();
      print(myrows);
      myrows.forEach((element) {
        mymovielist.add(element);
      });
      return myrows;
    }
    Future getImage() async {


      try{
        XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 50);
        print(image!.path);
        if (image != null) {






          final bytes = File(image.path).readAsBytesSync();
          setState(() {
            _image = File(image.path);
            imagestring = base64Encode(bytes);
          });

          print(imagestring);
          Fluttertoast.showToast(
              msg: "Image saved",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: kSecondaryColor,
              textColor: kTextColor,
              fontSize: 16.0
          );
          // var responseProfileImage = await userRestSrv.updateImage(userId, img64);

          // if (responseProfileImage != null && responseProfileImage.data['ResponseCode'] == "00")
          //   showMessage('Profile Image not uploaded', false);
        }
      } catch(e){
        print(e);
      }

    }




    Image imageFromBase64String(String base64String) {
      return Image.memory(base64Decode(base64String));
    }
    var _imageBase64;
    var bytes;


    Uint8List dataFromBase64String(String base64String) {
      return base64Decode(base64String);
    }
    mytoast(){
      return Fluttertoast.showToast(
          msg: "Please fill all form and choose an image",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: kSecondaryColor,
          textColor: kTextColor,
          fontSize: 16.0
      );
    }

    return SafeArea(
      child: Scaffold(

        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: kBackgroundColor,
          title: Text(
            'My Movies',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kTextColor,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.power_settings_new_sharp),
              color: kSecondaryColor,
              onPressed: () async {
                await FirebaseAuth.instance.signOut().then((value) => {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Signin()),
                  )
                });
              },
            ),
          ],
        ),
        backgroundColor: kBackgroundColor,
        floatingActionButton: Container(
          padding: EdgeInsets.only(bottom: 10.0),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FloatingActionButton.extended(
              backgroundColor: kSecondaryColor,
              onPressed: () {
                Alert(
                    context: context,
                    title: "Add your fav movie!",
                    content: Column(
                      children: <Widget>[
                        TextField(
                          onChanged: (val){
                            MovieName = val;
                          },
                          decoration: InputDecoration(
                            icon: Icon(Icons.movie_creation,
                                color: kSecondaryColor),
                            labelText: 'Movie name',
                            labelStyle: TextStyle(
                                color: myFocusNode.hasFocus
                                    ? Colors.blue
                                    : Colors.black),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: kSecondaryColor),
                            ),
                          ),
                        ),
                        TextField(
                          onChanged: (val){
                            Director = val;
                          },
                          focusNode: myFocusNode,

                          decoration: InputDecoration(
                            focusColor: kSecondaryColor,
                            fillColor: kSecondaryColor,
                            labelStyle: TextStyle(
                                color: myFocusNode.hasFocus
                                    ? Colors.blue
                                    : Colors.black),
                            icon: Icon(
                              Icons.person_pin_outlined,
                              color: kSecondaryColor,
                            ),
                            labelText: 'Director',
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: kSecondaryColor),
                            ),
                          ),
                        ),
                        DialogButton(
                          onPressed: () {

                            getImage();

                            // pickImageFromGallery();


                          },
                          color: kSecondaryColor,
                          child: Text(
                            "Choose Image",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                        // _image == null? Text('Your image here') : Image.file(_image!),
                      ],
                    ),

                    buttons: [

                      DialogButton(
                        onPressed: () {
                          if(MovieName != '' && Director != '' && imagestring != ''){
                            setState(() {
                              _insert();

                            });


                            Navigator.pop(context);
                          }
                          else{
                            mytoast();
                          }


                        },
                        color: kSecondaryColor,
                        child: Text(
                          "ADD",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      )
                    ]).show();
              },
              icon: Icon(Icons.movie_filter_sharp),
              label: Text("Add Movies"),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Container(
          child: FutureBuilder(
            future: getallrows(),
            builder: (context, snap) {
              if (snap.data != null) {
                if(mymovielist.isNotEmpty){
                  print('here');
                  return ListView.builder(
                    // here we use our demo procuts list
                    itemCount: mymovielist.length,
                    itemBuilder: (context, index) =>
                        GestureDetector(
                          onTap: (){

                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: kDefaultPadding,
                              vertical: kDefaultPadding / 2,
                            ),
                            // color: Colors.blueAccent,
                            height: 160,
                            child: InkWell(
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: <Widget>[
                                  // Those are our background
                                  Container(
                                    height: 136,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(22),
                                      boxShadow: [kDefaultShadow],
                                    ),
                                    child: Container(
                                      margin: EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(22),
                                      ),
                                    ),
                                  ),
                                  // our product image
                                  Positioned(
                                    top: 25,
                                    right: 15,
                                    child: IconButton(
                                      icon: const Icon(Icons.delete),
                                      color: kSecondaryColor,
                                      onPressed: () {
                                        setState(() {
                                          dbHelper.delete(mymovielist[index]['_id']);
                                        });


                                      },
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 7,
                                    right: 15,
                                    child: IconButton(
                                      icon: const Icon(Icons.edit),
                                      color: kSecondaryColor,
                                      onPressed: () {
                                        setState(() {
                                          Alert(
                                              context: context,


                                              title: "Update Movie details",
                                              content: Column(
                                                children: <Widget>[
                                                  TextField(
                                                    onChanged: (val){
                                                      up_MovieName = val;
                                                    },
                                                    decoration: InputDecoration(
                                                      icon: Icon(Icons.movie_creation,
                                                          color: kSecondaryColor),
                                                      labelText: 'Movie name',
                                                      labelStyle: TextStyle(
                                                          color: myFocusNode.hasFocus
                                                              ? Colors.blue
                                                              : Colors.black),
                                                      focusedBorder: UnderlineInputBorder(
                                                        borderSide: BorderSide(color: kSecondaryColor),
                                                      ),
                                                    ),
                                                  ),
                                                  TextField(
                                                    onChanged: (val){
                                                      up_Director = val;
                                                    },
                                                    focusNode: myFocusNode,

                                                    decoration: InputDecoration(
                                                      focusColor: kSecondaryColor,
                                                      fillColor: kSecondaryColor,
                                                      labelStyle: TextStyle(
                                                          color: myFocusNode.hasFocus
                                                              ? Colors.blue
                                                              : Colors.black),
                                                      icon: Icon(
                                                        Icons.person_pin_outlined,
                                                        color: kSecondaryColor,
                                                      ),
                                                      labelText: 'Director',
                                                      focusedBorder: UnderlineInputBorder(
                                                        borderSide: BorderSide(color: kSecondaryColor),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              buttons: [
                                                DialogButton(

                                                  onPressed: () {
                                                    if(up_MovieName != '' || up_Director != ''){
                                                      if(up_Director == ''){
                                                        up_Director = mymovielist[index]['director'];
                                                      }
                                                      else if(up_MovieName == ''){
                                                        up_MovieName = mymovielist[index]['moviename'];
                                                      }
                                                      Map<String, dynamic> up_row = {
                                                        DatabaseHelper.columnId: mymovielist[index]['_id'],
                                                        DatabaseHelper.moviename: up_MovieName,
                                                        DatabaseHelper.director: up_Director,
                                                        DatabaseHelper.imgstring: mymovielist[index]['imgstring']
                                                      };
                                                      dbHelper.update(up_row);

                                                      Navigator.of(context).pushReplacementNamed('/tab');
                                                    }


                                                  },
                                                  color: kSecondaryColor,
                                                  child: Text(
                                                    "Update",
                                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                                  ),
                                                )
                                              ]).show();
                                        });


                                      },
                                    ),
                                  ),
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: SizedBox(
                                      height: 100,
                                      width: 230,
                                      // our image take 200 width, thats why we set out total width - 200

                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: <Widget>[
                                          Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: kDefaultPadding),
                                            child: Text(
                                              "${mymovielist[index]['moviename']}",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: kTextColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: kDefaultPadding),
                                            child: Text(
                                              "Directed by ${mymovielist[index]['director']}",
                                              style: TextStyle(
                                                color: Color(0xFF76787F),
                                              ),
                                            ),
                                          ),
                                          // it use the available space
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    left: 10,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        image: DecorationImage(
                                          image: MemoryImage(
                                              dataFromBase64String(mymovielist[index]["imgstring"])
                                          ) ,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: kDefaultPadding),
                                      height: 150,

                                      // image is square but we add extra 20 + 20 padding thats why width is 200
                                      width: 130,
                                    ),
                                  ),
                                  // Product title and price
                                ],
                              ),
                            ),
                          ),
                        ),
                  );
                }
                else{
                  print('this');
                  return Center(
                      child:
                      Text('Add your fav movie now!',
                      style: TextStyle(
                        fontSize: 20
                      ),
                      ));
                }

              } else {
                return Center(child: Text('Loading'));
              }
            },
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      backgroundColor: kBackgroundColor,
      title: Text(
        'My Movies',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: kTextColor,
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.info),
          color: kSecondaryColor,
          onPressed: () {},
        ),
      ],
    );
  }
}

// _getallrows() {
//   final myrows = await dbHelper.queryAllRows();
//   print(myrows);
//   return myrows;
// }
