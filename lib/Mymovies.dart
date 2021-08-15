import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_movies/moviescard.dart';
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

    Image image;

    List<Photo> images;

    _insert() async {
      Map<String, dynamic> row = {
        DatabaseHelper.moviename: MovieName,
        DatabaseHelper.director: Director
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


    // pickImageFromGallery() async{
    //   final ImagePicker _picker = ImagePicker();
    //   String imgString = Utility.base64String(ImagePicker().);
    //   Photo photo = Photo(0, imgString);
    //   // final bytes = await Io.File(ImagePicker).readAsBytes();
    //
    //   // String base64Encode(List<int> bytes) => base64.encode(bytes);
    //   // print(base64Encode(bytes));
    // }

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
              icon: const Icon(Icons.info),
              color: kSecondaryColor,
              onPressed: () async {
                final myrows = await dbHelper.queryAllRows();
                print(myrows);
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
                      ],
                    ),
                    buttons: [
                      DialogButton(
                        onPressed: () {
                          // pickImageFromGallery();


                        },
                        color: kSecondaryColor,
                        child: Text(
                          "Choose Image",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      DialogButton(
                        onPressed: () {
                          if(MovieName != '' && Director != ''){
                            _insert();
                            Navigator.pop(context);
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
                return ListView.builder(
                  // here we use our demo procuts list
                  itemCount: mymovielist.length,
                  itemBuilder: (context, index) => 
                      GestureDetector(
                        onTap: (){
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
                                        DatabaseHelper.director: up_Director
                                      };
                                      dbHelper.update(up_row);
                                      Navigator.pop(context);
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
                                    image: NetworkImage(
                                        'https://images.unsplash.com/photo-1514649923863-ceaf75b7ec00?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=334&q=80'),
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
              } else {
                return Text('Loading');
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
