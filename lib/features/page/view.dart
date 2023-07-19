import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:you_learnt/entities/PageModel.dart';
import 'package:you_learnt/utils/custom_widget/custom_text.dart';

class PagePage extends StatelessWidget {
  PageModel? pageModel;
  int? type;

  PagePage({Key? key, this.pageModel, this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(pageModel?.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: HtmlWidget(type == 1
            ? pageModel?.body?.recommendationsVideos ?? ''
            : pageModel?.body?.recommendationsPictures ?? ''),
      ),
    );
  }
}
