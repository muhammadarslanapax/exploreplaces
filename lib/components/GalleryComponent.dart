import '../models/PlaceModel.dart';
import '../screens/ZoomImageScreen.dart';
import '../utils/Common.dart';
import '../utils/Extensions/Constants.dart';
import '../utils/Extensions/Widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class GalleryComponent extends StatefulWidget {
  final PlaceModel place;

  GalleryComponent({required this.place});

  @override
  GalleryComponentState createState() => GalleryComponentState();
}

class GalleryComponentState extends State<GalleryComponent> {
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
    return (widget.place.secondaryImages ?? []).isNotEmpty ? SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: StaggeredGrid.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: List.generate(widget.place.secondaryImages!.length, (index) {
          String image = widget.place.secondaryImages![index];
          return StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: index.isEven ? 1 : 2,
            child: GestureDetector(
              onTap: (){
                ZoomImageScreen(place:widget.place,image: image).launch(context);
              },
              child: cachedImage(image, fit: BoxFit.cover).cornerRadiusWithClipRRect(defaultRadius),
            ),
          );
        }),
      ),
    ) : emptyWidget();
  }
}
