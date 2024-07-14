import '../utils/Common.dart';
import '../utils/Extensions/Widget_extensions.dart';
import '../utils/Extensions/context_extensions.dart';
import '../utils/Extensions/int_extensions.dart';
import '../utils/Extensions/string_extensions.dart';
import 'package:flutter/material.dart';
import '../models/PlaceModel.dart';
import '../utils/Extensions/Colors.dart';
import '../utils/Extensions/text_styles.dart';

class ZoomImageScreen extends StatefulWidget {
  final PlaceModel place;
  final String? image;

  ZoomImageScreen({required this.place,this.image});

  @override
  ZoomImageScreenState createState() => ZoomImageScreenState();
}

class ZoomImageScreenState extends State<ZoomImageScreen> {
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
      ),
      body: SizedBox(
        height: context.height(),
        width: context.width(),
        child: Stack(
          fit: StackFit.expand,
          children: [
            cachedImage(widget.image ?? widget.place.image, fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.9),
                  ])),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 ratingWidget((widget.place.rating ?? 0).toDouble()),
                  12.height,
                  Text(
                    widget.place.name.toString().toUpperCase(),
                    style: boldTextStyle(color: whiteColor, size: 20),
                    maxLines: 3,
                  ),
                  12.height,
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, color: whiteColor, size: 20),
                      4.width,
                      Text(widget.place.address.validate(), style: primaryTextStyle(color: whiteColor)).expand(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
