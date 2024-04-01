import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:share_plus/share_plus.dart';

class DynamicLinkHelperClass{

  DynamicLinkHelperClass();

  void shareData(var context, String subject, String message){
    final RenderBox box = context.findRenderObject();
    Share.share(message,
        subject: subject,
        sharePositionOrigin:
        box.localToGlobal(Offset.zero) &
        box.size);
  }

  Future<String> createDynamicLink(String id) async {
    var parameters = DynamicLinkParameters(
      uriPrefix: 'https://secondhand.page.link',
      link: Uri.parse('https://secondhand.page.link/article?article_id=$id'),
      androidParameters: AndroidParameters(
        packageName: "de.mh_6.second_hand",
      ),
      iosParameters: IOSParameters(bundleId: "de.mh-6.second-hand"),
    );

    final shortLink = await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    var shortUrl = shortLink.shortUrl;

    return shortUrl.toString();
  }
}