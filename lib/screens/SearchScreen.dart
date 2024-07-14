import '../utils/Extensions/Widget_extensions.dart';
import '../utils/Extensions/context_extensions.dart';
import '../utils/Extensions/string_extensions.dart';
import 'package:flutter/material.dart';
import '../components/PlacesComponent.dart';
import '../main.dart';
import '../models/PlaceModel.dart';
import '../utils/Common.dart';
import '../utils/Extensions/AppTextField.dart';
import '../utils/Extensions/text_styles.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchCont = TextEditingController();

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
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppTextField(
          controller: searchCont,
          textFieldType: TextFieldType.OTHER,
          autoFocus: true,
          decoration: InputDecoration(hintText: language.searchPlaces, hintStyle: primaryTextStyle(), border: InputBorder.none),
          onChanged: (v) {
            setState(() {});
          },
          onFieldSubmitted: (c) {},
        ),
        elevation: 2,
      ),
      body: FutureBuilder<List<PlaceModel>>(
        future: placeService.searchPlaces(searchCont.text),
        builder: (_, snap) {
          if (snap.hasData) {
            if (snap.data!.isEmpty) return emptyWidget();
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snap.data!.length,
              padding: EdgeInsets.only(left: 16, top: 16, right: 16),
              itemBuilder: (_, index) {
                PlaceModel place = snap.data![index];
                return placesComponent(
                  place,
                  context,
                  () {
                    appStore.addRemoveFavouriteData(context, place.id.validate());
                    setState(() {});
                  },
                  width: context.width(),
                ).paddingBottom(16);
              },
            );
          } else {
            return snapWidgetHelper(snap,loadingWidget: loaderWidget(),errorWidget: errorWidget());
          }
        },
      ),
    );
  }
}
