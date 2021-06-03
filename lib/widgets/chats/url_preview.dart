// @dart=2.9
// todo show url preview shared by the users
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:explore/models/spinner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart'
    show LinkifyOptions, Linkify;
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

Future<Map> getUrlData(String url) async {
  try {
    String key = "914e76fac753f34e8071ada2d85e52e5";
    Uri uri = Uri.tryParse(url);
    Uri linkPreviewUri =
        Uri.tryParse("https://api.linkpreview.net/?key=$key&q=$uri");

    var response = await http.get(linkPreviewUri);

    if (response.statusCode == 200) {
      Map jsonData = json.decode(response.body);
      return jsonData;
    }
    return {"title": "Error 404", "image": "", "url": url};
  } catch (e) {
    print("Error in getUrlData : ${e.toString()}");
    return {"title" : "Error 404","image" : "" , "url" : url};
  }
}

class PreviewUrl extends StatelessWidget {
  final Map urlData;
  PreviewUrl(this.urlData);
  final String errorImageUrl =
      "https://miro.medium.com/max/800/1*hFwwQAW45673VGKrMPE2qQ.png";
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            // ? photo of the url,
            height: 150,
            width: 200,
            margin: const EdgeInsets.only(top: 5),
            child: CachedNetworkImage(
              imageUrl: urlData["image"].isEmpty
                  ? errorImageUrl
                  : urlData["image"].toString(),
              placeholder: (context, url) => Center(
                child: whileHeadImageloadingSpinner(),
              ),
              errorWidget: (context, url, error) => Center(
                child: Text(
                  urlData["image"].toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),
              fit: BoxFit.fitWidth,
            ),
          ),
          Container(
            // ? title
            margin: const EdgeInsets.only(top: 15),
            child: Text(
              urlData["title"].toString(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
          ),
          Container(
            // ? url
            margin: const EdgeInsets.only(top: 15),
            child: Linkify(
              text: urlData["url"].toString(),
              onOpen: (link) async {
                if (await canLaunch(link.url)) {
                  await launch(link.url);
                }
              },
              maxLines: 10,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              options: LinkifyOptions(humanize: false),
              linkStyle: const TextStyle(color: Colors.white70, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
