import 'dart:convert';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

import '../utils/Extensions/Commons.dart';
import '../utils/Extensions/string_extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../main.dart';
import '../models/UserModel.dart';
import '../utils/AppConstant.dart';
import '../utils/Common.dart';
import '../utils/Extensions/Constants.dart';
import '../utils/Extensions/Widget_extensions.dart';
import '../utils/Extensions/shared_pref.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();

Future<void> signInWithGoogle() async {
  GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

  if (googleSignInAccount != null) {
    //region Google Sign In
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult = await auth.signInWithCredential(credential);
    final User user = authResult.user!;

    assert(!user.isAnonymous);

    final User currentUser = auth.currentUser!;
    assert(user.uid == currentUser.uid);

    signOutGoogle();
    //endregion

    await loginFromFirebaseUser(user, LoginTypeGoogle);
  } else {
    throw errorSomethingWentWrong;
  }
}

Future<UserModel> signInWithEmail(String email, String password) async {
  if (await userService.isUserExist(email, LoginTypeApp)) {
    UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);

    if (userCredential.user != null) {
      UserModel userModel = UserModel();

      User user = userCredential.user!;

      return await userService.userByEmail(user.email).then((value) async {
        userModel = value;

        await setValue(USER_PASSWORD, password);
        await setValue(LOGIN_TYPE, LoginTypeApp);
        //
        // await updateUserData(userModel);
        //
        await setUserDetailPreference(userModel);

        return userModel;
      }).catchError((e) {
        throw e;
      });
    } else {
      throw errorSomethingWentWrong;
    }
  } else {
    throw 'You are not registered with us';
  }
}

Future<void> signUpWithEmail({required String name, required String email, required String password, required String contactNo}) async {
  UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);

  if (userCredential.user != null) {
    User currentUser = userCredential.user!;
    UserModel userModel = UserModel();

    /// Create user
    userModel.id = currentUser.uid;
    userModel.email = currentUser.email;
    userModel.name = name;
    userModel.profileImg = '';
    userModel.contactNo = contactNo;
    userModel.loginType = LoginTypeApp;
    userModel.updatedAt = DateTime.now();
    userModel.createdAt = DateTime.now();

    userModel.isAdmin = false;
    userModel.isDemoAdmin = false;

    await userService.addDocumentWithCustomId(currentUser.uid, userModel.toJson()).then((value) async {
      log('Signed up');
      await signInWithEmail(email, password).then((value) {
        //
      });
    }).catchError((e) {
      throw e;
    });
  } else {
    throw errorSomethingWentWrong;
  }
}

Future<void> changePassword(String newPassword) async {
  await auth.currentUser!.updatePassword(newPassword).then((value) async {
    await setValue(USER_PASSWORD, newPassword);
  });
}

Future<void> setUserDetailPreference(UserModel userModel) async {
  await setValue(USER_ID, userModel.id);
  await setValue(USER_NAME, userModel.name);
  await setValue(USER_EMAIL, userModel.email);
  await setValue(USER_PROFILE, userModel.profileImg.validate());
  await setValue(IS_ADMIN, userModel.isAdmin.validate());
  await setValue(USER_CONTACT_NO, userModel.contactNo.validate());
  appStore.setProfileImg(userModel.profileImg.validate());
  if (userModel.favouritePlacesList != null) {
    await setValue(FAVOURITE_LIST, jsonEncode(userModel.favouritePlacesList));
    appStore.addAllFavouriteItem(userModel.favouritePlacesList!.map<String>((e) => e.toString()).toList());
  }
  appStore.setLoggedIn(true);
}

Future<void> logout(BuildContext context) async {
  await removeKey(USER_ID);
  await removeKey(USER_NAME);
  await removeKey(USER_PROFILE);
  await removeKey(IS_ADMIN);
  await removeKey(FAVOURITE_LIST);

  if (isLoggedInWithGoogle() || !getBoolAsync(IS_REMEMBERED)) {
    await removeKey(USER_EMAIL);
    await removeKey(USER_PASSWORD);
  }

  appStore.favouriteList.clear();
  appStore.setProfileImg('');
  appStore.setLoggedIn(false);
  finish(context);
}

Future<void> signOutGoogle() async {
  await googleSignIn.signOut();
}

Future<void> loginWithOTP(BuildContext context, String phoneNumber) async {
  return await auth.verifyPhoneNumber(
    phoneNumber: phoneNumber,
    verificationCompleted: (PhoneAuthCredential credential) async {
      //finish(context);
      //await showInDialog(context, child: OTPDialog(isCodeSent: true, phoneNumber: phoneNumber, credential: credential), backgroundColor: Colors.black);
    },
    verificationFailed: (FirebaseAuthException e) {
      if (e.code == 'invalid-phone-number') {
        toast('The provided phone number is not valid.');
        throw 'The provided phone number is not valid.';
      } else {
        toast(e.toString());
        throw e.toString();
      }
    },
    codeSent: (String verificationId, int? resendToken) async {
      finish(context);
      //await showInDialog(context, child: OTPDialog(verificationId: verificationId, isCodeSent: true, phoneNumber: phoneNumber), barrierDismissible: false);
    },
    codeAutoRetrievalTimeout: (String verificationId) {
      //
    },
  );
}

Future<void> loginFromFirebaseUser(User currentUser, String loginType, {String? fullName}) async {
  UserModel userModel = UserModel();

  if (await userService.isUserExist(currentUser.email, loginType)) {
    //
    ///Return user data
    await userService.userByEmail(currentUser.email).then((user) async {
      userModel = user;

      //await updateUserData(userModel);
    }).catchError((e) {
      throw e;
    });
  } else {
    /// Create user
    userModel.id = currentUser.uid;
    userModel.email = currentUser.email;
    userModel.name = (currentUser.displayName) ?? fullName;
    userModel.profileImg = currentUser.photoURL;
    userModel.contactNo = "";
    userModel.loginType = loginType;
    userModel.updatedAt = DateTime.now();
    userModel.createdAt = DateTime.now();

    userModel.isAdmin = false;
    userModel.isDemoAdmin = false;

    await userService.addDocumentWithCustomId(currentUser.uid, userModel.toJson()).then((value) {
      //
    }).catchError((e) {
      throw e;
    });
  }

  await setValue(LOGIN_TYPE, loginType);
  setUserDetailPreference(userModel);
}

/// Sign-In with Apple.
Future<void> appleLogIn() async {
  if (await TheAppleSignIn.isAvailable()) {
    AuthorizationResult result = await TheAppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);
    switch (result.status) {
      case AuthorizationStatus.authorized:
        final appleIdCredential = result.credential!;
        final oAuthProvider = OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken!),
          accessToken: String.fromCharCodes(appleIdCredential.authorizationCode!),
        );
        final authResult = await auth.signInWithCredential(credential);
        final user = authResult.user!;

        if (result.credential!.email != null) {
          await saveAppleData(result);
        }

        await loginFromFirebaseUser(
          user,
          LoginTypeApple,
          fullName: '${getStringAsync('appleGivenName')} ${getStringAsync('appleFamilyName')}',
        );
        break;
      case AuthorizationStatus.error:
        throw ("Sign in failed: ${result.error!.localizedDescription}");
      case AuthorizationStatus.cancelled:
        throw ('User cancelled');
    }
  } else {
    throw ('Apple SignIn is not available for your device');
  }
}


Future<void> saveAppleData(AuthorizationResult result) async {
  await setValue('appleEmail', result.credential!.email);
  await setValue('appleGivenName', result.credential!.fullName!.givenName);
  await setValue('appleFamilyName', result.credential!.fullName!.familyName);
}

Future deleteUser(String email, String password) async {
  if(FirebaseAuth.instance.currentUser != null) {
    FirebaseAuth.instance.currentUser!.delete();
    await FirebaseAuth.instance.signOut();
  }
}