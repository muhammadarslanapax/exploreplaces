import 'dart:io';
import '../components/SendNotification.dart';
import '../utils/Extensions/Commons.dart';
import '../utils/Extensions/Widget_extensions.dart';
import '../utils/Extensions/int_extensions.dart';
import '../utils/Extensions/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:image_picker/image_picker.dart';
import '../main.dart';
import '../models/CategoryModel.dart';
import '../models/PlaceModel.dart';
import '../models/StateModel.dart';
import '../services/FileStorageService.dart';
import '../utils/AppColor.dart';
import '../utils/AppConstant.dart';
import '../utils/Common.dart';
import '../utils/Extensions/AppButton.dart';
import '../utils/Extensions/AppTextField.dart';
import '../utils/Extensions/Constants.dart';
import '../utils/Extensions/decorations.dart';
import '../utils/Extensions/shared_pref.dart';
import '../utils/Extensions/text_styles.dart';
import 'GoogleMapScreen.dart';

class AddPlaceScreen extends StatefulWidget {
  final PlaceModel? placeModel;
  final Function()? onUpdate;

  AddPlaceScreen({this.placeModel,this.onUpdate});

  @override
  AddPlaceScreenState createState() => AddPlaceScreenState();
}

class AddPlaceScreenState extends State<AddPlaceScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController placeNameController = TextEditingController();
  TextEditingController placeAddressController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  List<CategoryModel> categoryList = [];
  List<StateModel> stateList = [];
  String? categoryId;
  String? stateId;

  XFile? primaryImage;
  List<XFile> secondaryImages = [];

  bool isUpdate = false;
  int status = 1;

  LatLng? latLng;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    categoryList = await categoryService.getCategories();
    stateList = await stateService.getStatesFuture();
    isUpdate = widget.placeModel != null;
    if (isUpdate) {
      placeNameController.text = widget.placeModel!.name.validate();
      status = widget.placeModel!.status.validate();
      if (categoryList.any((element) => element.id == widget.placeModel!.categoryId)) {
        categoryId = widget.placeModel!.categoryId.validate();
      }
      if (stateList.any((element) => element.id == widget.placeModel!.stateId)) {
        stateId = widget.placeModel!.stateId.validate();
      }
      placeAddressController.text = widget.placeModel!.address.validate();
      latLng = LatLng(widget.placeModel!.latitude.validate(), widget.placeModel!.longitude.validate());
      descriptionController.text = widget.placeModel!.description.validate();
    }
    setState(() {});
  }

  Future<void> save() async {
    appStore.setLoading(true);
    PlaceModel placeModel = PlaceModel();

    placeModel.userId = getStringAsync(USER_ID);
    placeModel.name = placeNameController.text.trim();
    placeModel.updatedAt = DateTime.now();
    placeModel.status = status;
    placeModel.address = placeAddressController.text.trim();
    placeModel.latitude = double.parse(latLng!.latitude.toStringAsFixed(5));
    placeModel.longitude = double.parse(latLng!.longitude.toStringAsFixed(5));
    placeModel.categoryId = categoryId;
    placeModel.stateId = stateId;
    placeModel.caseSearch = placeNameController.text.trim().setSearchParam();
    placeModel.description = descriptionController.text.trim();
    placeModel.favourites = 0;
    placeModel.rating = 0;

    if (isUpdate) {
      placeModel.id = widget.placeModel!.id;
      placeModel.createdAt = widget.placeModel!.createdAt;
      placeModel.image = widget.placeModel!.image;
      placeModel.secondaryImages = widget.placeModel!.secondaryImages;
      placeModel.favourites = widget.placeModel!.favourites ?? 0;
      placeModel.rating = widget.placeModel!.rating ?? 0;
    } else {
      placeModel.createdAt = DateTime.now();
    }

    if (primaryImage != null) {
      await uploadFile(bytes: await primaryImage!.readAsBytes(), prefix: mPlacesStoragePath).then((path) async {
        placeModel.image = path;
      }).catchError((e) {
        toast(e.toString());
      });
    }

    if (secondaryImages.isNotEmpty) {
      List<String> list = [];
      Future.forEach(secondaryImages, (XFile element) async {
        await uploadFile(bytes:await element.readAsBytes(), prefix: mPlacesStoragePath).then((path) async {
          list.add(path);
        }).catchError((e) {
          toast(e.toString());
        });
      }).then((value) async {
        placeModel.secondaryImages = list;
        await addPlace(placeModel);
      });
    } else {
      await addPlace(placeModel);
    }
  }

  Future addPlace(PlaceModel placeModel) async {
    if (isUpdate) {
      await requestPlaceService.updateDocument(placeModel.toJson(), placeModel.id).then((value) {
        appStore.setLoading(false);
        finish(context);
        toast(language.placeUpdated);
        widget.onUpdate?.call();
      }).catchError((e) {
        appStore.setLoading(false);
        toast(e.toString());
      });
    } else {
      await requestPlaceService.addDocument(placeModel.toJson()).then((value) async {
        appStore.setLoading(false);
        finish(context);
        toast(language.placeAdded);
        widget.onUpdate?.call();
         if (getBoolAsync(IS_NOTIFICATION_ON, defaultValue: defaultIsNotificationOn)) {
           await userService.getUsers().then((value) {
             if(value.isNotEmpty){
               value.forEach((element) {
                 if(element.fcmToken!=null && element.fcmToken!.isNotEmpty){
                   String catName = categoryList.firstWhere((element) => element.id == placeModel.categoryId).name ?? "";
                   sendPushMessageToWeb(element.fcmToken!,placeModel.name.validate(),catName);
                 }
               });
             }
           }).catchError((e){
             log(e);
           });
         }
      }).catchError((e) {
        appStore.setLoading(false);
        toast(e.toString());
      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Widget getPrimaryImage() {
    if (primaryImage != null) {
      return Image.file(File(primaryImage!.path), height: 100, width: 100, fit: BoxFit.cover, alignment: Alignment.center);
    } else if (isUpdate && widget.placeModel!.image.validate().isNotEmpty) {
      return cachedImage(widget.placeModel!.image.validate(), height: 100, width: 100, fit: BoxFit.cover, alignment: Alignment.center);
    } else {
      return SizedBox(height: 100);
    }
  }

  Widget getSecondaryImages() {
    if (secondaryImages.isNotEmpty) {
      return Wrap(
        spacing: 16,
        runSpacing: 16,
        children: secondaryImages.map((image) {
          return Stack(
            children: [
              Image.file(File(image.path), height: 100, width: 100, fit: BoxFit.cover, alignment: Alignment.center),
              Positioned(
                top: 8,
                right: 8,
                child: Icon(Icons.highlight_remove, color: Colors.white).onTap(() {
                  secondaryImages.remove(image);
                  setState(() {});
                }),
              )
            ],
          );
        }).toList(),
      );
    } else if (isUpdate && (widget.placeModel!.secondaryImages ?? []).isNotEmpty) {
      return Wrap(
        spacing: 16,
        runSpacing: 16,
        children: widget.placeModel!.secondaryImages!.map((image) {
          return Stack(
            children: [
              cachedImage(image, height: 100, width: 100, fit: BoxFit.cover, alignment: Alignment.center),
              Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(Icons.highlight_remove, color: Colors.white).onTap(() async {
                    widget.placeModel!.secondaryImages!.remove(image);
                    setState(() {});
                  })),
            ],
          );
        }).toList(),
      );
    } else {
      return SizedBox(height: 100);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(language.requestNewPlace)),
      body: Stack(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            controller: ScrollController(),
            padding: EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(language.placeName, style: primaryTextStyle()),
                  8.height,
                  AppTextField(
                    controller: placeNameController,
                    autoFocus: false,
                    textFieldType: TextFieldType.NAME,
                    keyboardType: TextInputType.name,
                    errorThisFieldRequired: errorThisFieldRequired,
                    decoration: commonInputDecoration(hintText: language.placeName),
                  ),
                  16.height,
                  Text(language.category, style: primaryTextStyle()),
                  8.height,
                  categoryList.isNotEmpty
                      ? DropdownButtonFormField<String>(
                          dropdownColor: Theme.of(context).cardColor,
                          value: categoryId,
                          decoration: commonInputDecoration(),
                          items: categoryList.map<DropdownMenuItem<String>>((item) {
                            return DropdownMenuItem(
                              value: item.id,
                              child: Text(item.name.validate(), style: primaryTextStyle()),
                            );
                          }).toList(),
                          onChanged: (value) {
                            categoryId = value!;
                            setState(() {});
                          },
                          validator: (s) {
                            if (s == null) return errorThisFieldRequired;
                            return null;
                          },
                        )
                      : Text(language.noDataFound, style: primaryTextStyle(size: 14)),
                  16.height,
                  Text(language.state, style: primaryTextStyle()),
                  8.height,
                  stateList.isNotEmpty
                      ? DropdownButtonFormField<String>(
                          dropdownColor: Theme.of(context).cardColor,
                          value: stateId,
                          decoration: commonInputDecoration(),
                          items: stateList.map<DropdownMenuItem<String>>((item) {
                            return DropdownMenuItem(
                              value: item.id,
                              child: Text(item.name.validate(), style: primaryTextStyle(size: 14)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            stateId = value!;
                            setState(() {});
                          },
                          validator: (s) {
                            if (s == null) return errorThisFieldRequired;
                            return null;
                          },
                        )
                      : Text(language.noDataFound, style: primaryTextStyle()),
                  16.height,
                  Text(language.placeAddress, style: primaryTextStyle()),
                  8.height,
                  AppTextField(
                    controller: placeAddressController,
                    autoFocus: false,
                    maxLines: 3,
                    minLines: 3,
                    readOnly: true,
                    textFieldType: TextFieldType.ADDRESS,
                    keyboardType: TextInputType.streetAddress,
                    textInputAction: TextInputAction.next,
                    errorThisFieldRequired: errorThisFieldRequired,
                    decoration: commonInputDecoration(hintText: language.placeAddress),
                    onTap: () async {
                      PickResult? result = await GoogleMapScreen().launch(context);
                      if(result!=null) {
                        placeAddressController.text = result.formattedAddress.validate();
                        latLng = LatLng(result.geometry!.location.lat.validate(), result.geometry!.location.lng.validate());
                        setState(() {});
                      }
                    },
                  ),
                  16.height,
                  Text(language.description, style: primaryTextStyle()),
                  8.height,
                  AppTextField(
                    controller: descriptionController,
                    autoFocus: false,
                    maxLines: 5,
                    minLines: 5,
                    textFieldType: TextFieldType.OTHER,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    errorThisFieldRequired: errorThisFieldRequired,
                    decoration: commonInputDecoration(hintText: language.description),
                  ),
                  16.height,
                  Text(language.primaryImage, style: primaryTextStyle()),
                  8.height,
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: radius(defaultRadius),
                      color: Colors.grey.withOpacity(0.1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AppButtonWidget(
                              child: Text(language.browse, style: primaryTextStyle(color: Colors.white)),
                              color: primaryColor.withOpacity(0.5),
                              hoverColor: primaryColor,
                              splashColor: primaryColor,
                              focusColor: primaryColor,
                              elevation: 0,
                              onTap: () async {
                                primaryImage = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 100);
                                setState(() {});
                              },
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            ),
                            16.width,
                            Text(language.clear, style: primaryTextStyle(decoration: TextDecoration.underline)).onTap(() async {
                              if (primaryImage != null) {
                                primaryImage = null;
                              } else if (isUpdate && widget.placeModel!.image != null) {
                                widget.placeModel!.image = null;
                                setState(() {});
                              }
                              setState(() {});
                            }),
                          ],
                        ),
                        8.height,
                        getPrimaryImage(),
                      ],
                    ),
                  ),
                  16.height,
                  Text(language.secondaryImages, style: primaryTextStyle()),
                  8.height,
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: radius(defaultRadius),
                      color: Colors.grey.withOpacity(0.1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AppButtonWidget(
                              child: Text(language.browse, style: primaryTextStyle(color: Colors.white)),
                              elevation: 0,
                              color: primaryColor.withOpacity(0.5),
                              hoverColor: primaryColor,
                              splashColor: primaryColor,
                              focusColor: primaryColor,
                              onTap: () async {
                                secondaryImages = await ImagePicker().pickMultiImage(imageQuality: 100) ?? [];
                                setState(() {});
                              },
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            ),
                            16.width,
                            Text(language.clear, style: primaryTextStyle(decoration: TextDecoration.underline)).onTap(() async {
                              if (secondaryImages.isNotEmpty) {
                                secondaryImages = [];
                                setState(() {});
                              } else if (isUpdate && widget.placeModel!.secondaryImages != null) {
                                widget.placeModel!.secondaryImages = [];
                                setState(() {});
                              }
                            }),
                          ],
                        ),
                        8.height,
                        getSecondaryImages(),
                      ],
                    ),
                  ),
                  24.height,
                  Align(
                      alignment: Alignment.center,
                      child: dialogPrimaryButton(language.save, () {
                        if (formKey.currentState!.validate()) {
                          if(latLng==null) return toast(language.enterValidAddress);
                          if (primaryImage != null || (isUpdate && widget.placeModel!.image != null)) {
                            save();
                          } else {
                            toast(language.selectPrimaryImage);
                          }
                        }
                      }))
                ],
              ),
            ),
          ),
          Observer(builder: (context) => loaderWidget().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
