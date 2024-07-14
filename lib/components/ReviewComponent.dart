import 'package:cloud_firestore/cloud_firestore.dart';
import '../main.dart';
import '../models/UserModel.dart';
import '../screens/LogInScreen.dart';
import '../utils/Common.dart';
import '../utils/Extensions/Commons.dart';
import '../utils/Extensions/Widget_extensions.dart';
import '../utils/Extensions/int_extensions.dart';
import '../utils/Extensions/shared_pref.dart';
import '../utils/Extensions/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../models/PlaceModel.dart';
import '../models/ReviewModel.dart';
import '../utils/AppColor.dart';
import '../utils/AppConstant.dart';
import '../utils/Extensions/Constants.dart';
import '../utils/Extensions/decorations.dart';
import '../utils/Extensions/text_styles.dart';
import 'WriteReviewBottomSheet.dart';

class ReviewComponent extends StatefulWidget {
  final PlaceModel place;

  ReviewComponent({required this.place});

  @override
  ReviewComponentState createState() => ReviewComponentState();
}

class ReviewComponentState extends State<ReviewComponent> {
  List<ReviewModel> reviewList = [];
  ScrollController _scrollController = ScrollController();

  bool isLast = true;

  int filterRatingLength = 6;
  int selectedRatingIndex = 0;
  bool isReviewExist = false;

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

  void init({double? rating}) async {
    appStore.setLoading(true);
    await reviewService.fetchReviewList(list: reviewList, placeId: widget.place.id, filterRating: rating).then((value) {
      appStore.setLoading(false);
      isLast = value.length < perPageLimit;
      reviewList.addAll(value);
      if (rating == null) {
        isReviewExist = reviewList.any((element) => element.userId == getStringAsync(USER_ID));
      }
      setState(() {});
    }).catchError((error) {
      appStore.setLoading(false);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return SingleChildScrollView(
        padding: EdgeInsets.only(top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Row(
                children: List.generate(filterRatingLength, (index) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: boxDecorationWithRoundedCornersWidget(
                      backgroundColor: selectedRatingIndex == index ? primaryColor.withOpacity(0.3) : Colors.transparent,
                      borderRadius: radius(defaultRadius),
                      border: Border.all(
                          color: selectedRatingIndex == index
                              ? primaryColor
                              : appStore.isDarkMode
                                  ? Colors.white12
                                  : Colors.black12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${index == 0 ? 'All' : '${filterRatingLength - index}'}', style: secondaryTextStyle(color: selectedRatingIndex == index ? primaryColor : null)),
                        6.width,
                        Icon(Icons.star_rate_sharp, size: 16, color: Colors.amber),
                      ],
                    ),
                  ).onTap(() {
                    selectedRatingIndex = index;
                    reviewList.clear();
                    init(rating: index == 0 ? null : (filterRatingLength - index).toDouble());
                  }).paddingRight(index != (6 - 1) ? 8 : 0);
                }),
              ),
            ),
            16.height,
            Align(
              alignment: Alignment.topRight,
              child: Text(language.writeAReview, style: boldTextStyle(color: primaryColor)).onTap(() {
                if (appStore.isLoggedIn) {
                  return showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: radiusCircular(30), topRight: radiusCircular(30))),
                    builder: (context) {
                      return WriteReviewBottomSheet(
                          place: widget.place,
                          onUpdate: () {
                            isReviewExist = true;
                            reviewList.clear();
                            init();
                          });
                    },
                  );
                } else {
                  LoginScreen().launch(context);
                }
              }).paddingRight(16),
            ).visible(!isReviewExist),
            Stack(
              children: [
                reviewList.isNotEmpty
                    ? ListView.separated(
                        padding: EdgeInsets.all(16),
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: reviewList.length,
                        itemBuilder: (context, index) {
                          ReviewModel mData = reviewList[index];
                          return StreamBuilder<DocumentSnapshot>(
                            stream: userService.documentById(mData.userId.validate()),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data!.data() != null) {
                                  UserModel user = UserModel.fromJson(snapshot.data!.data() as Map<String, dynamic>);
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(color: appStore.isDarkMode ? Colors.white70 : Colors.grey.withOpacity(0.5)),
                                            ),
                                            child: cachedImage(user.profileImg.validate(), fit: BoxFit.cover).cornerRadiusWithClipRRect(25),
                                          ),
                                          8.width,
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(user.name.validate(), style: boldTextStyle()),
                                              6.height,
                                              Text(mData.createdAt.toString(), style: secondaryTextStyle()),
                                            ],
                                          ),
                                          Spacer(),
                                          ratingWidget(mData.rating.validate()),
                                        ],
                                      ),
                                      8.height,
                                      Text(mData.comment.validate(), style: primaryTextStyle()),
                                    ],
                                  );
                                } else {
                                  return SizedBox();
                                }
                              } else if (snapshot.hasError) {
                                return errorWidget(text: snapshot.error.toString());
                              } else {
                                return SizedBox();
                              }
                            },
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(height: 24);
                        },
                      )
                    : !appStore.isLoading
                        ? emptyWidget()
                        : SizedBox(),
                loaderWidget().visible(appStore.isLoading),
              ],
            ),
          ],
        ),
      );
    });
  }
}
