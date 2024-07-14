import '../models/PlaceModel.dart';
import '../models/ReviewModel.dart';
import '../utils/Extensions/Widget_extensions.dart';
import '../utils/Extensions/context_extensions.dart';
import '../utils/Extensions/int_extensions.dart';
import '../utils/Extensions/shared_pref.dart';
import '../utils/Extensions/string_extensions.dart';
import '../utils/ModelKeys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../main.dart';
import '../utils/AppColor.dart';
import '../utils/AppConstant.dart';
import '../utils/Common.dart';
import '../utils/Extensions/AppButton.dart';
import '../utils/Extensions/AppTextField.dart';
import '../utils/Extensions/Colors.dart';
import '../utils/Extensions/Commons.dart';
import '../utils/Extensions/Constants.dart';
import '../utils/Extensions/decorations.dart';
import '../utils/Extensions/text_styles.dart';

class WriteReviewBottomSheet extends StatefulWidget {
  final PlaceModel place;
  final Function()? onUpdate;

  WriteReviewBottomSheet({required this.place, this.onUpdate});

  @override
  WriteReviewBottomSheetState createState() => WriteReviewBottomSheetState();
}

class WriteReviewBottomSheetState extends State<WriteReviewBottomSheet> {
  double initialRating = 0;
  TextEditingController reviewController = TextEditingController();

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

  Future<void> save() async {
    finish(context);
    appStore.setLoading(true);
    ReviewModel review = ReviewModel();
    review.userId = getStringAsync(USER_ID);
    review.rating = initialRating;
    review.comment = reviewController.text;
    review.createdAt = DateTime.now();
    review.updatedAt = DateTime.now();
    review.placeId = widget.place.id;
    await reviewService.addDocument(review.toJson()).then((value) async{
      appStore.setLoading(false);
      widget.onUpdate?.call();
      double rating = await reviewService.getPlaceRating(widget.place.id.validate());
      await placeService.updateDocument({PlaceKeys.rating: rating}, widget.place.id);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(language.whatIsYourRate, style: boldTextStyle(size: 18), textAlign: TextAlign.center),
                16.height,
                RatingBar(
                  initialRating: initialRating,
                  direction: Axis.horizontal,
                  itemPadding: EdgeInsets.all(6),
                  itemCount: 5,
                  itemSize: 40,
                  onRatingUpdate: (rating) {
                    initialRating = rating;
                    setState(() {});
                  },
                  ratingWidget: RatingWidget(
                    full: Icon(Icons.star, color: Colors.amber),
                    empty: Icon(Icons.star_border, color: Colors.grey),
                    half: Icon(Icons.star_half, color: Colors.amber),
                  ),
                ),
                30.height,
                Text(language.rateSubtext, style: boldTextStyle(size: 18), textAlign: TextAlign.center),
                16.height,
                AppTextField(
                  controller: reviewController,
                  textFieldType: TextFieldType.ADDRESS,
                  decoration: commonInputDecoration(hintText: language.yourReview),
                  minLines: 4,
                ),
                30.height,
                AppButtonWidget(
                  text: language.sendReview,
                  textStyle: boldTextStyle(color: whiteColor),
                  shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultRadius)),
                  color: primaryColor,
                  onTap: () {
                    if (initialRating == 0) return toast(language.pleaseFillRating);
                    if (reviewController.text.isEmpty) return toast(language.pleaseWriteReview);
                    save();
                  },
                  width: context.width(),
                ),
              ],
            ).paddingAll(16),
          ),
        ).onTap(() {
          hideKeyboard(context);
        }),
        Observer(builder: (context) => loaderWidget().visible(appStore.isLoading)),
      ],
    );
  }
}
