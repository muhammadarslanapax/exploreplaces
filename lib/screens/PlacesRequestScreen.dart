import '../utils/Extensions/Widget_extensions.dart';
import '../utils/Extensions/context_extensions.dart';
import '../utils/Extensions/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../components/PlacesComponent.dart';
import '../main.dart';
import '../models/PlaceModel.dart';
import '../utils/AppConstant.dart';
import '../utils/Common.dart';
import 'AddPlaceScreen.dart';

class PlacesRequestScreen extends StatefulWidget {
  @override
  PlacesRequestScreenState createState() => PlacesRequestScreenState();
}

class PlacesRequestScreenState extends State<PlacesRequestScreen> {
  ScrollController _scrollController = ScrollController();
  List<PlaceModel> placeList = [];
  bool isLast = true;

  @override
  void initState() {
    super.initState();
    init();
    _scrollController.addListener(() async {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      if (maxScroll == currentScroll) {
        if (!isLast) {
          init();
        }
      }
    });
  }

  void init() async {
    loadRewardedAds(onAdComplete: (){
      appStore.addFavourite(appStore.selectedPlaceId);
      setState(() {});
    });
    appStore.setLoading(true);
    await requestPlaceService.fetchRequestPlaceList(list: placeList).then((value) {
      appStore.setLoading(false);
      isLast = value.length < perPageLimit;
      placeList.addAll(value);
      setState(() {});
    }).catchError((error) {
      appStore.setLoading(false);
      throw error;
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(language.placesRequest), actions: [
        dialogPrimaryButton(language.addPlace, () {
          AddPlaceScreen(onUpdate: (){
            placeList.clear();
            init();
          }).launch(context);
        }).paddingAll(8),
      ]),
      body: Observer(builder: (context) {
        return Stack(
          children: [
            placeList.isNotEmpty
                ? AnimationLimiter(
                    child: ListView.builder(
                      controller: _scrollController,
                      shrinkWrap: true,
                      itemCount: placeList.length,
                      padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                      itemBuilder: (_, index) {
                        PlaceModel place = placeList[index];
                        return AnimationConfiguration.staggeredList(
                          duration: Duration(milliseconds: 800),
                          position: index,
                          child: SlideAnimation(
                            horizontalOffset: 50.0,
                            verticalOffset: 20.0,
                            child: FadeInAnimation(
                              child: placesComponent(
                                  place,
                                  context,
                                  () {
                                    appStore.addRemoveFavouriteData(context, place.id.validate());
                                    setState(() {});
                                  },
                                  width: context.width(),
                                  isRequestPlace: true,
                                  onUpdate: () {
                                    placeList.clear();
                                    init();
                                  }),
                            ),
                          ),
                        ).paddingBottom(16);
                      },
                    ),
                  )
                : !appStore.isLoading
                    ? emptyWidget()
                    : loaderWidget(),
            loaderWidget().visible(appStore.isLoading),
          ],
        );
      }),
      bottomNavigationBar: showBannerAd(),
    );
  }
}
