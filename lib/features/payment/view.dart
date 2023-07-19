import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:you_learnt/constants/env.dart';
import 'package:you_learnt/constants/images.dart';

import '../../data/remote/api_requests.dart';
import '../../sub_features/payment_result_dialog.dart';
import '../../utils/error_handler/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum ComeFrom {
  defaul,
  bookSessionDilog,
  buyPackage,
  joinTeacherGroup,
  acceptStuedntRequest
}

class PaymentScreen extends StatefulWidget {
  final String url;
  final ComeFrom comeFrom;

  const PaymentScreen({Key? key, required this.url, required this.comeFrom})
      : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  ///
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        applePayAPIEnabled: true,
        allowsInlineMediaPlayback: true,
      ));

  late PullToRefreshController pullToRefreshController;
  double progress = 0;
  String url = '';
  final urlController = TextEditingController();

  ///
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  final ApiRequests _apiRequests = Get.find();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    url = widget.url;
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Image.asset(iconLogo, height: 35.h)),
      body: Stack(
        children: [
          InAppWebView(
            key: webViewKey,
            initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
            initialOptions: options,
            pullToRefreshController: pullToRefreshController,
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
            onLoadStart: (controller, url) async {
              setState(() {
                this.url = url.toString();
                urlController.text = this.url;
              });
            },
            androidOnPermissionRequest: (controller, origin, resources) async {
              return PermissionRequestResponse(
                  resources: resources,
                  action: PermissionRequestResponseAction.GRANT);
            },
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              var uri = navigationAction.request.url!;
              log('url => $uri');
              if (uri.toString().contains(baseUrl) &&
                  uri.toString().contains('token')) {
                isLoading = true;
                setState(() {});
                try {
                  Dio(BaseOptions(receiveDataWhenStatusError: true))
                      .get(uri.toString())
                      .then((value) {
                    log(value.data.toString());
                    if (value.data['message'].contains('ORDER_PAID_SUCCESS')) {
                      switch (widget.comeFrom) {
                        case ComeFrom.bookSessionDilog:
                          Get.back();
                          Get.back();
                          // Get.bottomSheet(const PaymentResultDialog(
                          //   success: true,
                          // ));
                          break;
                        case ComeFrom.buyPackage:
                          Get.back();
                          Get.back();
                          // Get.back();
                          // Get.bottomSheet(const PaymentResultDialog(
                          //   success: true,
                          // ));
                          break;
                        case ComeFrom.joinTeacherGroup:
                          Get.back();
                          Get.back();
                          // Get.back();
                          // Get.bottomSheet(const PaymentResultDialog(
                          //   success: true,
                          // ));
                          break;
                        case ComeFrom.acceptStuedntRequest:
                          Get.back();
                          Get.back();
                          // Get.back();
                          // Get.bottomSheet(const PaymentResultDialog(
                          //   success: true,
                          // ));
                          break;
                        default:
                          Get.back();
                          Get.back();
                          Get.bottomSheet(const PaymentResultDialog(
                            success: true,
                          ));
                      }
                    } else {
                      Get.back();
                      Get.back();
                      ErrorHandler.handleError(value);
                    }
                  });
                } catch (e) {
                  print(e.toString());
                }
              }
              if (![
                "http",
                "https",
                "file",
                "chrome",
                "data",
                "javascript",
                "about"
              ].contains(uri.scheme)) {
                if (await canLaunch(url)) {
                  await launch(
                    url,
                  );
                  // and cancel the request
                  return NavigationActionPolicy.CANCEL;
                }
              }

              return NavigationActionPolicy.ALLOW;
            },
            onLoadStop: (controller, url) async {
              pullToRefreshController.endRefreshing();
              setState(() {
                this.url = url.toString();
                urlController.text = this.url;
              });
            },
            onLoadError: (controller, url, code, message) {
              pullToRefreshController.endRefreshing();
            },
            onProgressChanged: (controller, progress) {
              if (progress == 100) {
                pullToRefreshController.endRefreshing();
              }
              setState(() {
                this.progress = progress / 100;
                urlController.text = url;
              });
            },
            onUpdateVisitedHistory: (controller, url, androidIsReload) {
              setState(() {
                this.url = url.toString();
                urlController.text = this.url;
              });
            },
            onConsoleMessage: (controller, consoleMessage) {
              print(consoleMessage);
            },
          ),
        ],
      ),
    );
  }
}
