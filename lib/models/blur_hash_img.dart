// @dart=2.9

//  Todo : Blur hash the image
import 'dart:typed_data';
import 'package:blurhash/blurhash.dart';
import 'package:http/http.dart' as http;

Future<String>encodeBlurHashImg(String imagePath) async{
  try {
    Uri url = Uri.parse(imagePath);
    var response = await http.get(url);
    Uint8List pixels = response.bodyBytes.buffer.asUint8List();
    var blurHash = await BlurHash.encode(pixels, 4, 3); // 4 * 3
    print("Hashing completed");
    return blurHash;
  } catch (error) {
    print("Error in encoding blur hash image : ${error.toString()}");
    return "None";
  }
  
}