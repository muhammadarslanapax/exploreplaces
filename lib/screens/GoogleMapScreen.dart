import '../utils/AppConstant.dart';
import '../utils/Extensions/Commons.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';

import '../main.dart';

class GoogleMapScreen extends StatefulWidget {
  static final kInitialPosition = LatLng(-33.8567844, 151.213108);

  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  PickResult? selectedPlace;
  bool showPlacePickerInContainer = false;
  bool showGoogleMapInContainer = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(language.pickPlace),
      ),
      body: PlacePicker(
        apiKey: googleMapApiKey,
        hintText: language.findAPlace,
        searchingText: language.pleaseWait,
        selectText: language.selectPlace,
        outsideOfPickAreaText: language.placeNotInArea,
        initialPosition: GoogleMapScreen.kInitialPosition,
        useCurrentLocation: true,
        selectInitialPosition: true,
        usePinPointingSearch: true,
        usePlaceDetailSearch: true,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: true,
        automaticallyImplyAppBarLeading: false,
        onMapCreated: (GoogleMapController controller) {
          //
        },
        onPlacePicked: (PickResult result) {
          setState(() {
            selectedPlace = result;
            finish(context, selectedPlace);
          });
        },
        onMapTypeChanged: (MapType mapType) {
          //
        },
      ),
    );
  }
}
