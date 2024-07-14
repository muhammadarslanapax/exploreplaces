import '../utils/Extensions/Widget_extensions.dart';
import '../utils/Extensions/context_extensions.dart';
import '../utils/Extensions/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:geolocator/geolocator.dart';
import '../components/PlacesComponent.dart';
import '../main.dart';
import '../models/PlaceModel.dart';
import '../utils/AppConstant.dart';
import '../utils/Common.dart';

class ViewAllScreen extends StatefulWidget {
  final String name;
  final String? catId;
  final String? stateId;
  final String? placesType;
  final Position? position;

  ViewAllScreen({required this.name, this.catId, this.stateId, this.placesType, this.position});

  @override
  ViewAllScreenState createState() => ViewAllScreenState();
}

class ViewAllScreenState extends State<ViewAllScreen> {
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
        if (!isLast && widget.placesType != placesTypeNearBy) {
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
    if (widget.placesType == placesTypeNearBy && widget.position!=null) {
       await placeService.nearByPlaces(widget.position!,isViewAll: true).then((value) {
         appStore.setLoading(false);
         placeList.addAll(value);
         setState(() { });
       }).catchError((error) {
         appStore.setLoading(false);
         throw error;
       });
    } else {
      await placeService.fetchPlaceList(list: placeList, catId: widget.catId, stateId: widget.stateId, isPopular: widget.placesType == placesTypePopular).then((value) {
        appStore.setLoading(false);
        isLast = value.length < perPageLimit;
        placeList.addAll(value);
        setState(() {});
      }).catchError((error) {
        appStore.setLoading(false);
        throw error;
      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name)),
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
                              child: placesComponent(place, context, () {
                                appStore.addRemoveFavouriteData(context, place.id.validate());
                                setState(() {});
                              }, width: context.width()),
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
