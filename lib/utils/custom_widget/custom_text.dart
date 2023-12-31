import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomText extends StatelessWidget {
  final String? text;
  final double? fontSize;
  final Color color;
  final TextAlign? textAlign;
  final Function()? onTap;
  final FontWeight? fontWeight;
  final int? maxLines;
  final double? height;
  final bool? lineThrough;
  final TextOverflow? overflow;
  final TextDecoration textDecoration;
  const CustomText(this.text,
      {Key? key,
      this.fontSize,
      this.color = Colors.black,
      this.textAlign = TextAlign.start,
      this.onTap,
      this.fontWeight,
      this.maxLines,
      this.lineThrough,
      this.textDecoration = TextDecoration.lineThrough,
      this.overflow,
      this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double fs = ((fontSize == null ? 14 : fontSize!));
    return Text(
      text ?? '',
      textAlign: textAlign,
      style: TextStyle(
          decoration: lineThrough != null ? textDecoration : null,
          color: color,
          fontSize: fs.sp,
          overflow: overflow,
          fontWeight: fontWeight,
          height: height),
      maxLines: maxLines,
    );
  }
}
