import '../screens/AddPlaceScreen.dart';
import '../screens/PlaceDetailScreen.dart';
import '../utils/Extensions/string_extensions.dart';
import '../services/FileStorageService.dart';
import '../utils/AppConstant.dart';
import '../utils/Common.dart';
import '../utils/Extensions/int_extensions.dart';
import '../main.dart';
import '../utils/Extensions/Widget_extensions.dart';
import '../utils/Extensions/context_extensions.dart';
import '../models/PlaceModel.dart';
import '../utils/AppColor.dart';
import '../utils/Extensions/Colors.dart';
import '../utils/Extensions/Constants.dart';
import '../utils/Extensions/decorations.dart';
import '../utils/Extensions/text_styles.dart';
import 'package:flutter/material.dart';

Widget placesComponent(PlaceModel place, BuildContext context, Function onTap, {width, bool isRequestPlace = false, Function()? onUpdate}) {
  deletePlace() async {
    appStore.setLoading(true);
    await requestPlaceService.removeDocument(place.id).then((value) async {
      await deleteFile(place.image.validate(), prefix: mPlacesStoragePath).then((value) {
        if ((place.secondaryImages ?? []).isNotEmpty) {
          Future.forEach(place.secondaryImages!, (element) async {
            await deleteFile(element.toString(), prefix: mPlacesStoragePath).then((value) {});
          }).then((value) {
            appStore.setLoading(false);
            onUpdate?.call();
          });
        } else {
          appStore.setLoading(false);
          onUpdate?.call();
        }
      }).catchError((e) {
        log(e);
      });
    }).catchError((e) {
      log(e);
    });
  }

  return GestureDetector(
    onTap: () {
      appStore.setSelectedPlaceId(place.id.validate());
      PlaceDetailScreen(placeData: place, isRequestPlace: isRequestPlace).launch(context);
    },
    child: Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        cachedImage(
          place.image.validate(),
          height: 180,
          width: width ?? context.width() * 0.7,
          fit: BoxFit.cover,
        ).cornerRadiusWithClipRRect(defaultRadius),
        Container(
          height: 180,
          width: width ?? context.width() * 0.7,
          decoration: BoxDecoration(
              borderRadius: radius(defaultRadius),
              border: Border.all(color: appStore.isDarkMode ? Colors.white.withOpacity(0.1) : Colors.transparent),
              gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                Colors.black.withOpacity(0.1),
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.5),
                Colors.black.withOpacity(0.7),
              ])),
        ),
        Positioned(
          left: 10,
          right: 10,
          top: 10,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ratingWidget((place.rating ?? 0).toDouble()),
              favouriteItemWidget(placeId: place.id.validate()).onTap((){
                appStore.setSelectedPlaceId(place.id.validate());
                onTap.call();
              }),
            ],
          ),
        ).visible(!isRequestPlace),
        Positioned(
          left: 10,
          right: 10,
          top: 10,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: radius(defaultRadius),
                ),
                padding: EdgeInsets.all(6),
                child: Icon(Icons.edit, color: Colors.white, size: 18),
              ).onTap(() {
                AddPlaceScreen(placeModel: place, onUpdate: onUpdate).launch(context);
              }),
              8.width,
              Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: radius(defaultRadius),
                ),
                padding: EdgeInsets.all(6),
                child: Icon(Icons.delete, color: Colors.white, size: 18),
              ).onTap(() {
                commonConfirmationDialog(context, message: language.deletePlaceRequestMsg, onUpdate: () async {
                  deletePlace();
                }, isDeleteDialog: true);
              }),
            ],
          ),
        ).visible(isRequestPlace),
        Positioned(
          left: 10,
          right: 10,
          bottom: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(place.name.toString().toUpperCase(), style: boldTextStyle(color: whiteColor, size: 18), maxLines: 2),
              6.height,
              Row(
                children: [
                  Icon(Icons.location_on_outlined, color: whiteColor, size: 20),
                  4.width,
                  Text(
                    place.address.validate(),
                    style: secondaryTextStyle(color: whiteColor),
                    maxLines: 2,
                  ).expand(),
                  8.width,
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: boxDecorationWithRoundedCornersWidget(backgroundColor: primaryColor.withOpacity(0.4), borderRadius: radius(defaultRadius)),
                    child: Icon(Icons.arrow_forward, size: 16, color: whiteColor),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    ),
  );
}
