import 'package:carousel_slider/carousel_slider.dart';
import '../models/CategoryModel.dart';
import '../models/PlaceModel.dart';
import '../utils/Extensions/Commons.dart';
import '../utils/Extensions/Widget_extensions.dart';
import '../utils/Extensions/context_extensions.dart';
import '../utils/Extensions/int_extensions.dart';
import '../utils/Extensions/string_extensions.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../models/DashboardResponse.dart';
import '../screens/CategoryScreen.dart';
import '../screens/PlaceDetailScreen.dart';
import '../screens/ViewAllScreen.dart';
import '../utils/AppColor.dart';
import '../utils/Common.dart';
import '../utils/Extensions/Colors.dart';
import '../utils/Extensions/Constants.dart';
import '../utils/Extensions/decorations.dart';
import '../utils/Extensions/text_styles.dart';

class HomeCategoryWidget extends StatefulWidget {
  final List<CategoryPlaceModel> categoryPlaceModel;

  HomeCategoryWidget(this.categoryPlaceModel);

  @override
  HomeCategoryWidgetState createState() => HomeCategoryWidgetState();
}

class HomeCategoryWidgetState extends State<HomeCategoryWidget> {
  CarouselController controller = CarouselController();
  String? selectedCatId = "";
  int categoryIndex = 1;
  int placeIndex = 1;

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
    return widget.categoryPlaceModel.isNotEmpty
        ? Column(
            children: [
              headingWidget(language.category, () {
                CategoryScreen().launch(context);
              }),
              16.height,
              CarouselSlider.builder(
                carouselController: controller,
                itemCount: widget.categoryPlaceModel.length,
                itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
                  CategoryModel category = widget.categoryPlaceModel[itemIndex].category!;
                  return GestureDetector(
                    onTap: (){
                      ViewAllScreen(name: category.name.validate(),catId: category.id).launch(context);
                    },
                    child: Column(
                      children: [
                        cachedImage(category.image.validate(), width: context.width() / 3, fit: BoxFit.cover).cornerRadiusWithClipRRect(defaultRadius).expand(),
                        10.height,
                        Text(
                          category.name.toString(),
                          style: itemIndex == categoryIndex ? boldTextStyle(color: primaryColor) : primaryTextStyle(),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ).paddingOnly(left: 6, right: 6),
                  );
                },
                options: CarouselOptions(
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                  onPageChanged: (i, v) {
                    selectedCatId = widget.categoryPlaceModel[categoryIndex].category!.id;
                    categoryIndex = i;
                    placeIndex = 1;
                    setState(() {});
                  },
                  initialPage: categoryIndex,
                  height: context.width() / 3,
                  viewportFraction: 0.33,
                ),
              ),
              20.height,
              (widget.categoryPlaceModel[categoryIndex].places ?? []).isNotEmpty
                  ? CarouselSlider.builder(
                      carouselController: controller,
                      itemCount: widget.categoryPlaceModel[categoryIndex].places!.length,
                      itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
                        PlaceModel place = widget.categoryPlaceModel[categoryIndex].places![itemIndex];
                        return Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            cachedImage(place.image.toString(), height: context.height(), width: context.width(), fit: BoxFit.cover).cornerRadiusWithClipRRect(defaultRadius).paddingOnly(bottom: 24),
                            Container(
                              margin: EdgeInsets.only(bottom: 24),
                              height: context.height(),
                              width: context.width(),
                              decoration: boxDecorationWithRoundedCornersWidget(
                                borderRadius: radius(defaultRadius),
                                border: Border.all(color: appStore.isDarkMode ? Colors.white.withOpacity(0.1) : Colors.transparent),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.1),
                                    Colors.black.withOpacity(0.1),
                                    Colors.black.withOpacity(0.3),
                                    Colors.black.withOpacity(0.9),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 16,
                              right: 16,
                              child: GestureDetector(
                                child: favouriteItemWidget(placeId: place.id.validate()),
                                onTap: () {
                                  appStore.setSelectedPlaceId(place.id.validate());
                                  appStore.addRemoveFavouriteData(context, place.id.validate());
                                  setState(() {});
                                },
                              ),
                            ),
                            Positioned(
                              left: 16,
                              right: 16,
                              bottom: 0,
                              child: Column(
                                children: [
                                  Text(place.name.toString().toUpperCase(), style: boldTextStyle(color: whiteColor, size: 18), textAlign: TextAlign.center, maxLines: 2),
                                  8.height,
                                  Text(
                                    parseHtmlStringWidget(place.description.toString()),
                                    style: secondaryTextStyle(color: whiteColor),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ).visible(place.description != null),
                                  16.height,
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                    decoration: boxDecorationWithRoundedCornersWidget(backgroundColor: context.cardColor, boxShadow: [BoxShadow(blurRadius: 1)], borderRadius: radius(defaultRadius)),
                                    child: Text(language.explore, style: boldTextStyle()),
                                  ),
                                  8.height,
                                ],
                              ),
                            ),
                          ],
                        ).onTap(() {
                          appStore.setSelectedPlaceId(place.id.validate());
                          PlaceDetailScreen(placeData: place).launch(context);
                        });
                      },
                      options: CarouselOptions(
                        enlargeCenterPage: true,
                        enableInfiniteScroll: false,
                        onPageChanged: (i, v) {
                          placeIndex = i;
                          setState(() {});
                        },
                        initialPage: placeIndex,
                        viewportFraction: 0.7,
                        aspectRatio: 1,
                      ),
                    )
                  : emptyWidget(),
              20.height,
            ],
          )
        : emptyWidget();
  }
}
