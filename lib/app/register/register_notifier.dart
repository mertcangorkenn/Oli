import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:listing/app/register/register_state.dart';
import 'package:listing/infrastructure/service/app_connectivity.dart';
import 'package:listing/infrastructure/service/app_helpers.dart';
import 'package:listing/infrastructure/service/app_validators.dart';
import 'package:listing/infrastructure/service/local_storage.dart';
import 'package:listing/presentation/routes/app_router.gr.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class RegisterNotifier extends StateNotifier<RegisterState> {
  RegisterNotifier() : super(const RegisterState());

  void setUsername(String username) {
    state = state.copyWith(username: username.trim(), isUsernameInvalid: false);
  }

  void setFullname(String fullname) {
    state = state.copyWith(fullname: fullname.trim());
  }

  void setEmail(String value) {
    state = state.copyWith(email: value.trim(), isEmailInvalid: false);
  }

  void setPassword(String password) {
    state = state.copyWith(password: password.trim(), isPasswordInvalid: false);
  }

  void toggleShowPassword() {
    state = state.copyWith(showPassword: !state.showPassword);
  }

  bool checkEmail() {
    return AppValidators.isValidEmail(state.email);
  }

  bool checkUsername() {
    return AppValidators.isValidUsername(state.username) &&
        !state.isUsernameInvalid;
  }

  Future<void> register(BuildContext context) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      if (!AppValidators.isValidPassword(state.password)) {
        state = state.copyWith(isPasswordInvalid: true);
        return;
      }

      if (!AppValidators.isValidUsername(state.username)) {
        state = state.copyWith(isUsernameInvalid: true);
        return;
      }

      state = state.copyWith(isLoading: true);
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: state.email,
          password: state.password,
        );

        User? user = userCredential.user;

        if (user != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'fullname': state.fullname,
            'username': state.username,
            'email': state.email,
            'id': user.uid,
            'avatar': '',
            'phonenumber': '',
            'bio': '',
            'gender': '-',
            'birthday': '-',
            'created': DateTime.now(),
            'holidaymode': false,
          });

          state = state.copyWith(isLoading: false);
          // ignore: use_build_context_synchronously
          context.replaceRoute(const MainRoute());
          LocalStorage.setToken(user.uid);
        }
      } catch (e) {
        state = state.copyWith(isLoading: false);
        // ignore: use_build_context_synchronously
        AppHelpers.showCheckTopSnackBar(context, e.toString());
      }
    } else {
      if (mounted) {
        // ignore: use_build_context_synchronously
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  Future<void> loginWithGoogle(BuildContext context) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isLoading: true);
      GoogleSignInAccount? googleUser;
      try {
        googleUser = await GoogleSignIn().signIn();
      } catch (e) {
        state = state.copyWith(isLoading: false);
        if (kDebugMode) {
          print('Google sign in error: $e');
        }
        return;
      }
      if (googleUser == null) {
        state = state.copyWith(isLoading: false);
        return;
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'fullname': user.displayName ?? "-",
          'username': user.displayName,
          'email': user.email,
          'id': user.uid,
          'avatar': user.photoURL ?? '',
          'phonenumber': user.phoneNumber ?? '-',
          'bio': '',
          'gender': '-',
          'birthday': '-',
          'created': DateTime.now(),
          'holidaymode': false,
        });

        state = state.copyWith(isLoading: false);
        // ignore: use_build_context_synchronously
        context.replaceRoute(const SelectUsernameRoute());
        LocalStorage.setToken(user.uid);
      } else {
        state = state.copyWith(isLoading: false);
      }
    } else {
      if (mounted) {
        // ignore: use_build_context_synchronously
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  Future<void> loginWithFacebook(BuildContext context) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isLoading: true);
      final fb = FacebookLogin();
      try {
        final user = await fb.logIn(permissions: []);

        final OAuthCredential credential =
            FacebookAuthProvider.credential(user.accessToken?.token ?? "");

        final userObj =
            await FirebaseAuth.instance.signInWithCredential(credential);

        if (user.status == FacebookLoginStatus.success) {
          final user = userObj.user;
          if (user != null) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .set({
              'fullname': user.displayName,
              'username': user.displayName,
              'email': user.email,
              'id': user.uid,
              'avatar': user.photoURL ?? "",
              'phonenumber': user.phoneNumber,
              'bio': '',
              'gender': '-',
              'birthday': '-',
              'created': DateTime.now(),
              'holidaymode': false,
            });

            state = state.copyWith(isLoading: false);
            // ignore: use_build_context_synchronously
            context.replaceRoute(const SelectUsernameRoute());
            LocalStorage.setToken(user.uid);
          } else {
            state = state.copyWith(isLoading: false);
          }
        } else {
          state = state.copyWith(isLoading: false);
          AppHelpers.showCheckTopSnackBar(
              // ignore: use_build_context_synchronously
              context,
              'somethingWentWrongWithTheServer'.tr());
        }
      } catch (e) {
        state = state.copyWith(isLoading: false);
        debugPrint('===> login with face exception: $e');
      }
    } else {
      if (mounted) {
        // ignore: use_build_context_synchronously
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  Future<void> loginWithApple(BuildContext context) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isLoading: true);

      try {
        final credential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
        );

        OAuthProvider oAuthProvider = OAuthProvider("apple.com");
        final AuthCredential credentialApple = oAuthProvider.credential(
          idToken: credential.identityToken,
          accessToken: credential.authorizationCode,
        );

        final userObj =
            await FirebaseAuth.instance.signInWithCredential(credentialApple);
        final user = userObj.user;

        if (user != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'fullname': user.displayName ?? credential.givenName ?? "-",
            'username': user.displayName ?? credential.givenName ?? "-",
            'email': user.email ?? credential.email ?? "-",
            'id': user.uid,
            'avatar': user.photoURL ?? "",
            'phonenumber': user.phoneNumber ?? "-",
            'bio': '',
            'gender': '-',
            'birthday': '-',
            'created': DateTime.now(),
            'holidaymode': false,
          });

          state = state.copyWith(isLoading: false);
          LocalStorage.setToken(user.uid);
          // ignore: use_build_context_synchronously
          context.replaceRoute(const SelectUsernameRoute());
        } else {
          state = state.copyWith(isLoading: false);
        }
      } catch (e) {
        state = state.copyWith(isLoading: false);
        debugPrint('===> login with apple exception: $e');
      }
    } else {
      if (mounted) {
        // ignore: use_build_context_synchronously
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  Future<void> checkUsernameExists(String username) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      state = state.copyWith(isUsernameInvalid: true);
    } else {
      state = state.copyWith(isUsernameInvalid: false);
    }
  }

  Future<void> changeUsername(String id) async {
    await FirebaseFirestore.instance.collection('users').doc(id).set({
      'username': state.username,
    }, SetOptions(merge: true));
    if (kDebugMode) {
      print('username changed: ${state.username}');
    }
  }

  Future<void> setName(String id) async {
    await FirebaseFirestore.instance.collection('users').doc(id).set({
      'fullname': state.fullname,
    }, SetOptions(merge: true));
    if (kDebugMode) {
      print('set fullname: ${state.fullname}');
    }
  }

  Future<void> selectLocation(String id, String location) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(id).set({
        'location': location,
      }, SetOptions(merge: true));
      if (kDebugMode) {
        print('selected location: $location');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error selecting location: $e');
      }
      throw Exception('Failed to update location');
    }
  }
}
