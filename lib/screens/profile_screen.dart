import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart' show BlurHash;

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      width: 300,
      child: BlurHash(
        hash: "LEG[i,~q.R0L9D4Uob-oxo%1RPt7",
        imageFit: BoxFit.cover,
        color: Color(0xff121212).withOpacity(0),
        curve: Curves.slowMiddle,
        image: "https://firebasestorage.googleapis.com/v0/b/explore-dating.appspot.com/o/Userphotos%2F7Hsr2gfBRvaByEJrudUmP3HsOWI3%2Fcurrentbodyphoto%2Fchoosenbodyphoto.jpg?alt=media&token=397a0b86-b89d-42b8-9e01-6253f820a279",
        // image: scrollUserDetails[index]["headphoto"],
      ),
    );
  }
}

// Container(
//       height: 500,
//       width: 300,
//       decoration: BoxDecoration(
//         image: DecorationImage(
//             image: NetworkImage(
//                 "https://firebasestorage.googleapis.com/v0/b/explore-dating.appspot.com/o/Userphotos%2FcQuVT7vGIRMdaQBNCW4Vl24EOIr2%2Fcurrentheadphoto%2Fchoosenheadphoto.jpg?alt=media&token=df5ddde2-9c06-4b51-953a-eda7a3d08ca3"),
//             fit: BoxFit.cover),
//       ),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 4,sigmaY: 3),
//         child: Container(
//           color: Color(0xff121212).withOpacity(0),
//         ),
//       ),
//     );
