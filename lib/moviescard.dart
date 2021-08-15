import 'package:flutter/material.dart';


import 'constants.dart';

class MovieCard extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    // It  will provide us total height and width of our screen
    Size size = MediaQuery.of(context).size;
    return Container(
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
              top: 10,
              right: 10,
              child: SizedBox(
                height: 100,
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
                        "Finding Nemo",
                        style: TextStyle(
                          fontSize: 16,
                          color: kTextColor,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding),
                      child: Text(
                        "Directed by Christoper Nolan",
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
              child: Hero(
                tag: '52257',
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage('https://images.unsplash.com/photo-1514649923863-ceaf75b7ec00?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=334&q=80'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  height: 150,

                  // image is square but we add extra 20 + 20 padding thats why width is 200
                  width: 130,

                ),
              ),
            ),
            // Product title and price

          ],
        ),
      ),
    );
  }
}