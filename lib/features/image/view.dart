import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:you_learnt/utils/custom_widget/custom_image.dart';

import '../../constants/images.dart';
import 'logic.dart';

class ImagePage extends StatelessWidget {
  final String? imageUrl;

  const ImagePage({Key? key, this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: PhotoView(
        backgroundDecoration: const BoxDecoration(color: Colors.black),
        errorBuilder: (a, b, c) => Image.asset(
          iconLogo,
          color: Colors.white,
          scale: 3,
        ),
        imageProvider: CachedNetworkImageProvider(
          imageUrl ?? '',
        )),
    );
  }
}
