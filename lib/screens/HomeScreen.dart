import '../main.dart';
import '../screens/ViewAllScreen.dart';
import '../utils/Common.dart';
import '../utils/Extensions/string_extensions.dart';
import 'package:geolocator/geolocator.dart';
import '../components/HomeCategoryWidget.dart';
import '../models/DashboardResponse.dart';
import '../models/PlaceModel.dart';
import '../utils/AppConstant.dart';
import '../utils/Extensions/HorizontalList.dart';
import '../utils/Extensions/Widget_extensions.dart';
import '../utils/Extensions/int_extensions.dart';
import 'package:flutter/material.dart';
import '../components/PlacesComponent.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchCont = TextEditingController();
  DashboardResponse? dashboardResponse;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    loadRewardedAds(onAdComplete: (){
      appStore.addFavourite(appStore.selectedPlaceId);
      setState(() {});
    });
    appStore.setLoading(true);
    await _getCurrentPosition().then((value) async {
      await placeService.getDashboardData(_currentPosition).then((value) {
        appStore.setLoading(false);
        dashboardResponse = value;
        setState(() {});
      }).catchError((e) {
        appStore.setLoading(false);
        throw e;
      });
    });
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await handleLocationPermission();  if (!hasPermission) return;
    await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
    }).catchError((e) {
      log(e.toString());
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return dashboardResponse != null
        ? ListView(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 0),
            children: [
              HomeCategoryWidget(dashboardResponse!.categoryPlaces ?? []),
              if ((dashboardResponse!.nearByPlaces ?? []).isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headingWidget(language.nearByPlaces, () {
                      ViewAllScreen(name: language.nearByPlaces,position: _currentPosition,placesType: placesTypeNearBy).launch(context);
                    }),
                    HorizontalList(
                        padding: EdgeInsets.all(16),
                        spacing: 12,
                        itemCount: dashboardResponse!.nearByPlaces!.length,
                        itemBuilder: (context, index) {
                          PlaceModel place = dashboardResponse!.nearByPlaces![index];
                          return placesComponent(place, context, () {
                            appStore.addRemoveFavouriteData(context, place.id.validate());
                            setState(() {});
                          });
                        })
                  ],
                ),
              4.height,
              if ((dashboardResponse!.latestPlaces ?? []).isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headingWidget(language.latestPlaces, () {
                      ViewAllScreen(name: language.latestPlaces).launch(context);
                    }),
                    HorizontalList(
                        padding: EdgeInsets.all(16),
                        spacing: 12,
                        itemCount: dashboardResponse!.latestPlaces!.length,
                        itemBuilder: (context, index) {
                          PlaceModel place = dashboardResponse!.latestPlaces![index];
                          return placesComponent(place, context, () {
                            appStore.addRemoveFavouriteData(context, place.id.validate());
                            setState(() {});
                          });
                        })
                  ],
                ),
              4.height,
              if ((dashboardResponse!.popularPlaces ?? []).isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headingWidget(language.popularPlaces, () {
                      ViewAllScreen(name: language.popularPlaces, placesType: placesTypePopular).launch(context);
                    }),
                    HorizontalList(
                        padding: EdgeInsets.all(16),
                        spacing: 12,
                        itemCount: dashboardResponse!.popularPlaces!.length,
                        itemBuilder: (context, index) {
                          PlaceModel place = dashboardResponse!.popularPlaces![index];
                          return placesComponent(place, context, () {
                            appStore.addRemoveFavouriteData(context, place.id.validate());
                            setState(() {});
                          });
                        })
                  ],
                )
            ],
          )
        : appStore.isLoading
            ? loaderWidget()
            : emptyWidget();
  }
}
