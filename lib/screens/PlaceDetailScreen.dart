import '../models/PlaceModel.dart';
import '../utils/Common.dart';
import '../utils/Extensions/Commons.dart';
import '../utils/Extensions/Widget_extensions.dart';
import '../utils/Extensions/context_extensions.dart';
import '../utils/Extensions/int_extensions.dart';
import '../utils/Extensions/string_extensions.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import '../components/GalleryComponent.dart';
import '../components/HistoryComponent.dart';
import '../components/ReviewComponent.dart';
import '../main.dart';
import '../utils/AppColor.dart';
import '../utils/Extensions/Colors.dart';
import '../utils/Extensions/text_styles.dart';

class PlaceDetailScreen extends StatefulWidget {
  final PlaceModel? placeData;
  final String? placeId;
  final bool isRequestPlace;

  PlaceDetailScreen({this.placeData, this.placeId, this.isRequestPlace = false});

  @override
  PlaceDetailScreenState createState() => PlaceDetailScreenState();
}

class PlaceDetailScreenState extends State<PlaceDetailScreen> {
  int i = 0;
  PlaceModel? placeModel;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    FacebookAudienceNetwork.init();
    loadInterstitialAds();
    loadRewardedAds(onAdComplete: () {
      appStore.addFavourite(appStore.selectedPlaceId);
      setState(() {});
    });
    setStatusBarColorWidget(Colors.transparent, statusBarIconBrightness: Brightness.dark);
    if (widget.placeData != null) {
      placeModel = widget.placeData;
      setState(() {});
    } else {
      await placeService.documentByIdFuture(widget.placeId!).then((event) {
        if (event.data() != null) {
          placeModel = PlaceModel.fromJson(event.data() as Map<String, dynamic>);
          setState(() {});
        }
      }).catchError((e) {
        throw e;
      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    showInterstitialAds();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return placeModel != null
        ? DefaultTabController(
            length: 3,
            child: Scaffold(
              body: NestedScrollView(
                floatHeaderSlivers: true,
                physics: NeverScrollableScrollPhysics(),
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      pinned: true,
                      floating: true,
                      expandedHeight: context.height() * 0.4,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Stack(
                          fit: StackFit.expand,
                          children: [
                            Stack(
                              fit: StackFit.expand,
                              children: [
                                cachedImage(
                                  placeModel!.image.validate(),
                                  fit: BoxFit.cover,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                                    Colors.black.withOpacity(0.1),
                                    Colors.black.withOpacity(0.1),
                                    Colors.black.withOpacity(0.3),
                                    Colors.black.withOpacity(0.9),
                                  ])),
                                ),
                              ],
                            ),
                            Positioned(
                              bottom: 16,
                              left: 16,
                              right: 16,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ratingWidget((placeModel!.rating ?? 0).toDouble()).visible(!widget.isRequestPlace),
                                  12.height,
                                  Text(
                                    placeModel!.name.toString().toUpperCase(),
                                    style: boldTextStyle(color: whiteColor, size: 20),
                                    maxLines: 3,
                                  ),
                                  12.height,
                                  Row(
                                    children: [
                                      Icon(Icons.location_on_outlined, color: whiteColor, size: 20),
                                      4.width,
                                      Text(placeModel!.address.validate(), style: primaryTextStyle(color: whiteColor)).expand(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      leading: Icon(Icons.arrow_back, color: innerBoxIsScrolled ? null : Colors.white).onTap(() {
                        finish(context);
                      }),
                      actions: [
                        GestureDetector(
                            onTap: () {
                              appStore.setSelectedPlaceId(placeModel!.id.validate());
                              appStore.addRemoveFavouriteData(context, placeModel!.id.validate());
                              setState(() {});
                            },
                            child: favouriteItemWidget(
                              placeId: placeModel!.id!,
                              color: innerBoxIsScrolled ? Colors.black : Colors.white,
                            ).paddingRight(16).visible(!widget.isRequestPlace)),
                      ],
                    ),
                  ];
                },
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TabBar(
                      tabs: [
                        Tab(text: language.history),
                        Tab(text: language.gallery),
                        Tab(text: language.review).visible(!widget.isRequestPlace),
                      ],
                      isScrollable: true,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorColor: primaryColor,
                      labelStyle: boldTextStyle(),
                      unselectedLabelStyle: primaryTextStyle(),
                    ),
                    TabBarView(children: [
                      HistoryComponent(description: placeModel!.description.validate()),
                      GalleryComponent(place: placeModel!),
                      ReviewComponent(place: placeModel!).visible(!widget.isRequestPlace),
                    ]).expand(),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                mini: true,
                backgroundColor: primaryColor,
                child: Icon(Icons.location_pin, color: Colors.white),
                onPressed: () {
                  MapsLauncher.launchCoordinates(placeModel!.latitude.validate(), placeModel!.longitude.validate());
                },
              ),
            ),
          )
        : loaderWidget();
  }
}
