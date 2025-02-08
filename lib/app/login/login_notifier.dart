import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:listing/infrastructure/service/app_connectivity.dart';
import 'package:listing/infrastructure/service/app_helpers.dart';
import 'package:listing/infrastructure/service/app_validators.dart';
import 'package:listing/infrastructure/service/local_storage.dart';
import 'package:listing/presentation/routes/app_router.gr.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'login_state.dart';

class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier() : super(const LoginState());

  void setPassword(String text) {
    state = state.copyWith(
      password: text.trim(),
      isLoginError: false,
      isEmailNotValid: false,
      isPasswordNotValid: false,
    );
  }

  void setEmail(String text) {
    state = state.copyWith(
      email: text.trim(),
      isLoginError: false,
      isEmailNotValid: false,
      isPasswordNotValid: false,
    );
  }

  void setShowPassword(bool show) {
    state = state.copyWith(showPassword: show);
  }

  bool checkEmail() {
    return AppValidators.checkEmail(state.email);
  }

  Future<void> login(BuildContext context) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      if (checkEmail()) {
        if (!AppValidators.isValidEmail(state.email)) {
          state = state.copyWith(isEmailNotValid: true);
          return;
        }
      }

      if (!AppValidators.isValidPassword(state.password)) {
        state = state.copyWith(isPasswordNotValid: true);
        return;
      }

      state = state.copyWith(isLoading: true);

      try {
        final userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: state.email,
          password: state.password,
        );

        User? user = userCredential.user;

        if (userCredential.user != null) {
          // ignore: use_build_context_synchronously
          context.replaceRoute(const MainRoute());
          if (user != null) {
            LocalStorage.setToken(user.uid);
          }
        }
      } on FirebaseAuthException catch (e) {
        state = state.copyWith(isLoading: false, isLoginError: true);
        AppHelpers.showCheckTopSnackBar(
          // ignore: use_build_context_synchronously
          context,
          e.message ?? 'somethingWentWrongWithTheServer'.tr(),
        );
      }

      state = state.copyWith(isLoading: false);
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

      try {
        final googleUser = await GoogleSignIn().signIn();
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

        User? user = userCredential.user;

        if (userCredential.user != null) {
          // ignore: use_build_context_synchronously
          context.replaceRoute(const MainRoute());
          if (user != null) {
            LocalStorage.setToken(user.uid);
          }
        }
      } on FirebaseAuthException catch (e) {
        state = state.copyWith(isLoading: false);
        AppHelpers.showCheckTopSnackBar(
          // ignore: use_build_context_synchronously
          context,
          e.message ?? 'somethingWentWrongWithTheServer'.tr(),
        );
      }

      state = state.copyWith(isLoading: false);
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
        final result = await fb.logIn(permissions: [FacebookPermission.email]);

        switch (result.status) {
          case FacebookLoginStatus.success:
            final credential =
                FacebookAuthProvider.credential(result.accessToken!.token);
            final userCredential =
                await FirebaseAuth.instance.signInWithCredential(credential);

            User? user = userCredential.user;

            if (userCredential.user != null) {
              // ignore: use_build_context_synchronously
              context.replaceRoute(const MainRoute());
              if (user != null) {
                LocalStorage.setToken(user.uid);
              }
            }
            break;
          case FacebookLoginStatus.cancel:
          case FacebookLoginStatus.error:
            AppHelpers.showCheckTopSnackBar(
              // ignore: use_build_context_synchronously
              context,
              'somethingWentWrongWithTheServer'.tr(),
            );
            break;
        }
      } on FirebaseAuthException catch (e) {
        state = state.copyWith(isLoading: false);
        AppHelpers.showCheckTopSnackBar(
          // ignore: use_build_context_synchronously
          context,
          e.message ?? 'somethingWentWrongWithTheServer'.tr(),
        );
      }

      state = state.copyWith(isLoading: false);
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

        final userCredential =
            await FirebaseAuth.instance.signInWithCredential(credentialApple);

        User? user = userCredential.user;

        if (userCredential.user != null) {
          // ignore: use_build_context_synchronously
          context.replaceRoute(const MainRoute());
          if (user != null) {
            LocalStorage.setToken(user.uid);
          }
        }
      } on FirebaseAuthException catch (e) {
        state = state.copyWith(isLoading: false);
        AppHelpers.showCheckTopSnackBar(
          // ignore: use_build_context_synchronously
          context,
          e.message ?? 'somethingWentWrongWithTheServer'.tr(),
        );
      }

      state = state.copyWith(isLoading: false);
    } else {
      if (mounted) {
        // ignore: use_build_context_synchronously
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }
}
