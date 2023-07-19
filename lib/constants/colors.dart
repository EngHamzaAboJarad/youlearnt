import 'package:flutter/material.dart';

const progressColor = primaryColor;

const primaryColor = Color(0xffEE3536);
const secondaryColor = Color(0xff2E4884);
const secondaryLightColor = Color(0xffC3CCE4);
const blueColor = Color(0xff7BC1FE);
const blueColor2 = Color(0xff50B8E0);

const moveColor = Color.fromRGBO(234, 127, 127, 1.0);
const greyTextColor = Color(0xff636363);
const greyTextBoldColor = Color(0xff868894);
const greenColor = Color(0xff57A257);
const orangeColor = Color(0xffFC9909);
const yalowColor = Color.fromRGBO(255, 215, 80, 1.0);
final baseColor = Colors.grey.shade100;
final highlightColor = Colors.grey.shade300;
const blueLightSplashBackgroundColor = Color.fromRGBO(255, 255, 255, 1.0);

Map<int, Color> mapColor = {
  50 : const Color.fromRGBO(238,53,54, .1),
  100: const Color.fromRGBO(238,53,54, .2),
  200: const Color.fromRGBO(238,53,54, .3),
  300: const Color.fromRGBO(238,53,54, .4),
  400: const Color.fromRGBO(238,53,54, .5),
  500: const Color.fromRGBO(238,53,54, .6),
  600: const Color.fromRGBO(238,53,54, .7),
  700: const Color.fromRGBO(238,53,54, .8),
  800: const Color.fromRGBO(238,53,54, .9),
  900: const Color.fromRGBO(238,53,54, 1),
};

MaterialColor mainColor = MaterialColor(0xFFEE3536, mapColor);