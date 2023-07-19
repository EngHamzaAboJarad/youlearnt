import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_file_plus/open_file_plus.dart';
import '/main.dart';
import 'package:get/get.dart';

import 'custom_widget/custom_text.dart';
import 'package:html/parser.dart';

import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

double checkDouble(dynamic value) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return 0.0;
  if (value is List<int>) return value.isEmpty ? 0.0 : value.first.toDouble();
  if (value is List<double>) return value.isEmpty ? 0.0 : value.first;
  return 0.0;
}

Future<bool> checkInternet() async {
  final ConnectivityResult result = await Connectivity().checkConnectivity();
  if (result == ConnectivityResult.none) {
    showMessage('يرجى التأكد من اتصالك بالإنترنت'.tr, 2);
    return false;
  }
  return true;
}

String calculateDiscount(
    {required double salePriceTotal, required double priceTotal}) {
  return isArabicLanguage
      ? '${((1 - (salePriceTotal / priceTotal)) * 100).ceil().toString()}%-'
      : '-${((1 - (salePriceTotal / priceTotal)) * 100).ceil().toString()}%';
}

String replaceArabicNumber(String input) {
  const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

  for (int i = 0; i < english.length; i++) {
    input = input.replaceAll(arabic[i], english[i]);
  }
  return input;
}

extension E on String {
  String lastChars(int n) => substring(length - n);
}

int getMaxLength(String selectedCode) {
  var num = 9;
  if (selectedCode.contains('966')) num = 9;
  if (selectedCode.contains('971')) num = 9;
  if (selectedCode.contains('965')) num = 8;
  if (selectedCode.contains('968')) num = 8;
  if (selectedCode.contains('973')) num = 8;
  if (selectedCode.contains('974')) num = 8;

  return num;
}

showMessage(String? text, int type) {
  if ((text?.length ?? 0) == 0) return;
  dev.log(text ?? '');
  Get.snackbar(
    '',
    "",
    onTap: (_)=>Get.back(),
    snackPosition: SnackPosition.BOTTOM,
    duration: const Duration(seconds: 1),
    titleText: const SizedBox(),
    padding: const EdgeInsets.only(left: 10,right: 10,bottom: 10,top: 6),
    messageText: Row(
      children: [
        Container(
          decoration: BoxDecoration(
              color: type == 1 ? Colors.green : Colors.yellow.shade700,
              borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsetsDirectional.only(end: 10),
          padding: const EdgeInsets.all(5),
          child: Icon(
            type == 1 ? Icons.check_circle : Icons.warning_rounded,
            color: type == 1 ? Colors.white : Colors.white,
            size: 18,
          ),
        ),
        Expanded(
            child: CustomText(
          text?.contains('\n') != true
              ? text
              : text?.substring(0, text.length - 1),
          fontSize: 12,
          color: type == 1 ? Colors.white : Colors.black,
        )),
      ],
    ),
    borderRadius: 15,
    snackStyle: SnackStyle.FLOATING,
    margin: const EdgeInsets.fromLTRB(20, 0, 20, 60),
    backgroundColor: type == 1 ? Colors.green.shade400 : Colors.yellow.shade600,
  );
}

String? convertUrlToId(String url, {bool trimWhitespaces = true}) {
  if (!url.contains("http") && (url.length == 11)) return url;
  if (trimWhitespaces) url = url.trim();

  for (var exp in [
    RegExp(
        r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
    RegExp(
        r"^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$"),
    RegExp(r"^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$")
  ]) {
    Match? match = exp.firstMatch(url);
    if (match != null && match.groupCount >= 1) return match.group(1);
  }

  return null;
}

String? getYoutubeThumbnail(String? videoUrl) {
  if (videoUrl == null) return null;
  var image = 'https://img.youtube.com/vi/${convertUrlToId(videoUrl)}/0.jpg';
  return image;
}

Iterable<E> mapIndexed<E, T>(
    Iterable<T> items, E Function(int index, T item) f) sync* {
  var index = 0;

  for (final item in items) {
    yield f(index, item);
    index = index + 1;
  }
}

E? firstOrNull<E>(List<E>? list) {
  return list == null || list.isEmpty ? null : list.first;
}

extension Iterables<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
      <K, List<E>>{},
      (Map<K, List<E>> map, E element) =>
          map..putIfAbsent(keyFunction(element), () => <E>[]).add(element));
}

String? parseHtmlString(String? htmlString) {
  final document = parse(htmlString);
  final String? parsedString = parse(document.body?.text).documentElement?.text;

  return parsedString;
}

Future<File> urlToFile(String imageUrl) async {
  var rng = Random();
  Directory tempDir = await getTemporaryDirectory();
  String tempPath = tempDir.path;
  File file = File(tempPath + (rng.nextInt(100)).toString() + '.png');
  http.Response response = await http.get(Uri.parse(imageUrl));
  await file.writeAsBytes(response.bodyBytes);
  return file;
}

Future<String> downloadFile(String url, String fileName) async {

  HttpClient httpClient = HttpClient();
  File file;
  String filePath = '';

  try {
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    if(response.statusCode == 200) {
      var bytes = await consolidateHttpClientResponseBytes(response);
      String dir = (await getApplicationDocumentsDirectory()).path;
      filePath = '$dir/$fileName';
      file = File(filePath);
      await file.writeAsBytes(bytes);
      showMessage('Saved in Documents', 1);
      final _result = await OpenFile.open(filePath);
      print(_result.message);

    }
    else {
      filePath = 'Error code: '+response.statusCode.toString();
    }
  }
  catch(ex){
    filePath = 'Can not fetch url ${ex.toString()}';

  }

  dev.log(filePath);
  return filePath;
}

extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}