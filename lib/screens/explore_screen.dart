// todo : Feeds of dating

import 'package:cached_network_image/cached_network_image.dart';
import 'package:explore/data/temp/store_basic_match.dart';
import 'package:explore/models/spinner.dart';
import 'package:flutter/material.dart';

// ? : topBox -> head photo ,name,age,location
// ? : middleBox -> body photo
//  ? lowerBox -> heart , star , report

class ExploreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Container(
                // ! main height for scrolling
                height: 500,
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  // color: Colors.pink,
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                ),
                child: Column(
                  children: [
                    topBox(index),
                    middleBox(index),
                  ],
                ),
              );
            },
            childCount: scrollUserDetails.length,
          ),
        ),
      ],
    );
  }
}

Widget topBox(int index) {
  return Container(
    height: 100,
    decoration: BoxDecoration(
      color: Color(0xffF8C80D),
      borderRadius: BorderRadius.only(
        topLeft: const Radius.circular(30),
        topRight: const Radius.circular(30),
      ),
    ),
    child: Stack(
      children: [
        Container(
          // ? head photo
          margin: const EdgeInsets.only(top: 7, left: 15),
          alignment: Alignment.topLeft,
          child: CircleAvatar(
            radius: 40,
            backgroundColor: Color(0xff121212),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: scrollUserDetails[index]["headphoto"].toString(),
                fit: BoxFit.cover,
                placeholder: (context, url) => whileHeadImageloadingSpinner(),
                errorWidget: (context, url, error) =>
                    whileHeadImageloadingSpinner(),
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20, left: 110),
          child: Row(
            // ? handle name and age widgets
            children: [
              Container(
                // ? name text
                child: GestureDetector(
                  child: Text(
                    "${scrollUserDetails[index]["name"]},",
                    style: const TextStyle(
                        fontSize: 20,
                        color: Color(0xff121212),
                        fontWeight: FontWeight.w500),
                  ),
                  onTap: (){
                    print("Tapping $index");
                  },
                ),
              ),
              Container(
                // ? age text
                margin: const EdgeInsets.only(left: 5),
                child: Text(
                  "${scrollUserDetails[index]["age"]}",
                  style: const TextStyle(
                      fontSize: 20,
                      color: Color(0xff121212),
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 55, left: 95),
          // ? city and state
          padding: EdgeInsets.only(left: 15),
          child: Text(
            "${scrollUserDetails[index]["city_state"]}",
            style: const TextStyle(
                fontSize: 20,
                color: Color(0xff121212),
                fontWeight: FontWeight.w500),
          ),
        ),
      ],
    ),
  );
}

Widget middleBox(int index) {
  return Container(
    // ? body image
    child: ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: const Radius.circular(30),
        bottomRight: const Radius.circular(30),
      ),
      child: CachedNetworkImage(
        height: 400,
        width: double.infinity,
        imageUrl: scrollUserDetails[index]["bodyphoto"].toString(),
        fit: BoxFit.cover,
        placeholder: (context, url) => loadingSpinner(),
        errorWidget: (context, url, error) => loadingSpinner(),
      ),
    ),
  );
}
