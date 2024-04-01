import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:secondhand/constants/colors.dart';

class ImageViewer extends StatelessWidget {
  const ImageViewer({Key? key, required this.imageLink}) : super(key: key);
  final String imageLink;
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
        ),
        body: Center(
          child: Hero(
              tag: imageLink,
              child: InteractiveViewer(
                  clipBehavior: Clip.none,
                  child: CachedNetworkImage(
                    imageUrl: imageLink,
                    placeholder: (_, s) => Center(
                      child: CircularProgressIndicator(
                        color: kPrimaryColor,
                        strokeWidth: 1.5,
                      ),
                    ),
                  ))),
        ),
      ),
    );
  }
}
