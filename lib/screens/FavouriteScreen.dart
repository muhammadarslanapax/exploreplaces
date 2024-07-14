import '../utils/Extensions/string_extensions.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../main.dart';
import '../models/PlaceModel.dart';
import '../utils/Common.dart';
import '../utils/Extensions/Widget_extensions.dart';
import '../utils/Extensions/context_extensions.dart';
import '../components/PlacesComponent.dart';
import 'package:flutter/material.dart';

class FavouriteScreen extends StatefulWidget {
  static String tag = '/SavedScreen';

  @override
  FavouriteScreenState createState() => FavouriteScreenState();
}

class FavouriteScreenState extends State<FavouriteScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Scaffold(
        body: FutureBuilder<List<PlaceModel>>(
          future: placeService.getFavouritePlaces(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if ((snapshot.data ?? []).isEmpty) return emptyWidget(text: language.noItemsInFavourite);
              return ListView.builder(
                shrinkWrap: true,
                itemCount: (snapshot.data ?? []).length,
                padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                itemBuilder: (_, index) {
                  PlaceModel place = (snapshot.data ?? [])[index];
                  return AnimationConfiguration.staggeredList(
                    duration: Duration(milliseconds: 800),
                    position: index,
                    child: SlideAnimation(
                      horizontalOffset: 50.0,
                      verticalOffset: 20.0,
                      child: FadeInAnimation(
                        child: placesComponent(place, context, () {
                          appStore.addRemoveFavouriteData(context, place.id.validate());
                        }, width: context.width())
                            .paddingBottom(16),
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return errorWidget(text: snapshot.error.toString());
            } else {
              return loaderWidget();
            }
          },
        ),
      );
    });
  }
}
