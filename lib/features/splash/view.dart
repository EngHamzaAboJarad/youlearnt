import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:you_learnt/constants/images.dart';

import 'logic.dart';

class SplashPage extends StatelessWidget {
  final logic = Get.put(SplashLogic());

  SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(iconLogo , scale: 1.5,),
      ),
    );
  }
}
