import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/images.dart';

class CustomImage extends StatelessWidget {
  final String? url;
  final double? height;
  final double? width;
  final double size;
  final BoxFit? fit;
  final bool loading;

  const CustomImage(
      {Key? key,
      required this.url,
      this.height,
      this.width,
      this.size = 50,
      this.loading = true,
      this.fit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (url?.contains('base64') == true) {
      return Image.memory(
        base64Decode(url!.replaceAll('data:image/png;base64,', '')),
        height: height?.h,
        width: width?.w,
      );
    }
    if (url?.contains('svg') == true) {
      return SvgPicture.network(url ?? '',
          height: height?.h,
          width: width?.w,
          fit: fit ?? BoxFit.contain,
          placeholderBuilder: (BuildContext context) => Image.asset(
                iconLogo,
                width: size.sp,
                height: size.sp,
              ));
    }
    return CachedNetworkImage(
      height: height,
      width: width,
      fit: fit ?? BoxFit.contain,
      imageUrl: url ?? '',
      placeholder: (context, url) => loading
          ? const SizedBox(
              width: 25,
              height: 25,
              child: Center(
                  child: CircularProgressIndicator(
                strokeWidth: 2,
              )))
          : const SizedBox(),
      errorWidget: (context, url, error) => Padding(
        padding: const EdgeInsets.all(5),
        child: Image.asset(
          iconLogo,
          height: height?.h,
          width: width?.w,
        ),
      ),
    );
  }
}
