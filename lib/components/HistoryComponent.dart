import '../utils/Common.dart';
import 'package:flutter/material.dart';

import 'HtmlWidget.dart';

class HistoryComponent extends StatefulWidget {
  final String description;

  HistoryComponent({required this.description});

  @override
  HistoryComponentState createState() => HistoryComponentState();
}

class HistoryComponentState extends State<HistoryComponent> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return widget.description.isNotEmpty
        ? SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: HtmlWidget(postContent: widget.description),
          )
        : emptyWidget();
  }
}
